#requires -Version 7.0
# codex-arxiv core (arxiv.ps1). Offline only — no network: we exercise id handling, the data-driven
# layout seam (template expansion + path confinement), Atom parsing from a fixture, and query building.

BeforeAll {
    . "$PSScriptRoot/../src/arxiv.ps1"

    # A minimal-but-faithful arXiv Atom feed: two entries, new- and old-style ids, primary_category,
    # a pdf link, a doi, and whitespace in the title/summary to prove collapsing + the external mark.
    $script:AtomFixture = @'
<?xml version="1.0" encoding="UTF-8"?>
<feed xmlns="http://www.w3.org/2005/Atom" xmlns:arxiv="http://arxiv.org/schemas/atom" xmlns:opensearch="http://a9.com/-/spec/opensearch/1.1/">
  <opensearch:totalResults>4823</opensearch:totalResults>
  <opensearch:startIndex>0</opensearch:startIndex>
  <opensearch:itemsPerPage>2</opensearch:itemsPerPage>
  <entry>
    <id>http://arxiv.org/abs/2008.10579v1</id>
    <title>Neural
      Manifolds</title>
    <summary>We study   the geometry
      of population activity.</summary>
    <published>2020-08-24T17:59:00Z</published>
    <updated>2020-09-01T00:00:00Z</updated>
    <author><name>Ada Lovelace</name></author>
    <author><name>Alan Turing</name></author>
    <arxiv:primary_category term="q-bio.NC"/>
    <category term="q-bio.NC"/>
    <category term="cs.LG"/>
    <arxiv:doi>10.1234/example.5678</arxiv:doi>
    <link title="pdf" href="http://arxiv.org/pdf/2008.10579v1"/>
  </entry>
  <entry>
    <id>http://arxiv.org/abs/math.GT/0309136</id>
    <title>An Old Style Paper</title>
    <summary>Legacy identifier scheme.</summary>
    <published>2003-09-08T00:00:00Z</published>
    <author><name>Henri Poincare</name></author>
    <arxiv:primary_category term="math.GT"/>
    <category term="math.GT"/>
  </entry>
</feed>
'@
}

Describe 'Test-ArxivId' {
    It 'accepts new-style ids with and without version' {
        Test-ArxivId '2008.10579'   | Should -BeTrue
        Test-ArxivId '2008.10579v3' | Should -BeTrue
        Test-ArxivId '1234.5678'    | Should -BeTrue
    }
    It 'accepts old-style ids' {
        Test-ArxivId 'math.GT/0309136' | Should -BeTrue
        Test-ArxivId 'hep-th/9901001'  | Should -BeTrue
    }
    It 'rejects junk and traversal attempts' {
        Test-ArxivId ''               | Should -BeFalse
        Test-ArxivId '../etc/passwd'  | Should -BeFalse
        Test-ArxivId 'not an id'      | Should -BeFalse
        Test-ArxivId '2008.10579;rm'  | Should -BeFalse
    }
}

Describe 'Split-ArxivId' {
    It 'separates version from the short key' {
        $p = Split-ArxivId '2008.10579v2'
        $p.Short     | Should -Be '2008.10579'
        $p.Versioned | Should -Be '2008.10579v2'
        $p.Version   | Should -Be 2
    }
    It 'leaves an unversioned id intact' {
        (Split-ArxivId '2008.10579').Version | Should -BeNullOrEmpty
    }
}

Describe 'ConvertTo-ArxivPathSlug' {
    It 'makes old-style ids filesystem-safe' {
        ConvertTo-ArxivPathSlug 'math.GT/0309136' | Should -Be 'math.GT_0309136'
    }
    It 'throws on a value that sanitizes to empty' {
        { ConvertTo-ArxivPathSlug '///' } | Should -Throw
    }
}

Describe 'Get-ArxivConfig' {
    It 'falls back to the built-in default when no file exists' {
        $c = Get-ArxivConfig -Path (Join-Path $TestDrive 'nope.json')
        $c.staging_root | Should -Be 'ingestion/_inbox'
        $c.slug         | Should -Be '{idv}'
    }
    It 'fills missing fields from the default for a partial config' {
        $f = Join-Path $TestDrive 'partial.json'
        '{ "staging_root": "custom/inbox" }' | Set-Content -LiteralPath $f -Encoding utf8
        $c = Get-ArxivConfig -Path $f
        $c.staging_root  | Should -Be 'custom/inbox'
        $c.slug          | Should -Be '{idv}'        # filled
        $c.layout.pdf    | Should -Be '{slug}/{slug}.pdf'
    }
}

