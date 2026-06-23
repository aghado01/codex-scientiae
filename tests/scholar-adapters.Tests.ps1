#requires -Version 7.0
# OpenAlex + Semantic Scholar adapters — offline mapping tests. The network functions (Search/GetWork/
# Related/Resolve) are smoke-tested live elsewhere; here we pin the pure JSON->Work mappers + id helpers
# against hand-crafted fixtures matching the real (probed) response shapes.

BeforeAll {
    . "$PSScriptRoot/../src/scholar-core.ps1"
    . "$PSScriptRoot/../src/openalex.ps1"
    . "$PSScriptRoot/../src/semanticscholar.ps1"

    $script:OaWork = @'
{
  "id": "https://openalex.org/W2144044408",
  "doi": "https://doi.org/10.1007/S00454-004-1146-Y",
  "title": "Computing Persistent Homology",
  "publication_year": 2004,
  "cited_by_count": 1620,
  "referenced_works": ["https://openalex.org/W1","https://openalex.org/W2","https://openalex.org/W3"],
  "authorships": [ {"author":{"display_name":"Afra Zomorodian"}}, {"author":{"display_name":"Gunnar Carlsson"}} ],
  "primary_location": { "source": {"display_name":"Discrete & Computational Geometry"}, "pdf_url": null, "landing_page_url": "https://arxiv.org/abs/math/0508341" },
  "best_oa_location": { "pdf_url": "https://link.springer.com/x.pdf", "landing_page_url": "https://doi.org/10.1007/s00454-004-1146-y" },
  "locations": [],
  "ids": { "openalex":"https://openalex.org/W2144044408", "doi":"https://doi.org/10.1007/s00454-004-1146-y", "mag":"2144044408" },
  "abstract_inverted_index": { "Persistent":[0], "homology":[1], "is":[2], "computable":[3] },
  "topics": [ {"display_name":"Topological and Geometric Data Analysis"} ]
}
'@ | ConvertFrom-Json -AsHashtable   # OpenAlex mapper consumes hashtables (case-colliding abstract keys)

    $script:S2Paper = @'
{
  "paperId": "abc123def",
  "externalIds": { "DOI":"10.1007/S00454-004-1146-Y", "ArXiv":"2008.10579", "CorpusId": 99 },
  "title": "Compressive Phase Retrieval",
  "abstract": "We study compressive phase retrieval.",
  "year": 2020,
  "venue": "NeurIPS",
  "authors": [ {"authorId":"1","name":"Paul Hand"}, {"authorId":"2","name":"Vladislav Voroninski"} ],
  "citationCount": 42,
  "referenceCount": 30,
  "tldr": { "model":"x", "text":"A short summary." },
  "openAccessPdf": { "url":"https://arxiv.org/pdf/2008.10579", "status":"GREEN" },
  "fieldsOfStudy": ["Computer Science","Mathematics"]
}
'@ | ConvertFrom-Json
}

Describe 'ConvertFrom-OpenAlexAbstract' {
    It 'rebuilds linear text from the inverted index' {
        ConvertFrom-OpenAlexAbstract $script:OaWork.abstract_inverted_index | Should -Be 'Persistent homology is computable'
    }
    It 'returns null for a missing abstract' {
        ConvertFrom-OpenAlexAbstract $null | Should -BeNullOrEmpty
    }
}

Describe 'ConvertFrom-OpenAlexWork' {
    BeforeAll { $script:w = ConvertFrom-OpenAlexWork $script:OaWork }
    It 'maps the core fields and normalizes the doi' {
        $w.source         | Should -Be 'openalex'
        $w.source_id      | Should -Be 'W2144044408'
        $w.doi            | Should -Be '10.1007/s00454-004-1146-y'
        $w.title          | Should -Be 'Computing Persistent Homology'
        $w.authors        | Should -Be @('Afra Zomorodian','Gunnar Carlsson')
        $w.year           | Should -Be 2004
        $w.venue          | Should -Be 'Discrete & Computational Geometry'
        $w.citation_count | Should -Be 1620
        $w.references_count | Should -Be 3
        $w.pdf_url        | Should -Be 'https://link.springer.com/x.pdf'
        $w.fields         | Should -Be @('Topological and Geometric Data Analysis')
        $w.abstract       | Should -Be 'Persistent homology is computable'
    }
    It 'recovers an arXiv id from an arxiv.org location url' {
        $w.arxiv_id | Should -Be 'math/0508341'
    }
}

Describe 'ConvertFrom-S2Paper' {
    BeforeAll { $script:p = ConvertFrom-S2Paper $script:S2Paper }
    It 'maps fields, normalizes the doi, and lifts arXiv id + tldr' {
        $p.source           | Should -Be 'semanticscholar'
        $p.source_id        | Should -Be 'abc123def'
        $p.doi              | Should -Be '10.1007/s00454-004-1146-y'
        $p.arxiv_id         | Should -Be '2008.10579'
        $p.authors          | Should -Be @('Paul Hand','Vladislav Voroninski')
        $p.year             | Should -Be 2020
        $p.venue            | Should -Be 'NeurIPS'
        $p.citation_count   | Should -Be 42
        $p.references_count | Should -Be 30
        $p.tldr             | Should -Be 'A short summary.'
        $p.fields           | Should -Be @('Computer Science','Mathematics')
        $p.pdf_url          | Should -Be 'https://arxiv.org/pdf/2008.10579'
    }
    It 'returns null for an empty/keyless object' {
        ConvertFrom-S2Paper ([pscustomobject]@{}) | Should -BeNullOrEmpty
    }
}

Describe 'cross-walk: the same paper dedups to one key across sources' {
    It 'OpenAlex and S2 records share a DOI key' {
        $oa = ConvertFrom-OpenAlexWork $script:OaWork
        $s2 = ConvertFrom-S2Paper $script:S2Paper
        Get-ScholarWorkKey $oa | Should -Be (Get-ScholarWorkKey $s2)   # both -> doi:10.1007/s00454-004-1146-y
    }
}

Describe 'id key normalization' {
    It 'OpenAlex keys: W-id, DOI url, bare DOI' {
        ConvertTo-OpenAlexKey 'https://openalex.org/W42' | Should -Be 'W42'
        ConvertTo-OpenAlexKey 'https://doi.org/10.1/x'   | Should -Be 'doi:10.1/x'
        ConvertTo-OpenAlexKey '10.1/x'                   | Should -Be 'doi:10.1/x'
    }
    It 'S2 keys: typed passthrough, bare DOI, bare arXiv id' {
        ConvertTo-S2Key 'DOI:10.1/x'   | Should -Be 'DOI:10.1/x'
        ConvertTo-S2Key '10.1/x'       | Should -Be 'DOI:10.1/x'
        ConvertTo-S2Key '2008.10579'   | Should -Be 'ARXIV:2008.10579'
    }
}
