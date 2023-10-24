#!/bin/bash


file_signatures=( "PNG" "JPE" "PNG" "PDF" "ZIP" "7z" "BZip2" "RAR" "GZIP" "LZH" "PCX" "PSD" "TIFF" "TIFF" "ICO" "EXE/DLL" "WAV" "MP3")


function ctrl_c(){
   echo  "[+] Saliendo"
   exit 1
}


trap ctrl_c INT



function recoverFile(){

	for ext in "${file_signatures[@]}"; do
	if xxd $1 | grep $ext &>/dev/null; then
		echo "[+]EXTENSION: $ext"
		echo "[+]HEX INFO: $(xxd $1 | grep $ext | head -1)"
		headerNum=$(xxd $1 | grep $ext | head -1 | awk '{print $1}' | sed 's/://' )
		headerNumConverted=$((16#$headerNum))
		dd if=$1 of=recoveredFile skip=$headerNumConverted bs=1
		echo "[+]file saved to the current directory  path $(pwd)"
		break
	fi
	done	
}


function helpPanel(){
	echo -e "\n\t[+] r)-> ./file-recovery.sh -r [FILE TO RECOVER]"
	echo -e "\t[+] h)-> prints this panel"

}


declare -i parameter_counter=0


while getopts "r:h" arg; do
	case $arg in
		r) file=$OPTARG; let parameter_counter+=1;;
		h) ;;
	esac

done


if [ $parameter_counter -eq 1 ]; then
	recoverFile $file
else
	helpPanel
fi





