USERNAME=$(whoami)
# Name of my primary backup device
TARGET_PATH=/Volumes/NexStar
# Name of the secondar backup device (to which we clone the $TARGET_PATH)
MIRROR_PATH=/Volumes/ProDrive
TARGET_PATH_USER=${TARGET_PATH}/${USERNAME}

# backups
#alias backup_apps="rsync -avz --exclude='.DS_Store' ~/Apps/ beaglebone:/data/Apps/"
#alias backup_pictures="rsync -avz --exclude='.DS_Store' ~/Pictures/ beaglebone:/data/Pictures/"
#alias backup_movies="rsync -avz --exclude='.DS_Store' ~/Movies/ beaglebone:/data/Movies/"
#alias backup_documents="rsync -avz --exclude='.DS_Store' ~/Documents/ beaglebone:/data/Documents/"
#alias backup_src="rsync -avz --exclude='.DS_Store' ~/src/ beaglebone:/data/src/"
#alias backup_profile="rsync -avz --exclude='.DS_Store' ~/.ssh beaglebone:/data/$USERNAME/ssh/"

alias backup_ssh="rsync -avz --exclude='.DS_Store' ~/.ssh/ ${TARGET_PATH_USER}/ssh"
alias backup_src="rsync -avz --exclude='.DS_Store' ~/src/ ${TARGET_PATH_USER}/src"
alias backup_pictures="rsync -avz --exclude='.DS_Store' ~/Pictures/ ${TARGET_PATH_USER}/Pictures"
alias backup_documents="rsync -avz --exclude='.DS_Store' ~/Documents/ ${TARGET_PATH_USER}/Documents"
alias backup_movies="rsync -avz --exclude='.DS_Store' ~/Movies/ ${TARGET_PATH}/Movies"
alias backup_postgres="pg_dumpall | bzip2 -c > ${TARGET_PATH}/postgres/$(date '+%Y-%m-%d-%H-%M-%S').sql.bz2"
alias backup_all="backup_ssh && backup_src && backup_pictures && backup_documents && backup_movies"

# phone
alias backup_phone_camera="cd ~/Pictures/Camera; adb pull /sdcard/Movies/FPV . ; adb pull /sdcard/DCIM/Camera/ . ; photos_by_date"
alias backup_phone="backup_phone_camera"

# cleaning up
alias cleanup_logs="find ~/src/rails/ -iname '*.log' -exec sh -c \"echo '' > {}\" \;"
alias check_logs="find ~/src/rails/ -iname '*.log' -exec sh -c 'ls -lah {}' \;"

# hard drive management
#alias hd_clone=/usr/local/Cellar/rsync/3.1.1/bin/rsync -P -avz --exclude='.DS_Store' --exclude='._*' --exclude="\$RECYCLE.BIN" --exclude=".Spotlight-V100" --exclude=".TemporaryItems" --exclude=".Trash*" --exclude="FOUND.00*" /Volumes/NexStar/* /Volumes/ProDrive
alias hd_clone="rsync -xavHl ${TARGET_PATH}/* ${MIRROR_PATH}/"

alias clean_sleep="sudo pmset -a hibernatemode 0; sudo rm /var/vm/sleepimage; sudo pmset -a hibernatemode 3"
alias clean_swap="sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.dynamic_pager.plist; sudo rm /private/var/vm/swapfile*; sudo launchctl load -wF /System/Library/LaunchDaemons/com.apple.dynamic_pager.plist"
