#!/bin/zsh
set -o nounset	# exit if trying to use an uninitialized var
set -o errexit	# exit if any program fails
set -o pipefail # exit if any program in a pipeline fails, also
#set -x          # debug mode

# load the move command
SCRIPT_DIR=$(dirname $(realpath $0))
source ${SCRIPT_DIR}/../../zsh/aliases.zsh

rootdirname=$(dirname "$1")
find "$1/BDMV/STREAM/" -type f -iregex '.*\.MTS$' -print0 | while IFS= read -r -d $'\0' line; do
  filename=$(basename "$line")
  extension="${filename##*.}"
  filename="${filename%.*}"
  dirname=$(dirname "$line")
  src="${dirname}/${filename}.MTS"

  date=$(stat -f%SB -t %Y:%m:%d "$src" || echo '')
  [ -z "$date" ] && echo " $src did not have date" && continue
  year=${date%%:*}
  month=${date%:*}
  month=${date%:*}
  month=${month#*:}
  day=${date##*:}
  dtarget=/${year}-${month}-${day}

  dst="${rootdirname}/${dtarget}-${filename}.MTS"
  # extract only
  move $src $dst
done
# put the source in the trash
trash $1

