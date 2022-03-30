set mdfile=file1
copy "C:\Users\Peter R\Desktop\debshare1\md_files\fixed\%mdfile%.md" "C:\Users\Peter R\Documents\pandoc-sandbox"
copy "F:\ref\ecology_v1.bib" "C:\Users\Peter R\Documents\pandoc-sandbox"
cd "C:\Users\Peter R\Documents\pandoc-sandbox"
pandoc %mdfile%.md -f markdown -t ODT -s -o %mdfile%.odt --bibliography ecology_v1_wos.bib --citeproc --csl ecology-letters.csl