Describe 'Resolve-ArxivStageTarget' {
    BeforeAll {
        $script:meta = [pscustomobject]@{ id = '2008.10579v1'; published = '2020-08-24T00:00:00Z'; primary_category = 'q-bio.NC' }
        $script:cfg  = Get-ArxivConfig -Path 'does-not-exist'
        $script:root = Join-Path $TestDrive 'inbox'
    }
    It 'expands the default template (all artifact keys) under the staging root' {
        $t = Resolve-ArxivStageTarget -Meta $script:meta -Config $script:cfg -StagingRoot $script:root
        $t.Slug | Should -Be '2008.10579v1'
        $t.Artifacts.pdf    | Should -Be (Join-Path $script:root '2008.10579v1/2008.10579v1.pdf')
        $t.Artifacts.source | Should -Be (Join-Path $script:root '2008.10579v1/2008.10579v1.tar.gz')
        $t.Artifacts.html   | Should -Be (Join-Path $script:root '2008.10579v1/2008.10579v1.html')
        $t.Metadata         | Should -Be (Join-Path $script:root '2008.10579v1/2008.10579v1.arxiv.json')
        # dir/metadata are not artifacts
        $t.Artifacts.ContainsKey('metadata') | Should -BeFalse
    }
    It 'honours a re-pointed layout template (conventions are data)' {
        $alt = [pscustomobject]@{
            staging_root = 'x'; slug = '{year}-{id}'
            layout = [pscustomobject]@{ dir = '{primary_category}/{slug}'; pdf = '{primary_category}/{slug}/paper.pdf'; metadata = '{primary_category}/{slug}/meta.arxiv.json' }
        }
        $t = Resolve-ArxivStageTarget -Meta $script:meta -Config $alt -StagingRoot $script:root
        $t.Slug | Should -Be '2020-2008.10579'
        $t.Artifacts.pdf | Should -Be (Join-Path $script:root 'q-bio.NC/2020-2008.10579/paper.pdf')
    }
    It 'refuses a template that escapes the staging root' {
        $escape = [pscustomobject]@{ slug = '{idv}'; layout = [pscustomobject]@{ dir = '../../etc'; pdf = '../../etc/x.pdf'; metadata = '../../etc/x.json' } }
        { Resolve-ArxivStageTarget -Meta $script:meta -Config $escape -StagingRoot $script:root } | Should -Throw
    }
}

Describe 'Get-ArxivTransience (retry policy)' {
    It 'retries transient transport failures (DNS/connection/timeout)' {
        (Get-ArxivTransience -Code 0 -Message 'No such host is known. (export.arxiv.org:443)').Transient | Should -BeTrue
        (Get-ArxivTransience -Code 0 -Message 'The connection was reset').Transient | Should -BeTrue
        (Get-ArxivTransience -Code 0 -Message 'The operation timed out').Transient | Should -BeTrue
    }
    It 'retries genuine 5xx server errors' {
        (Get-ArxivTransience -Code 500 -Message 'x').Transient | Should -BeTrue
        (Get-ArxivTransience -Code 502 -Message 'x').Transient | Should -BeTrue
        (Get-ArxivTransience -Code 504 -Message 'x').Transient | Should -BeTrue
    }
    It 'fast-fails rate limiting (429/503) so it does not deepen a ban' {
        (Get-ArxivTransience -Code 429 -Message 'x').Transient | Should -BeFalse
        $r = Get-ArxivTransience -Code 503 -Message 'x'
        $r.Transient | Should -BeFalse
        $r.Message   | Should -BeLike '*rate limiting*'
    }
    It 'fast-fails permanent 4xx (bad query / missing artifact)' {
        (Get-ArxivTransience -Code 400 -Message 'x').Transient | Should -BeFalse
        (Get-ArxivTransience -Code 404 -Message 'x').Transient | Should -BeFalse
    }
    It 'does not retry an unrecognized transport error' {
        (Get-ArxivTransience -Code 0 -Message 'something exotic').Transient | Should -BeFalse
    }
}

Describe 'Get-ArxivPayloadKind' {
    It 'classifies by magic bytes / leading text' {
        Get-ArxivPayloadKind -Head ([byte[]](0x25,0x50,0x44,0x46,0x2D))             | Should -Be 'pdf'    # %PDF-
        Get-ArxivPayloadKind -Head ([byte[]](0x1F,0x8B,0x08,0x00))                  | Should -Be 'gzip'   # gzip
        Get-ArxivPayloadKind -Head ([byte[]][Text.Encoding]::ASCII.GetBytes('<!DOCTYPE html>')) | Should -Be 'html'
        Get-ArxivPayloadKind -Head ([byte[]](0x00,0x01,0x02,0x03))                  | Should -Be 'unknown'
    }
}

