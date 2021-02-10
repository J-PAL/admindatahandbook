#!/bin/sh

set -ev

cd $(dirname $0)

# clean up first

[ -f _main.Rmd ] && rm -f _main.Rmd
[ -d _book     ] && rm -rf _book

# set up the environment
Rscript programs/bootstrap.R

# build the handbook
Rscript programs/build_ebook.R

# some cleanup

cd _book
unzip _main.epub
cp _main.epub handbook.epub

# fix these

sed -i 's+grouplength="3"++' EPUB/text/ch005.xhtml 
sed -i 's+indentlevel="1"++' EPUB/text/ch005.xhtml 

for arg in 10 11 13 14 16 
do
  sed -i 's+colspan="100%"+colspan="10"+' EPUB/text/ch0$arg.xhtml 
  sed -i 's+<br>+<br/>+g' EPUB/text/ch0$arg.xhtml 
done
zip -rp handbook.epub EPUB/text/ch*

# next steps
echo "Using calibre, convert EPUB to MOBI and AZW3"
echo ""
echo 'ebook-convert "handbook.epub" "handbook.azw3"'
echo 'ebook-convert "handbook.epub" "handbook.mobi"'
echo ""
echo "then copy into root of published version"



