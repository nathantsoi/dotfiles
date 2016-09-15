#!/bin/bash
set -o nounset	# exit if trying to use an uninitialized var
set -o errexit	# exit if any program fails
set -o pipefail # exit if any program in a pipeline fails, also
set -x          # debug mode

rootdirname=$(dirname "$1")
find "$1/BDMV/STREAM/" -type f -iregex '.*\.MTS$' -print0 | while IFS= read -r -d $'\0' line; do
  filename=$(basename "$line")
  extension="${filename##*.}"
  filename="${filename%.*}"
  dirname=$(dirname "$line")
  src="${dirname}/${filename}.MTS"
  dst="${rootdirname}/$(date +"%F_%H-%M-%S")-${filename}.mp4"
  #avconv -i $src  -c:a copy -c:v copy $dst
  ffmpeg -i "$src" -vf yadif=1 -acodec ac3 -ab 192k -vcodec mpeg4 -f mp4 -y -q:a 0 -q:v 0 "$dst" < /dev/null
  # uncomment to remove source after conversion
  #trash-put $src
done