Describe 'Get-ArxivInbox (empty)' {
    It 'reports zero for an absent or fresh staging root (no unary-comma false-count)' {
        $cfg   = Get-ArxivConfig -Path 'does-not-exist'
        $empty = Join-Path $TestDrive 'empty-inbox'
        @(Get-ArxivInbox -Config $cfg -StagingRoot $empty -RepoRoot $TestDrive).Count | Should -Be 0
        New-Item -ItemType Directory -Force -Path $empty | Out-Null
        @(Get-ArxivInbox -Config $cfg -StagingRoot $empty -RepoRoot $TestDrive).Count | Should -Be 0
    }
}

Describe 'ConvertFrom-ArxivAtom' {
    BeforeAll { $script:papers = ConvertFrom-ArxivAtom $script:AtomFixture }
    It 'parses both entries' { $script:papers.Count | Should -Be 2 }
    It 'splits id/idv and collapses whitespace in the title' {
        $p = $script:papers[0]
        $p.id    | Should -Be '2008.10579'
        $p.idv   | Should -Be '2008.10579v1'
        $p.title | Should -Be 'Neural Manifolds'
    }
    It 'tags the abstract as external/untrusted and collapses whitespace' {
        # exact match (not -BeLike: its [..] is a char-class wildcard and would mis-read the marker)
        $script:papers[0].abstract | Should -Be '[external:untrusted] We study the geometry of population activity.'
    }
    It 'captures authors, primary category, doi, and pdf link' {
        $p = $script:papers[0]
        $p.authors          | Should -Be @('Ada Lovelace','Alan Turing')
        $p.primary_category | Should -Be 'q-bio.NC'
        $p.categories       | Should -Be @('q-bio.NC','cs.LG')
        $p.doi              | Should -Be '10.1234/example.5678'
        $p.pdf_url          | Should -Be 'http://arxiv.org/pdf/2008.10579v1'
    }
    It 'handles old-style ids and synthesizes a pdf url when none is linked' {
        $p = $script:papers[1]
        $p.id      | Should -Be 'math.GT/0309136'
        $p.pdf_url | Should -Be 'https://arxiv.org/pdf/math.GT/0309136'
    }
}

Describe 'Get-ArxivFeedMeta (pagination counters)' {
    It 'reads the OpenSearch total/start/per-page for paged hunting' {
        $m = Get-ArxivFeedMeta $script:AtomFixture
        $m.total    | Should -Be 4823
        $m.start    | Should -Be 0
        $m.per_page | Should -Be 2
    }
    It 'returns -1 for counters arXiv omits' {
        $bare = '<feed xmlns="http://www.w3.org/2005/Atom"></feed>'
        (Get-ArxivFeedMeta $bare).total | Should -Be -1
    }
}

Describe 'Build-ArxivSearchQuery' {
    It 'joins parts with AND and OR-filters categories (each part parenthesized, per arXiv form)' {
        $q = Build-ArxivSearchQuery -Query 'ti:"neural manifolds"' -Categories @('q-bio.NC','cs.LG')
        $q | Should -Be '(ti:"neural+manifolds")+AND+(cat:q-bio.NC+OR+cat:cs.LG)'
    }
    It 'builds a submitted-date window with a literal +TO+' {
        $q = Build-ArxivSearchQuery -Query 'topology' -DateFrom '2020-01-01' -DateTo '2020-12-31'
        $q | Should -Be '(topology)+AND+submittedDate:[202001010000+TO+202012312359]'
    }
    It 'throws when no criteria are supplied' {
        { Build-ArxivSearchQuery -Query '' } | Should -Throw
    }
}

