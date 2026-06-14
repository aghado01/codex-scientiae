$path = "c:\Users\azrie\PDenv\UserGithub\codex-scientiae\ingestion\compendia\ph\AL2026\.scratch\manifest_057.md"
$text = [System.IO.File]::ReadAllText($path)
$idx = $text.IndexOf("## REPAIR_MATH", 20)
if ($idx -gt 0) {
    $text = $text.Substring(0, $idx)
}
$newContent = @"
- RAW: ````
Here, P ′ ( g 1 )(1 ′ , 2 , 3 ′ ) = P ′ ( g 1 )(1 ′ ) ⊕ P ′ ( g 1 )(2) ⊕ P ′ ( g 1 )(3 ′ ) and
````
  FIX: ````
Here, \( P^{\prime}(g_{1})(1^{\prime}, 2, 3^{\prime}) = P^{\prime}(g_{1})(1^{\prime}) \oplus P^{\prime}(g_{1})(2) \oplus P^{\prime}(g_{1})(3^{\prime}) \) and
````
- RAW: ````
Therefore, we may have an identification P ′ ( g 1 )(1 ′ ) = 0 − 1 0 0 . Similarly, we have identifications P ′ ( g 1 )(2) = [ 1 0 1 0 ] and P ′ ( g 1 )(3 ′ ) = [ 0 0 0 0 ] , and hence we have
````
  FIX: ````
Therefore, we may have an identification \( P^{\prime}(g_{1})(1^{\prime}) = \left[ \begin{smallmatrix} 0 & -1 \\ 0 & 0 \end{smallmatrix} \right] \). Similarly, we have identifications \( P^{\prime}(g_{1})(2) = \left[ \begin{smallmatrix} 1 & 0 \\ 1 & 0 \end{smallmatrix} \right] \) and \( P^{\prime}(g_{1})(3^{\prime}) = \left[ \begin{smallmatrix} 0 & 0 \\ 0 & 0 \end{smallmatrix} \right] \), and hence we have
````

## REPAIR_PROSE
- RAW: ````
0 0 ⊕ 0 0 ⊕ 0 0 Moreover, P ′ (2 ′ , 4 ′ )( α ): P ′ (2 ′ , 4 ′ )( y ) → P ′ (2 ′ , 4 ′ )( x ) is computed as follows.
````
  FIX: ````
Moreover, \( P^{\prime}(2^{\prime}, 4^{\prime})(\alpha) \colon P^{\prime}(2^{\prime}, 4^{\prime})(y) \to P^{\prime}(2^{\prime}, 4^{\prime})(x) \) is computed as follows.
````
"@
$newContent = $newContent.Replace('````', '```')
$text += $newContent
[System.IO.File]::WriteAllText($path, $text, (New-Object System.Text.UTF8Encoding($false)))
