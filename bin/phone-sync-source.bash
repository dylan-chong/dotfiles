function phone-music-update() {
    if [ "$1" == "-k" ]; then
        echo "-k passed: Killing Finder"
        killall Finder
    fi

    echo 'Trimming playlist'
    phone-sync-once &
    bash -c "cd /Users/Dylan/Dropbox/Programming/GitHub/itunes-applescripts/ && npm run gulp -- be --no-dry-run -s remove-recent"
    phone-sync
}

function phone-sync() {
    echo 'Starting phone sync'

    for ((i=0;i<100;i++)) do
        timeout 10 osascript ~/bin/phone-sync.applescript
        if [ "$?" -eq 0 ]; then
            echo 'Sync started'
            break
        else
            echo 'Sync failed to start. Device not found'
            sleep 3
        fi
    done
}

function phone-sync-once() {
    timeout 10 osascript ~/bin/phone-sync.applescript
 }