Describe 'async fetch jobs' {
    # Offline coverage of the job registry. We set up the registry + queue directly (NOT via
    # Initialize-ArxivJobs, which would spin a worker runspace that hits the network) so enqueue, the
    # output projection, and TTL eviction are all exercised without touching arXiv. The live worker path
    # is verified by an integration probe, not here.
    Context 'ConvertTo-ArxivJobView (output projection)' {
        It 'surfaces result only when done' {
            $rec = @{ id='job-1'; arxiv_id='2008.10579'; artifacts=@('pdf'); status='done'
                      enqueued_at='t0'; started_at='t1'; finished_at='t2'; result=[pscustomobject]@{ ok=$true }; reason=$null }
            $v = ConvertTo-ArxivJobView $rec
            $v.status                     | Should -Be 'done'
            $v.PSObject.Properties.Name   | Should -Contain 'result'
            $v.PSObject.Properties.Name   | Should -Not -Contain 'reason'
        }
        It 'surfaces reason only when failed' {
            $rec = @{ id='job-2'; arxiv_id='x'; artifacts=@('pdf'); status='failed'
                      enqueued_at='t0'; started_at='t1'; finished_at='t2'; result=$null; reason='boom' }
            $v = ConvertTo-ArxivJobView $rec
            $v.reason                   | Should -Be 'boom'
            $v.PSObject.Properties.Name | Should -Not -Contain 'result'
        }
        It 'omits both while still running' {
            $rec = @{ id='job-3'; arxiv_id='x'; artifacts=@('pdf'); status='running'
                      enqueued_at='t0'; started_at='t1'; finished_at=$null; result=$null; reason=$null }
            $v = ConvertTo-ArxivJobView $rec
            $v.PSObject.Properties.Name | Should -Not -Contain 'result'
            $v.PSObject.Properties.Name | Should -Not -Contain 'reason'
        }
    }
    Context 'enqueue + registry (no worker)' {
        BeforeEach {
            $script:ArxivJobs     = [System.Collections.Concurrent.ConcurrentDictionary[string,hashtable]]::new()
            $script:ArxivQueue    = [System.Collections.Concurrent.BlockingCollection[string]]::new()
            $script:ArxivWorkerPS = $null   # no live worker in these offline tests
        }
        AfterEach { $script:ArxivJobs = $null; $script:ArxivQueue = $null }

        It 'rejects an invalid id synchronously (no job created)' {
            { Add-ArxivFetchJob -Id 'not-an-id' } | Should -Throw
            $script:ArxivQueue.Count | Should -Be 0
        }
        It 'enqueues a valid id as a queued job with lowercased, de-duped artifacts' {
            $j = Add-ArxivFetchJob -Id '2008.10579' -Artifacts @('SOURCE','pdf','source')
            $j.status                | Should -Be 'queued'
            $j.artifacts             | Should -Be @('source','pdf')
            $script:ArxivQueue.Count | Should -Be 1
            (Get-ArxivFetchJob -JobId $j.job_id).status | Should -Be 'queued'
        }
        It 'evicts terminal jobs past the TTL but keeps queued/running' {
            $old  = @{ id='job-old'; arxiv_id='x'; artifacts=@('pdf'); status='done'
                       enqueued_at='t'; started_at='t'; finished_at=(Get-Date).AddMinutes(-60).ToString('o'); result=$null; reason=$null }
            $live = @{ id='job-live'; arxiv_id='y'; artifacts=@('pdf'); status='running'
                       enqueued_at='t'; started_at='t'; finished_at=$null; result=$null; reason=$null }
            [void]$script:ArxivJobs.TryAdd('job-old', $old)
            [void]$script:ArxivJobs.TryAdd('job-live', $live)
            Clear-ArxivStaleJobs -TtlMinutes 30
            $script:ArxivJobs.ContainsKey('job-old')  | Should -BeFalse
            $script:ArxivJobs.ContainsKey('job-live') | Should -BeTrue
        }
        It 'long-poll returns immediately for an already-terminal job' {
            $done = @{ id='job-done'; arxiv_id='x'; artifacts=@('pdf'); status='done'
                       enqueued_at='t'; started_at='t'; finished_at='t'; result=[pscustomobject]@{ ok=$true }; reason=$null }
            [void]$script:ArxivJobs.TryAdd('job-done', $done)
            $sw = [System.Diagnostics.Stopwatch]::StartNew()
            $v  = Get-ArxivFetchJob -JobId 'job-done' -WaitSeconds 5
            $sw.Stop()
            $v.status                | Should -Be 'done'
            $sw.Elapsed.TotalSeconds | Should -BeLessThan 1
        }
        It 'long-poll on a running job with a dead worker bails fast and flags it stalled' {
            $run = @{ id='job-run'; arxiv_id='x'; artifacts=@('pdf'); status='running'
                      enqueued_at='t'; started_at='t'; finished_at=$null; result=$null; reason=$null }
            [void]$script:ArxivJobs.TryAdd('job-run', $run)      # $script:ArxivWorkerPS is $null => worker dead
            $sw = [System.Diagnostics.Stopwatch]::StartNew()
            $v  = Get-ArxivFetchJob -JobId 'job-run' -WaitSeconds 5
            $sw.Stop()
            $v.status                     | Should -Be 'running'
            $v.stalled                    | Should -BeTrue
            $v.PSObject.Properties.Name   | Should -Contain 'worker_error'
            $sw.Elapsed.TotalSeconds      | Should -BeLessThan 1
        }
    }
    It 'refuses to enqueue when jobs are not initialized' {
        $script:ArxivJobs = $null
        { Add-ArxivFetchJob -Id '2008.10579' } | Should -Throw '*not initialized*'
    }
}
