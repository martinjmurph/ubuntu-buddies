#!/bin/sh

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

source $DIR/commands/cd_and_ls.sh
source $DIR/commands/hosts.sh
source $DIR/commands/exp.sh
source $DIR/commands/dx.sh
source $DIR/commands/local_copy.sh
source $DIR/commands/site_search.sh
source $DIR/commands/buddies_help.sh 