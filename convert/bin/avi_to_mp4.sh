find . -type f -iregex '.*\.avi$' -print0 | while IFS= read -r -d $'\0' line; do
  filename=$(basename "$line")
  extension="${filename##*.}"
  filename="${filename%.*}"
  dirname=$(dirname "$line")
  HandBrakeCLI \
    -i "${dirname}/${filename}.avi" \
    -o "${dirname}/${filename}.mp4" \
    --encoder x264 \
    --vb 1800 \
    --ab 128 \
    --maxWidth 640 \
    --maxHeight 480 \
    --two-pass \
    --optimize
  trash-put "$line"
  break
done
