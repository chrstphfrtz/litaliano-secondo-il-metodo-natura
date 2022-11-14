#!/bin/bash

esercizi=(
  capitolo-01/esercizi
  capitolo-02/esercizi
  capitolo-03/esercizi
  capitolo-04/esercizi
)
lexica=(
)
langs=(
  german
  english
)

convert() {
  local pdf_folder="$1/pdf"
  local md_folder="$1/md"

	if ! mkdir "$pdf_folder" >/dev/null 2>&1; then
		printf "SKIP: Create pdf folder %s - it most likely exists already\n" "$pdf_folder"
	else
		printf "OK: Create pdf folder %s\n" "$pdf_folder"
	fi

  if [[ "$1" =~ .*esercizi* ]]; then
		local lang_pdf_path="$pdf_folder/esercizi.pdf"
		local lang_md_path="$md_folder/esercizi.md"

    pandoc_convert "$lang_pdf_path" "$lang_md_path"
  else
    for lang in "${langs[@]}"; do
      local lang_pdf_path="$pdf_folder/$lang.pdf"
      local lang_md_path="$md_folder/$lang.md"

      pandoc_convert "$lang_pdf_path" "$lang_md_path"
    done
  fi
}

pandoc_convert() {
  if ! pandoc --from markdown -o "$1" --pdf-engine=xelatex -V mainfont="MesloLGS NF" "$2" >/dev/null 2>&1; then
    printf "SKIP: Convert %s to %s - it most likely does not exist\n" "$1" "$2"
  else
    printf "OK: Convert %s to %s\n" "$1" "$2"
  fi
}

need_cmd() {
	if ! check_cmd "$1"; then
		printf "ERROR: %s is not installed\n" "$1"
		exit 1
	fi
}

check_cmd() {
	command -v "$1" >/dev/null 2>&1
}

main() {

  printf "INFO: Make sure pandoc and MesloLGS NF font are installed, otherwise PDF files cannot be generated.\n"
	need_cmd pandoc

	for esercizio in "${esercizi[@]}"; do
		convert "$esercizio"
	done

	for lexicon in "${lexica[@]}"; do
		convert "$lexicon"
	done

	printf "Finished.\n"
}

main
