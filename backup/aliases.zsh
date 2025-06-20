# backups
#alias backup_apps="rsync -avz --exclude='.DS_Store' ~/Apps/ beaglebone:/data/Apps/"
#alias backup_pictures="rsync -avz --exclude='.DS_Store' ~/Pictures/ beaglebone:/data/Pictures/"
#alias backup_movies="rsync -avz --exclude='.DS_Store' ~/Movies/ beaglebone:/data/Movies/"
#alias backup_documents="rsync -avz --exclude='.DS_Store' ~/Documents/ beaglebone:/data/Documents/"
#alias backup_src="rsync -avz --exclude='.DS_Store' ~/src/ beaglebone:/data/src/"
#alias backup_profile="rsync -avz --exclude='.DS_Store' ~/.ssh beaglebone:/data/ntsoi/ssh/"

find_external_drive_backup_folder() {
    local external_drive_name=""
    local volumes_directory="/Volumes"
    local backup_folder_name="$1"

    # Check if the /Volumes directory exists
    if [ ! -d "$volumes_directory" ]; then
        echo "Error: The $volumes_directory directory does not exist."
        return 1
    fi

    # Iterate over the contents of the /Volumes directory
    for item in "$volumes_directory"/*; do
        if [ -d "$item" ] && [ -n "$(mount | grep -F "$item")" ]; then
            external_drive_name=$(basename "$item")
            backup_folder="$item/$backup_folder_name"
            if [ -d "$backup_folder" ]; then
                echo "$backup_folder"
                return 0
            fi
            break
        fi
    done

    echo "Error: No attached external drive with a '$backup_folder_name' folder found in $volumes_directory."
    return 1
}

alias backup_ssh="rsync -avE --exclude='.DS_Store' ~/.ssh/ \$(find_external_drive_backup_folder '${DOTFILES_USER}/ssh')"
alias backup_src="rsync -avE --exclude='.DS_Store' --exclude='*.log' ~/src/ \$(find_external_drive_backup_folder '${DOTFILES_USER}/src')"
alias backup_pictures="rsync -avE --exclude='.DS_Store' ~/Pictures/ \$(find_external_drive_backup_folder '${DOTFILES_USER}/Pictures')"
alias backup_documents="rsync -avE --exclude='.DS_Store' ~/Documents/ \$(find_external_drive_backup_folder '${DOTFILES_USER}/Documents')"
alias backup_movies="rsync -avE --exclude='.DS_Store' ~/Movies/ \$(find_external_drive_backup_folder '${DOTFILES_USER}/Movies')"
alias backup_all="backup_ssh; backup_src; backup_pictures; backup_documents; backup_movies"

# phone
alias backup_phone_camera_to_external="adb pull /sdcard/DCIM/Camera/ /Volumes/${PHOTO_BACKUP_VOLUME}/${DOTFILES_USER}/Pictures/; pushd /Volumes/${PHOTO_BACKUP_VOLUME}/${DOTFILES_USER}/Pictures/Camera; photos_by_date; popd"
alias backup_photos_to_external="rsync -avz ~/Pictures/ /Volumes/${PHOTO_BACKUP_VOLUME}/${DOTFILES_USER}/Pictures/"
alias backup_phone_camera="adb pull /sdcard/DCIM/PhotoScan/ ~/Pictures/; adb pull /sdcard/DCIM/Camera/ ~/Pictures/; pushd ~/Pictures/Camera; photos_by_date; popd"
alias backup_phone="backup_phone_camera"

# cleaning up
alias check_logs="sudo find ~/src/ -iname '*.log' -exec sh -c 'ls -lah {}' \;"
alias cleanup_logs="sudo find ~/src/ -iname '*.log' -type f -print -exec sh -c \"echo '' > {}\" \;"
alias cleanup_npm="sudo find ~/src/ -name 'node_modules' -type d -print -exec rm -rf {} \;"
alias cleanup_all="cleanup_logs; cleanup_npm"

# hard drive management
alias hd_clone="rsync -xavHl /Volumes/$EXTERNAL_VOLUME/* /Volumes/$EXTRA_EXTERNAL_VOLUME/"

alias clean_sleep="sudo pmset -a hibernatemode 0; sudo rm /var/vm/sleepimage; sudo pmset -a hibernatemode 3"
alias clean_swap="sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.dynamic_pager.plist; sudo rm /private/var/vm/swapfile*; sudo launchctl load -wF /System/Library/LaunchDaemons/com.apple.dynamic_pager.plist"

alias find_empty_directories="find . -type d -empty"
