@echo off
echo Creating portfolio site...
mkdir MyPortfolio 2>nul
cd MyPortfolio

echo Downloading pages...

curl -L -o index.html "https://portfoliocfa.wordpress.com/"
curl -L -o nos-projets.html "https://portfoliocfa.wordpress.com/nos-projets/"
curl -L -o lecole.html "https://portfoliocfa.wordpress.com/lecole/"
curl -L -o entreprises.html "https://portfoliocfa.wordpress.com/entreprises/"
curl -L -o cours.html "https://portfoliocfa.wordpress.com/cours/"
curl -L -o contact.html "https://portfoliocfa.wordpress.com/contact/"

echo body { font-family: Arial; } > style.css

echo.
echo ================================
echo DOWNLOAD COMPLETE!
echo ================================
echo Files in: %CD%
dir *.html
pause