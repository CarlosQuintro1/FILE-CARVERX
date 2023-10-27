#!/bin/bash


file_signatures=( "PNG"         "JFIF"       "PDF"       "ZIP"        "GIF"        "RIFF"   "GZIP"    "TIFF"        "MP3")
headers=(         "89504e47"    "ffd8ffe0"   "25504446"  "504b0304"   "47494638"   "52494646" "1f8b"    "49492a00"    "49443303" )

function ctrl_c(){
   echo  "[+] Aborting..."
   exit 1
}


trap ctrl_c INT



function recoverFile(){

	for (( i = 0; i < "${#file_signatures[@]}"; i++ )) ; do

	if xxd $1 | grep ${file_signatures[$i]} &>/dev/null; then

		echo "[+]EXTENSION: ${file_signatures[$i]}"
		echo "[+]HEX INFO: $(xxd $1 | grep ${file_signatures[$i]} | head -1)"		

		headerNum=$(xxd $1 | grep ${file_signatures[$i]} | head -1 | awk '{print $1}' | sed 's/://' )
		headerNumConverted=$((16#$headerNum))
		echo "[+]HEADER VALUE: ${headers[$i]}"
                bytes=$(xxd $1 | grep ${file_signatures[$i]} | awk '{print $2,$3,$4,$5,$6,$7,$8,$9}' | tr -d ' ' | awk -F ${headers[$i]}  '{print $1}' )
		numOfBytes=$(( ${#bytes}  / 2))
		total=$((headerNumConverted+numOfBytes))

		dd if=$1 of=recoveredFile skip=$total bs=1
		echo "[+]file saved to the current directory  path $(pwd)"		
		
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





