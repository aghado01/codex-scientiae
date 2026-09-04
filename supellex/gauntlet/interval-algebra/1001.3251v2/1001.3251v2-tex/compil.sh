#!/bin/bash

latex $1
for i in $(ls)
do
	if [ ${i##*.} = 'bib' ];
	then
		bibtex $1
	elif [ ${i##*.} = 'bbl' ];
	then
		echo "bbl found"
	else
		echo "No bib or bbl file !"
	fi
done
latex $1
echo "44444444444444444444444444444444"
latex $1
echo "55555555555555555555555555555555"
dvips $1
echo "66666666666666666666666666666666"
ps2pdf "$1.ps"
echo "77777777777777777777777777777777"

rm *.aux *.blg *.dvi
echo "88888888888888888888888888888888"
