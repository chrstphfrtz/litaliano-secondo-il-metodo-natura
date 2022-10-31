#!/bin/bash

esercizi=(
  capitolo-01/esercizi
  capitolo-02/esercizi
  capitolo-03/esercizi
)
lexica=(
)
langs=(
  german
  english
  italian
)

convert() {
	local pdf_folder="$1/pdf"
	local md_folder="$1/md"

	if ! mkdir "$pdf_folder" >/dev/null 2>&1; then
		printf "SKIP: Create pdf folder %s - it most likely exists already\n" "$pdf_folder"
	else
		printf "OK: Create pdf folder %s\n" "$pdf_folder"
	fi

	for lang in "${langs[@]}"; do
		local lang_pdf_path="$pdf_folder/$lang.pdf"
		local lang_md_path="$md_folder/$lang.md"

		if ! pandoc --from markdown -o "$lang_pdf_path" --pdf-engine=xelatex -V mainfont="MesloLGS NF" "$lang_md_path" >/dev/null 2>&1; then
			printf "SKIP: Convert %s to %s - it most likely does not exist\n" "$lang_md_path" "$lang_pdf_path"
		else
			printf "OK: Convert %s to %s\n" "$lang_md_path" "$lang_pdf_path"
		fi
	done
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

	for mel in "${meletemata[@]}"; do
		convert "$mel"
	done
	printf "Finished.\n"
}

main
