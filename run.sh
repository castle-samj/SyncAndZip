#! /bin/bash
# Script to backup and compress Calibre library and contents
# 1. rsync
# 2. tar+gzip
# 3. remove old archives

# variables
now=$(date +%F_%0H%0M) # timestamp

CONFIG=$( cat /path/to/config.json )

read -r src1 < <(echo $CONFIG | jq -r '[.src] | join(" ")')
read -r dest1 < <(echo $CONFIG | jq -r '[.dest] | join(" ")')
read -r src2 < <(echo $CONFIG | jq -r '[.src2] | join(" ")')
read -r dest2 < <(echo $CONFIG | jq -r '[.dest2] | join(" ")')
read -r storage < <(echo $CONFIG | jq -r '[.storage] | join(" ")')
read -r workparent < <(echo $CONFIG | jq -r '[.workparent] | join(" ")')

current="$storage/${now}" # current working directory

# create "current working" and "destination" directories (if not exist)
mkdir -p $current $dest1 $dest2

# rsync the changed contents from source
# Do not include trash files
# Delete files removed from source
# Create log file
echo 'Syncing Library...'
rsync -ahPq $src1 $dest1 --delete-before --delete-excluded --exclude '.caltrash' --log-file=$current/libsync.log
echo 'Syncing Config...'
rsync -ahPq $src2 $dest2 --delete-before --delete-excluded --log-file=$current/confsync.log

# compress backup locally
# silence STDOUT
# log STDERR
# ! Must remain one-line
echo 'Compressing Library...'
tar -zcvf $current/lib.tar.gz -C $dest1 . 1>& 2> $current/libzip.log
echo 'Compressing Config...'
tar -zcvf $current/conf.tar.gz -C $dest2 . 1>& 2> $current/confzip.log

# check for and remove archives older than 30 days
echo 'Deleting old archives...'
find $storage -type d -mtime +30 -exec rm -R {} \;

# let me know that you are done
echo 'Done!'

exit