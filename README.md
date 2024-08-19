# Sync and Zip
## A simple rsync-based bash tool

[Requirements](#requirements)  
[Installation](#installation)  
[Config](#config)  
[Usage](#usage)  
[How-To-Windows](#how-to-windows)  

This project was originally designed to sync the contents of my library and configuration directories for a self-hosted Calibre eBook instance. 
>In my use-case, I host the Calibre library on a RaspberryPi and backup the files to a Windows machine running WSL2. Check out [How To Windows](#how-to-windows) for suggestion(s).

This generic version can be modified to work for similar use, as well as anything that might need to be backed up on a regular basis. 

<hr>

### Requirements  
 - Linux (including WSL)
 - rsync
 - [jq](https://jqlang.github.io/jq/) (JSON parser for linux)

<hr>

### Installation
Copy the `src` directory and its contents to your preferred location. The parent folder will be used to store the data, so it should be located *inside* the backups folder. 
#### Examples:  
##### *Linux*
 - `/home/{user}/MyBackups/src/`
 ##### *WSL*
  - `/mnt/d/MyBackups/src/`

<hr>

### Config  

Edit the `config.json` file according to your source(s) and destination(s). Currently all fields need to be manually set.  
The intention is to have a default, where you just set the `parent` directory (think /home/user/**PARENT**/src/run.sh/).   
  
| key | value | example/notes |  
| --- | --- | --- |  
| src1/2 | the full /path/to/source where your original files exist. | supports networked locations, such as `user@ip_addr:/home/user/source/` |  
| dest1/2 | the full /path/to/destination where the copies of your content will go. | This is the target for rsync. `/home/user/MyBackups/live/{dest1}/` |  
| storage | the directory where each backup will go. | This usually looks like `../MyBackups/storage/{Backup001}/` where `{Backups001}` is dynamically set by timestamp |

<hr>

### Usage  
Try `./run.sh` from a terminal while in the `src` dir.


> flags are not supported (yet)

<hr>

### How-To-Windows
Some of the features are provided by WSL, while some are included with Windows.  
 1) Make sure you have [Windows Subsystem for Linux](https://learn.microsoft.com/en-us/windows/wsl/install) and a distro installed. Ubuntu is easy  and works great.  
 - In a powershell, run `wsl --install`  
 - follow `wsl --help` instructions for adding a distro.  
 2) Install *SyncAndZip* in your `parent` directory. WSL uses a structure like `/mnt/c/` to point to `C:\`.  
 3) Windows [Task Scheduler](https://learn.microsoft.com/en-us/windows/win32/taskschd/task-scheduler-start-page) is your friend for automatically running the script on a recurring basis.  
  - Create a new folder for your task(s). 
  - Create a new task.  
  - The `trigger` is used to set what makes the script run. Try a time-based, daily at 2am.  
  - The `action` is where you'll tell Windows to run the script. In the `Program/script:` field, type or find the path to wsl (probably something like "C:\Windows\System32\wsl.exe"). In the `arguments` field, add [-e "/path/to/run.sh"] (yes, the `-e` flag is needed). 