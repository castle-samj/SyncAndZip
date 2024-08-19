# Sync and Zip
### A simple rsync-based bash tool

[Requirements](#---requirements---)  
[Installation](#---installation---)  
[Usage](#---usage---)  
[Config](#---config---)  
[How-To-Windows](#---how-to-windows---)  

This project was originally designed to sync the contents of my library and configuration directories for a self-hosted Calibre eBook instance. This generic version can be modified to work for similar use, as well as anything that might need to be backed up on a regular basis. 
>In my use-case, I host the Calibre library on a RaspberryPi and backup the files to a Windows machine running WSL2.  
Check out [How To Windows](#how-to-windows) for suggestion(s).

## -- Requirements --  
 - Linux or WSL
 - rsync
 - [jq](https://jqlang.github.io/jq/) (JSON parser for linux)

## -- Installation --

Copy the contents to a subdirectory in your project folder.  
The parent folder will be used to store all data.   
Examples:  
*Linux*: `/home/{user}/MyBackups/src/{files}`  
*WSL*: `/mnt/d/MyBackups/src/{files}`

## -- Usage --  
After you [config](#---config---) try `./run.sh` from a terminal while in the `src` dir.
> flags are not supported (yet)  

The results will look something like this:
1) in the `live/dest#/` directory are all the files from `src#`
2) in the `storage/{now}/` directory will be 6 items: 4 log files (2 each for sync and zip) and 2 tar.gz archives.  

## -- Config --  

Edit `config.json` file according to your source(s) and destination(s).  
--> Currently all fields need to be manually set.     
  
| key | value | example/notes |  
| --- | --- | --- |  
| src1/2 | the full /path/to/source where your original files exist. | supports networked locations, such as `user@ip_addr:/home/user/source/` (make sure you've sent your ssh key to the source machine to auto-auth) |  
| dest1/2 | This is the target for rsync. Requires the full path. |  `/home/user/MyBackups/live/{dest1}/` |  
| storage | the directory where each backup will go. | This usually looks like `../MyBackups/storage/YYYY-MM-DD_HHMM/` where `YYYY-MM-DD_HHMM` is dynamically set by timestamp |
>*The intention is to have a default, where you just set the `parent` directory (think /home/user/**PARENT**/src/run.sh). Something like `--override-defaults`?*

## -- How-To-Windows --
Some of the features are provided by WSL, while some are included with Windows.  
 1) Make sure you have [Windows Subsystem for Linux](https://learn.microsoft.com/en-us/windows/wsl/install) and a distro installed. Ubuntu is easy  and works great.  
 - In an elevated powershell, run `wsl --install`  
 - follow `wsl --help` instructions for adding a distro.  
 2) Install *SyncAndZip* in your `parent` directory. WSL uses a structure like `/mnt/c/` to point to `C:\`.  
 3) Windows [Task Scheduler](https://learn.microsoft.com/en-us/windows/win32/taskschd/task-scheduler-start-page) is your friend for automatically running the script on a recurring basis.  
  - Create a new folder for your task(s). 
  - Create a new task.  
  - The `trigger` is used to set what makes the script run. Try a time-based, daily at 2am.  
  - The `action` is where you'll tell Windows to run the script. In the `Program/script:` field, type or find the path to wsl (probably something like "C:\Windows\System32\wsl.exe"). In the `arguments` field, add [-e "/path/to/run.sh"] (yes, the `-e` flag is needed). 