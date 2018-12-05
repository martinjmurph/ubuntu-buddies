# Ubuntu-buddies

## Setup

```
git clone https://github.com/martinjmurph/ubuntu-buddies.git
echo "if [ -f ~/[REPO_DIR]/main.sh ]; then . ~/[REPO_DIR]/main.sh; fi" >> ~/.bashrc
source ~/.bashrc
```

## Updates

If updates have happened since your intial setup, adding them is as simple as:
```
cd ~/[REPO_DIR]
git pull
source ~/.bashrc
```

## Commands

### cd_and_ls

A simple function to replace `cd [DIR]` with `cd [DIR] && ls .`

### hosts

Allows you to search through your `~/.ssh/config` for finding hosts easier
`hosts` - Shows all hosts in your ~/.ssh/config
`hosts <string>` - Searches through your ~/.ssh/config for a certain host

### exp

Opens your `~/.aws/credentials` file and builds up a list of expansion servers so you can ssh to them
`exp` - Loops through the awscli and finds expansion servers

### dx

Simple goes to your `~/docker/<parameter>` directory and executes the command to go into a php shell

### local_copy

Allows you to take a local copy of any site on any server with apache installed
`local_copy <host>` - Pass in a host parameter to go to that server
You can get a list of hosts from the `hosts` command

### site_search

Searches our internal/shared servers for a certain domain
`site_search <part_of_domain>` - Pass in any part of the domain

## Adding your own functions

Simple create a new .sh file in `./commands/[YOUR_COMMAND].sh`

Once your function is complete, add a new line in main.sh as follows:
`source $DIR/commands/[YOUR_COMMAND].sh`