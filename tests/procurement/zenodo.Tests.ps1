#requires -Version 7.0
# Zenodo procurement & adapter offline unit tests.

BeforeAll {
    . "$PSScriptRoot/../../src/procurement/scholar-core.ps1"
    . "$PSScriptRoot/../../src/procurement/zenodo.ps1"
    . "$PSScriptRoot/../../src/procurement/zenodo-adapter.ps1"

    $script:ZenodoFixture = @'
{
  "id": 1234567,
  "doi": "10.5281/zenodo.1234567",
  "metadata": {
    "title": "Sample Zenodo Dataset and Paper Source",
    "description": "<p>This is a test description for a Zenodo record.</p>",
    "publication_date": "2026-05-15",
    "resource_type": { "type": "publication" },
    "creators": [
      { "name": "Hand, Paul" },
      { "name": "Voroninski, Vladislav" }
    ],
    "keywords": ["topology", "data science"]
  },
  "links": {
    "html": "https://zenodo.org/records/1234567"
  },
  "files": [
    {
      "key": "paper.pdf",
      "checksum": "md5:1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d",
      "size": 102400,
      "links": {
        "self": "https://zenodo.org/api/records/1234567/files/paper.pdf/content"
      }
    },
    {
      "key": "source.tar.gz",
      "checksum": "md5:9f8e7d6c5b4a3f2e1d0c9b8a7f6e5d4c",
      "size": 204800,
      "links": {
        "self": "https://zenodo.org/api/records/1234567/files/source.tar.gz/content"
      }
    }
  ]
}
'@ | ConvertFrom-Json
}

Describe 'Zenodo ID validation & parsing' {
    It 'validates integer record IDs and DOIs' {
        Test-ZenodoId '1234567'                   | Should -Be $true
        Test-ZenodoId '10.5281/zenodo.1234567'    | Should -Be $true
        Test-ZenodoId 'zenodo.1234567'           | Should -Be $true
        Test-ZenodoId 'invalid-id'                | Should -Be $false
        Test-ZenodoId ''                          | Should -Be $false
    }

    It 'splits Zenodo IDs into components' {
        $split = Split-ZenodoId '10.5281/zenodo.1234567'
        $split.RecordId | Should -Be '1234567'
        $split.Doi      | Should -Be '10.5281/zenodo.1234567'
        $split.Slug     | Should -Be 'zenodo_1234567'
    }
}

Describe 'Zenodo layout target resolution' {
    It 'expands templates into stage target object' {
        $cfg = Get-ZenodoConfig 'D:\aghado01\codex-scientiae\src\procurement\zenodo-staging.json'
        $target = Resolve-ZenodoStageTarget -Meta $script:ZenodoFixture -Config $cfg -StagingRoot 'D:\aghado01\codex-scientiae\ingestion\_inbox'
        $target.Slug | Should -Be 'zenodo_1234567'
        $target.Artifacts['pdf'] | Should -Match 'ingestion[/\\]_inbox[/\\]zenodo_1234567[/\\]zenodo_1234567\.pdf'
    }
}

Describe 'ConvertFrom-ZenodoToWork' {
    BeforeAll { $script:w = ConvertFrom-ZenodoToWork $script:ZenodoFixture }

    It 'maps core fields to ScholarWork model' {
        $w.source    | Should -Be 'zenodo'
        $w.source_id | Should -Be '1234567'
        $w.doi       | Should -Be '10.5281/zenodo.1234567'
        $w.title     | Should -Be 'Sample Zenodo Dataset and Paper Source'
        $w.authors   | Should -Be @('Hand, Paul', 'Voroninski, Vladislav')
        $w.year      | Should -Be 2026
        $w.abstract  | Should -Be 'This is a test description for a Zenodo record.'
        $w.pdf_url   | Should -Be 'https://zenodo.org/api/records/1234567/files/paper.pdf/content'
        $w.fields    | Should -Be @('topology', 'data science')
    }

    It 'generates standard ScholarWork key' {
        Get-ScholarWorkKey $script:w | Should -Be 'doi:10.5281/zenodo.1234567'
    }
}
