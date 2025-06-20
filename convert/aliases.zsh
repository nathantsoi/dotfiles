flip_video () { $(which ffmpeg) $1 -vf "vflip,hflip" $2 }

pngs_to_jpgs () {
  for i in *.png; do sips -s format jpeg -s formatOptions 70 "${i}" --out "${i%png}jpg"; done
}

# does only changes the display aspect ratio
superview () {
  INFILE=$1
  filename=$(basename "$INFILE")
  extension="${filename##*.}"
  filename="${filename%.*}"
  dirname=$(dirname "$INFILE")
  src="${dirname}/${filename}.${extension}"
  #unstretched="${dirname}/${filename}-unstretched.${extension}"
  dst="${dirname}/${filename}-superview.${extension}"

  avconv -i $src -aspect 16:9 -c:a copy -c:v copy $dst
  #mv $src $unstretched
}

superview-all () {
  target=${1:-.}
  find "$target" -maxdepth 1 -type f -iname "YDXJ*.mp4" | while read file ; do
    if [[ "$file" == *"-superview.mp4" ]]; then
      continue
    fi
    filename=$(basename "$file")
    extension="${filename##*.}"
    filename="${filename%.*}"
    dirname=$(dirname "$file")
    src="${dirname}/${filename}.${extension}"
    #unstretched="${dirname}/${filename}-unstretched.${extension}"
    dst="${dirname}/${filename}-superview.${extension}"
    if [[ -e "$dst" ]]; then
      echo "$dst already exists"
    else
      $(superview "$src")
    fi
  done
}

# stretches the real stream, but requires re-encoding
superview-reencode () {
  INFILE=$1
  filename=$(basename "$INFILE")
  extension="${filename##*.}"
  filename="${filename%.*}"
  dirname=$(dirname "$INFILE")
  src="${dirname}/${filename}.${extension}"
  #unstretched="${dirname}/${filename}-unstretched.${extension}"
  dst="${dirname}/${filename}-superview-sar.${extension}"

  ffmpeg -i $src -c:v libx264 -crf 16 -vf scale=1920x1080,setsar=1:1 $dst
  #mv $src $unstretched
}

keyframes () {
  INFILE=$1
  filename=$(basename "$INFILE")
  extension="${filename##*.}"
  filename="${filename%.*}"
  dirname=$(dirname "$INFILE")
  src="${dirname}/${filename}.${extension}"
  target_dir=${filename}-keyframes
  mkdir $target_dir
  ffmpeg -i $src -vf "select=eq(pict_type\,I)" -vsync vfr $target_dir/%02d.png
}
