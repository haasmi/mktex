#! /bin/bash

version=0.1
texfile="main.tex"
pdffile="main.pdf"
file="main"


Remove () {
    rm "$file.aux"
    rm "$file.bbl"
    rm "$file.blg"
    rm "$file.glg"
    rm "$file.glo"
    rm "$file.gls"
    rm "$file.glsdefs"
    rm "$file.ist"
    rm "$file.lof"
    rm "$file.log"
    rm "$file.lol"
    rm "$file.lot"
    rm "$file.pdf"
    rm "$file.pyg"
    rm "$file.toc"
    ls
}

Help () {
    echo "Call: mktex [-f DATEI] | [-b] | [-g]"
    echo "Compiles a LaTeX document"
    echo " "
    echo "Options:"
    echo "    -f|--file             following filename is used as FILE.tex FILE.pdf as well as file for bibtex and makeglossaries"
    echo "    -b|--bibliography     bibtex is executed"
    echo "    -g|--glossary         makeglossaries is executed"
}

ARGS=$(getopt -a --options f:bghvr --long "file:,bibliography,glossary,help,version,remove" -- "$@")

eval set -- "$ARGS"

while true; do
    case "$1" in
        -f|--file)
            file=$2
            textfile="${2}.tex"
            pdffile="${2}.tex"
            shift 2;;
        -v|--version)
            echo mktex $version
            exit;;
        -h|--help)
            Help
            exit;;
        --|-b|--bibliography|-g|--glossary|-r|--remove)
            break;
    esac
done

if [[ "$1" == "-r" ]] || [[ "$1" == "--remove" ]];then
    Remove
    exit;
else 
    :
fi

pdflatex -shell-escape $texfile | grep -i ".*:[0-9]*:.*\|error"

while true; do
    case "$1" in 
        -b|--bibliography)
            bibtex $file
            shift 1;;
        -g|--glossaries)
            makeglossaries $file
            shift 1;;
        --)
            break;;
    esac
done

pdflatex -shell-escape $texfile | grep -i ".*:[0-9]*:.*\|error"
pdflatex -shell-escape $texfile | grep -i ".*:[0-9]*:.*\|error"
xdg-open $pdffile 
