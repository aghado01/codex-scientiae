The parser errors we encountered are actually structural characteristics shared by both PowerShell 5 and 7+:

1. Drive-style Variable Interpolation ( $var: ):
   In all versions of PowerShell, a colon immediately following a variable name in double quotes (e.g., "slug:title"
   env:Path or $global:var ). Because the colon is followed by a space, it throws the
   InvalidVariableReferenceWithDrive` parser error.
2. Piping the foreach Statement:
   Unlike ForEach-Object (or its alias % ), the language keyword foreach (xiny(foreach ...) | Out-String or & {
   foreach ... } | Out-String ).
3. Fixed-size Arrays ( @() ):
   Standard PowerShell arrays ( @() ) compile to a fixed-size System.Object[] . Calling .Add() on them throws a
   Collection was of a fixed size exception in both 5.x and 7.x. One must use array concatenation ( += ) or a wrapper
   like [System.Collections.Generic.List[T]] / [System.Collections.ArrayList] .

### The Core Ingestion Obstacle: Standard Output Encoding on Windows

The primary reason python and the PowerShell-Exec server returned None when retrieving raw contents from
1602.04426v2.md was console output encoding.

• The file contains the Unicode typographic ligature ﬁ ( \ufb01 ).
• On Windows, the default console output encoding (OEM code page) is cp1252 .
• When standard output or python tried to serialize and write the raw text containing the ligature to the output
stream, it crashed with a UnicodeEncodeError because \ufb01 cannot be mapped to the cp1252 character set.

### Recommendations for the MCP Server

To make the MCP server more robust for Windows users without needing custom client-side python wrappers:

• Enforce UTF-8 Streams in Python: Ensure standard input/output streams are configured to use UTF-8 (e.g., by
ensuring PYTHONUTF8=1 is set in the execution environment).
• Console Codepage (chcp): The MCP server or PowerShell session runner can explicitly set the console output
codepage to UTF-8 ( chcp 65001 or [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 ) before running
external scripts.
