# Complete extraction script - CORRECTED VERSION
$projectPath = "C:\Users\PC\Desktop\wordpress_curling\downloaded-site"
if (-not (Test-Path $projectPath)) {
    New-Item -ItemType Directory -Force -Path $projectPath
}
Set-Location $projectPath

# Download main page
$url = "https://portfoliocfa.wordpress.com"
Invoke-WebRequest -Uri $url -OutFile "index.html"
Write-Host "Downloaded main page" -ForegroundColor Green

# Run all extraction steps
$html = Get-Content "index.html" -Raw

# Extract CSS and JS - FIXED VERSION
@('css', 'js') | ForEach-Object {
    $ext = $_
    $pattern = "($ext)=""([^""]+\.$ext[^""]*)"""
    $fileMatches = [regex]::Matches($html, $pattern)  # Changed variable name
    
    foreach ($match in $fileMatches) {
        $fileUrl = $match.Groups[2].Value
        if ($fileUrl.StartsWith("/")) {
            $fileUrl = "https://portfoliocfa.wordpress.com" + $fileUrl
        }
        
        try {
            $fileName = [System.IO.Path]::GetFileName($fileUrl.Split('?')[0])
            Invoke-WebRequest -Uri $fileUrl -OutFile $fileName
            Write-Host "Downloaded $ext : $fileName" -ForegroundColor Cyan
        } catch {
            Write-Host "Failed to download: $fileUrl" -ForegroundColor Red
        }
    }
}

# Create minimal files for GitHub Pages
$minimalCss = @'
/* Minimal CSS for GitHub Pages */
body { font-family: Arial, sans-serif; margin: 0; padding: 0; }
header, footer { background: #f5f5f5; padding: 20px; }
main { padding: 20px; max-width: 1200px; margin: 0 auto; }
nav a { margin: 0 10px; text-decoration: none; color: #333; }
'@

$minimalCss | Out-File -FilePath "style.css" -Encoding UTF8

# Create clean HTML
$cleanHtml = @'
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Portfolio BTS SIO SLAM</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <!-- Paste your content from index.html here manually -->
    <!-- Keep only: header, main content, footer -->
    <!-- Remove all scripts and WordPress.com specific code -->
</body>
</html>
'@

$cleanHtml | Out-File -FilePath "clean-index.html" -Encoding UTF8

Write-Host "`nExtraction complete!" -ForegroundColor Green
Write-Host "Check the 'downloaded-site' folder for all files." -ForegroundColor Yellow