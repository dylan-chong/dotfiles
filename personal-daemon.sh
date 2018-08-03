#!/bin/bash
while true; do
    echo 'Killing AppPolice'
    killall AppPolice

    sleep 1
    echo 'Starting AppPolice'
    open -a 'AppPolice'

    echo 'Waiting for next cycle...'
    sleep 20
done
