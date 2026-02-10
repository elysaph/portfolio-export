@'
# SIMPLE SITE DOWNLOADER - FRESH CLEAN VERSION

# Create folder
$folderName = "MyPortfolio"
if (Test-Path $folderName) {
    Remove-Item $folderName -Recurse -Force
}
New-Item -ItemType Directory -Force -Path $folderName
Set-Location $folderName

Write-Host "Downloading portfolio pages..." -ForegroundColor Yellow

# List of pages to download
$pages = @(
    @{Url="https://portfoliocfa.wordpress.com/"; File="index.html"},
    @{Url="https://portfoliocfa.wordpress.com/nos-projets/"; File="nos-projets.html"},
    @{Url="https://portfoliocfa.wordpress.com/lecole/"; File="lecole.html"},
    @{Url="https://portfoliocfa.wordpress.com/entreprises/"; File="entreprises.html"},
    @{Url="https://portfoliocfa.wordpress.com/cours/"; File="cours.html"},
    @{Url="https://portfoliocfa.wordpress.com/contact/"; File="contact.html"}
)

# Download each page
foreach ($page in $pages) {
    Write-Host "  Downloading: $($page.File)" -ForegroundColor Cyan
    try {
        Invoke-WebRequest -Uri $page.Url -OutFile $page.File
        Write-Host "    ✓ Success" -ForegroundColor Green
    } catch {
        Write-Host "    ✗ Failed" -ForegroundColor Red
    }
}

# Create basic CSS
$css = @'
/* Basic CSS for GitHub Pages */
body {
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
    max-width: 1200px;
    margin: 0 auto;
    padding: 20px;
    line-height: 1.6;
}

header {
    background: #f8f9fa;
    padding: 20px;
    border-bottom: 1px solid #dee2e6;
}

nav a {
    margin-right: 20px;
    text-decoration: none;
    color: #0066cc;
}

main {
    padding: 30px 0;
}

footer {
    margin-top: 50px;
    padding: 20px;
    background: #f8f9fa;
    border-top: 1px solid #dee2e6;
}
'@

$css | Out-File -FilePath "style.css" -Encoding UTF8

Write-Host "`n" + "="*50
Write-Host "DOWNLOAD COMPLETE!"
Write-Host "="*50
Write-Host "Location: $(Get-Location)"
Write-Host "`nFiles created:"
Get-ChildItem | Format-Table Name, Length
