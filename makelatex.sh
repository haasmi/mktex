#! /bin/bash

version=0.1

Help () {
    echo "Call: mktex [-f DATEI] | [-b] | [-g]"
    echo "Compiles a LaTeX document"
    echo " "
    echo "Options:"
    echo "    -f|--file             following filename is used as FILE.tex FILE.pdf as well as file for bibtex and makeglossaries"
    echo "    -b|--bibliography     bibtex is executed"
    echo "    -g|--glossary         makeglossaries is executed"
}

ARGS=$(getopt -a --options f:bgh --long "file:,bibliography,glossary,help" -- "$@")

eval set -- "$ARGS"

while true; do
    case "$1" in 
        -f|--file)
            file=$2
            texfile="${2}.tex"
            pdffile="${2}.pdf"
            shift 2
            break;;
        -b|--bibliography)
            texfile="main.tex"
            pdffile="main.pdf"
            file="main"
            break;;
        -g|--glossaries)
            texfile="main.tex"
            pdffile="main.pdf"
            file="main"
            break;;
        -h|--help)
            Help
            exit;;
        --)
            texfile="main.tex"
            pdffile="main.pdf"
            file="main"
            break;;
    esac
done


pdflatex -shell-escape $texfile | grep -i ".*:[0-9]*:.*\|error"

while true; do
    case "$1" in
        -b|--bibliography)
            bibtex $file
            shift 1
            break;;
        --)
            break;;
    esac
done

while true; do
    case "$1" in
        -g|--glossary)
            makeglossaries main 
            break;;
        --)
            break;;
    esac
done

pdflatex -shell-escape $texfile | grep -i ".*:[0-9]*:.*\|error"
pdflatex -shell-escape $texfile | grep -i ".*:[0-9]*:.*\|error"
xdg-open $pdffile 
