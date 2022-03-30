# Using pandoc in Windows

## Install
- pandoc (https://pandoc.org/)
- Miktek for creating PDFs (https://miktex.org/)
- LibreOffice for converting docs to ODT format (https://www.libreoffice.org/)

## From Markdown to ODT (LibreOffice)
- Run these lines of code in Windows command tool

```
set mdfile=file1
cd "C:\Users\Peter R\Documents\pandoc-sandbox"
pandoc %mdfile%.md -f markdown -t ODT -s -o %mdfile%.odt --bibliography ecology_v1_wos.bib --citeproc --csl ecology-letters.csl
```

- Alternatively you can run the .bat file

- Note: if creating .md files with Obsidian (https://obsidian.md/) you may need to sanitize your file before running the above.  See Linux script.
