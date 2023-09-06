# Document file conversion

- 2023-08-16
- Peter R.

## Batch Convert doc files to docx

Using MobaXterm & libreOffice on Windows. Convert doc to docx
"/drives/c/Program Files/LibreOffice 5/program/soffice.exe" --headless --convert-to docx *.doc

"/drives/c/Program Files/LibreOffice 5/program/soffice.exe" --headless --convert-to docx *.txt

## Batch Convert docx files to .txt 
Using MobaXterm on Windows and Pandoc (no line wrappng)
find . -name \*.docx -type f -exec pandoc -o {}.txt {} \;
