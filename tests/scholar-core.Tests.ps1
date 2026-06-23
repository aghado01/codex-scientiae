#requires -Version 7.0
# scholar-core (scholar-core.ps1) — the source-agnostic discovery core. Offline only: retry policy,
# the Work model + DOI/key helpers, the paging envelope, and the per-host rate clock's bookkeeping.

BeforeAll {
    . "$PSScriptRoot/../src/scholar-core.ps1"
}

Describe 'Get-ScholarTransience (retry policy)' {
    It 'retries transient transport failures' {
        (Get-ScholarTransience -Code 0 -Message 'No such host is known. (api.openalex.org:443)').Transient | Should -BeTrue
        (Get-ScholarTransience -Code 0 -Message 'The connection was reset').Transient | Should -BeTrue
        (Get-ScholarTransience -Code 0 -Message 'The operation timed out').Transient | Should -BeTrue
    }
    It 'retries 5xx server errors but fast-fails 429/503 and 4xx' {
        (Get-ScholarTransience -Code 500 -Message 'x').Transient | Should -BeTrue
        (Get-ScholarTransience -Code 502 -Message 'x').Transient | Should -BeTrue
        (Get-ScholarTransience -Code 429 -Message 'x').Transient | Should -BeFalse
        (Get-ScholarTransience -Code 503 -Message 'x').Transient | Should -BeFalse
        (Get-ScholarTransience -Code 404 -Message 'x').Transient | Should -BeFalse
    }
}

Describe 'ConvertTo-NormalizedDoi' {
    It 'strips scheme/host/doi prefixes and lowercases' {
        ConvertTo-NormalizedDoi 'https://doi.org/10.1234/ABC.def' | Should -Be '10.1234/abc.def'
        ConvertTo-NormalizedDoi 'http://dx.doi.org/10.1/X'        | Should -Be '10.1/x'
        ConvertTo-NormalizedDoi 'doi:10.5/Y'                      | Should -Be '10.5/y'
        ConvertTo-NormalizedDoi '10.7/Z'                          | Should -Be '10.7/z'
    }
    It 'returns null for empty input' {
        ConvertTo-NormalizedDoi '   ' | Should -BeNullOrEmpty
    }
}

Describe 'Get-ScholarWorkKey (dedup identity)' {
    It 'prefers DOI, then arXiv id, then source:id' {
        Get-ScholarWorkKey (New-ScholarWork -Source openalex -SourceId W1 -Doi '10.1/A' -ArxivId '2008.10579') | Should -Be 'doi:10.1/a'
        Get-ScholarWorkKey (New-ScholarWork -Source s2 -SourceId P9 -ArxivId '2008.10579V1')                  | Should -Be 'arxiv:2008.10579v1'
        Get-ScholarWorkKey (New-ScholarWork -Source s2 -SourceId P9)                                          | Should -Be 's2:P9'
    }
}

Describe 'New-ScholarWork (normalized shape)' {
    It 'fills every field, defaulting unset to null/empty and normalizing the doi' {
        $w = New-ScholarWork -Source openalex -SourceId W42 -Doi 'HTTPS://DOI.ORG/10.1/Q' -Title 'T' -Authors @('A','B') -Year 2020 -CitationCount 7
        $w.source           | Should -Be 'openalex'
        $w.doi              | Should -Be '10.1/q'
        $w.authors          | Should -Be @('A','B')
        $w.year             | Should -Be 2020
        $w.citation_count   | Should -Be 7
        $w.arxiv_id         | Should -BeNullOrEmpty   # unset
        $w.references_count | Should -BeNullOrEmpty   # unset (-1 -> null)
        $w.fields           | Should -Be @()
        # the shape is stable: the key set is always the same regardless of which fields were supplied
        ($w.PSObject.Properties.Name | Sort-Object) | Should -Be (@('abstract','arxiv_id','authors','citation_count','doi','external_ids','fields','oa_url','pdf_url','references_count','source','source_id','title','tldr','venue','year') | Sort-Object)
    }
}

Describe 'New-ScholarPage (paging envelope)' {
    It 'computes next_start when more pages remain' {
        $p = New-ScholarPage -Source openalex -Total 100 -Start 0 -Works @((New-ScholarWork -Source openalex -SourceId A), (New-ScholarWork -Source openalex -SourceId B))
        $p.returned   | Should -Be 2
        $p.next_start | Should -Be 2
    }
    It 'returns next_start -1 when exhausted or total is unknown' {
        (New-ScholarPage -Source s2 -Total 2 -Start 0 -Works @((New-ScholarWork -Source s2 -SourceId A),(New-ScholarWork -Source s2 -SourceId B))).next_start | Should -Be -1
        (New-ScholarPage -Source s2 -Total -1 -Start 0 -Works @((New-ScholarWork -Source s2 -SourceId A))).next_start | Should -Be -1
    }
}

Describe 'Merge-ScholarWork / Merge-ScholarWorks (cross-source dedup)' {
    It 'merges two records of the same paper, filling nulls and unioning sources' {
        $a = New-ScholarWork -Source openalex       -SourceId W1 -Doi '10.1/x' -Title 'A Paper' -Authors @('X','Y') -CitationCount 10 -Fields @('Math')
        $b = New-ScholarWork -Source semanticscholar -SourceId P1 -Doi '10.1/x' -Tldr 'short' -ArxivId '2008.10579' -Fields @('CS')
        $m = Merge-ScholarWork $a $b
        $m.source   | Should -Be 'openalex+semanticscholar'
        $m.title    | Should -Be 'A Paper'        # from A
        $m.tldr     | Should -Be 'short'          # filled from B
        $m.arxiv_id | Should -Be '2008.10579'     # filled from B
        $m.citation_count | Should -Be 10
        ($m.fields | Sort-Object) | Should -Be @('CS','Math')
    }
    It 'dedups a mixed list by DOI/arXiv/source key' {
        $works = @(
            (New-ScholarWork -Source openalex       -SourceId W1 -Doi '10.1/x' -Title 'A'),
            (New-ScholarWork -Source semanticscholar -SourceId P1 -Doi '10.1/X' -Tldr 't'),   # same DOI (case-insensitive)
            (New-ScholarWork -Source openalex       -SourceId W2 -Doi '10.2/y' -Title 'B')
        )
        $merged = Merge-ScholarWorks $works
        $merged.Count | Should -Be 2
        ($merged | Where-Object { $_.doi -eq '10.1/x' }).source | Should -Be 'openalex+semanticscholar'
    }
}

Describe 'Wait-ScholarRate (per-host clock)' {
    It 'records a per-key timestamp and no-ops a zero interval' {
        Wait-ScholarRate -Key 'host-a' -MinIntervalMs 50
        $script:ScholarLastRequest.ContainsKey('host-a') | Should -BeTrue
        # zero interval is a no-op and must not throw or record
        { Wait-ScholarRate -Key 'host-z' -MinIntervalMs 0 } | Should -Not -Throw
        $script:ScholarLastRequest.ContainsKey('host-z') | Should -BeFalse
    }
}
