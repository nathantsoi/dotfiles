alias reload!='. ~/.zshrc'

#helpers
ggrep () { git grep $* }
grepr () { grep -r $* * }

# move without blowing away an existing file
move() {
  suffix=0
  src="$1"
  srcfilename=$(basename "$src")
  dst="$2"
  # if the destination ends in a slash, we want to put it in the directory
  # or the source is a file and the destination is a directory, we want to put it in the directory
  if [[ -d "$dst" && "$dst" == */ ]] || [[ (! -d "$src") && -d "$dst" ]]; then
    dst="${dst}/${srcfilename}"
  fi

  filename=$(basename "$dst")
  extension="${filename##*.}"
  filename="${filename%.*}"
  dirname=$(dirname "$dst")
  while test -e "$dst"; do
    dst="${dirname}/${filename}-$((++suffix))"
    if [ "$filename" != "$extension" ]; then
    dst="${dst}.${extension}"
    fi
  done
  mv -v "$src" "$dst"
}

#  services
alias apacherestart='sudo apachectl -k restart'

# checksums
alias sha256='shasum -a 256'

# android
alias adbcap='adb shell screencap -p | perl -pe "s/\x0D\x0A/\x0A/g" > screen.png'

# mac settings
alias spoof='sudo ifconfig en1 ether'
alias unspoof='sudo ifconfig en1 ether c8:bc:c8:ee:54:11'

# curl with continuation
# call it curlc target_filename url
alias curlc='curl -C - -o'

# http://dba.stackexchange.com/questions/36102/how-to-properly-kill-mysql
alias mysql_stop='mysqladmin -uroot -p -h127.0.0.1 --protocol=tcp shutdown'

# sublime 2
alias subl='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'

# `brew install knock` to get this to work
# your username, set this to your actual username, replacing $(whoami), if your login doesnt match
export SSH_USERNAME=$(whoami)
# internal
export INTERNAL_SSH_GATEWAY=10.11.12.228
# external
export SSH_GATEWAY=54.148.237.16
export SSH_PROXY_PORT=1080
# ssh into a host after knocking
function kx { knock $SSH_GATEWAY -v -d 1000 7152 8152 5183 && ssh -l $SSH_USERNAME $@; }
function ikx { knock $INTERNAL_SSH_GATEWAY -v -d 1000 7152 8152 5183 && ssh -l $SSH_USERNAME $@; }
# open an ssh proxy, run this first
# https://help.ubuntu.com/community/SSH/OpenSSH/PortForwarding#Dynamic_Port_Forwarding
function px { kx -C -D $SSH_PROXY_PORT $SSH_GATEWAY; }
# ssh into a host behind the proxy, then run this
function sshx { ssh -l $SSH_USERNAME -o "ProxyCommand nc -x localhost:$SSH_PROXY_PORT %h %p" $@; }
# ssh into a host behind the proxy, then run this
function scpx { scp -o "ProxyCommand nc -x localhost:$SSH_PROXY_PORT %h %p" $@; }
# open a chrome browser connecting through the proxy
alias chromex='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --proxy-server="socks5://localhost:$SSH_PROXY_PORT" --host-resolver-rules="MAP * 0.0.0.0 , EXCLUDE myproxy" --user-data-dir=/tmp/pchrome'

function detab { find . -regex '.*\.\(c\|h\|cpp\)' ! -type d -exec bash -c 'expand -t 2 "{}" > /tmp/e && mv /tmp/e "{}"' \; }

alias fmtjson='pbpaste|python -mjson.tool|pbcopy'

# depends on "brew install coreutils"
function find_n_replace_all { find . -type f -exec gsed -i "s/$1/$2/g" {} \; }

# fix tunnelblick
function tunfix {
  sudo kextunload -b net.sf.tuntaposx.tap
  sudo kextunload -b net.sf.tuntaposx.tun
}

alias lsusb='system_profiler SPUSBDataType'
alias lssyscalls='sudo syscallbypid.d'

#colored cat
alias pcat='pygmentize -g'
#colored less
function pless() { pcat "$1" | less -R }
#colored diff
function pdiff() { diff -u "$1" "$2" | pygmentize -l diff }

# docker
alias dsp='docker system prune -a'

# ros / ssh tunnxling
#  tp -> tunnel_port [HOST] [PORT]
function tp() { ssh -L $2:127.0.0.1:$2 -C -N -l $USER $1 }

# mirror
function ms() { mirror server }
function mc() { mirror client -h $@ }

# fix cisco
function fixcisco() { sudo launchctl load /Library/LaunchDaemons/com.cisco.anyconnect.vpnagentd.plist }

# run python3 with a debugger
function python3d() { python3 -m pdb -c continue $1 }
