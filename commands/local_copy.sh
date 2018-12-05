function local_copy() {
	if [[ $# -eq 0 ]]; then
		echo 'You must include a host as a parameter (ssh config)'
		echo 'Run the `hosts` bash command to see a list of servers'
		return
	fi

	function silentSsh {
		local connectionString="$1"
		local commands="$2"
		if [ -z "$commands" ]; then
			commands=`cat`
		fi
		ssh -T $connectionString "$commands"
	}

	silentSsh $1 <<'ENDSSH' > 'tmp.csv'
	/bin/bash
	for site in $(ls /etc/apache2/sites-available); do 
		sitepath=$(cat /etc/apache2/sites-available/$site | grep DocumentRoot | grep --invert-match '#' | awk '{print $2}' | tr -d \");
		servername=$(cat /etc/apache2/sites-available/$site | grep ServerName | grep --invert-match '#' | awk '{print $2}');
		if [ -z "$sitepath" ]; then
			sitepath="NONE";
		fi
		if [ ! -z "$servername" ]; then
			echo "$servername,$sitepath";
		fi
	done
ENDSSH

	sitepaths=( $(cut -d ',' -f2 'tmp.csv') )
	sitenames=( $(cut -d ',' -f1 'tmp.csv') )

	echo "=========================================="
	for i in "${!sitenames[@]}"; do 
		echo "[$i] ${sitenames[$i]} - ${sitepaths[$i]}"
	done
	echo "=========================================="
	echo "    Type id of site you want to clone:"
	echo "=========================================="

	read site_choice

	sitename=${sitenames[$site_choice]}
	sitepath=${sitepaths[$site_choice]}
	sitename_clean=$(echo $sitename | sed 's/\.//g' | sed 's/\///g')
	echo "[localhost]==> You've selected: $sitename"

	if $(ssh $1 drush --strict=0 --quiet --pipe --root=$sitepath status bootstrap | grep -q Successful 2>&1); then
		echo "[localhost]==> This site is a working drupal site, so we can proceed"
	else
		echo "[localhost]==> This is not a valid drupal site, check the site root: $sitepath"
		return
	fi

	random_number=$RANDOM$RANDOM$RANDOM

	# Go onto server, make backups.
	silentSsh $1 << ENDSSH
	echo "[$1]==> Taking a db dump, storing in ssh home: ~/$random_number.sql"
	drush --root=$sitepath sql-dump > ~/$random_number.sql
	echo "[$1]==> Also taking copy of sites file storing in: ~/$random_number.tar.gz"
	tar -zchf ~/$random_number.tar.gz $sitepath
ENDSSH

	echo "[localhost]==> Making a directory if needed locally: ~/site_copies/$sitename_clean"
	mkdir -p ~/site_copies/$sitename_clean

	echo "[localhost]==> Removing old local db backup: ~/site_copies/$sitename_clean/db.sql"
	rm -rf ~/site_copies/$sitename_clean/db.sql
	echo "[localhost]==> Removing old local files backup: ~/site_copies/$sitename_clean/files_compressed.tar.gz"
	rm -rf ~/site_copies/$sitename_clean/files_compressed.tar.gz

	echo "[localhost]==> Copying sql file to: ~/site_copies/$sitename_clean/db.sql"
	scp $1:~/$random_number.sql ~/site_copies/$sitename_clean/db.sql
	echo "[localhost]==> Copying files file to: ~/site_copies/$sitename_clean/files_compressed.tar.gz"
	scp $1:~/$random_number.tar.gz ~/site_copies/$sitename_clean/files_compressed.tar.gz

	silentSsh $1 << ENDSSH
	echo "[$1]==> Removing temporary sql dump: ~/$random_number.sql"
	rm -rf ~/$random_number.sql
	echo "[$1]==> Removing temporary file copy: ~/$random_number.tar.gz"
	rm -rf ~/$random_number.tar.gz
ENDSSH
}