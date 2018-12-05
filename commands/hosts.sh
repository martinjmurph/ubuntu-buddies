function hosts() {
	if [ -z "$*" ]; then
		echo '---------- Hosts ----------------' && grep -w -i "Host" ~/.ssh/config | sed 's/Host //' | awk '{print}' ORS=', ' && echo ' ' && echo '---------------------------------'
		return 1
	fi

	echo "----------Search for >${1}< in hosts--------------"
	grep -w -i "Host" ~/.ssh/config | sed 's/Host //' || awk '{print}' | grep ${1}
}