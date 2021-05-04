function _print {
    printf '\n'
    echo "$(tput setaf 6)************************************  $1  ***********************************$(tput sgr0)"
    printf '\n'
}

function _print_config_info_open_edit {
	GIT_ACC=$1
	SSH_PATH=$2
	FINAL_STR="#$GIT_ACC"
	CONFIG="$SSH_PATH/config"
	PUB_PATH="$SSH_PATH/$GIT_ACC.pub"
	echo "" >> $CONFIG
	echo "" >> $CONFIG
	echo "" >> $CONFIG
	echo $FINAL_STR >> $CONFIG
	
	FINAL_STR="Host github.com-$GIT_ACC"
	echo $FINAL_STR >> $CONFIG
	
	FINAL_STR="  HostName github.com"
	echo $FINAL_STR >> $CONFIG
	
	FINAL_STR="  IdentityFile ~/.ssh/$GIT_ACC"
	echo $FINAL_STR >> $CONFIG
	
	FINAL_STR="  IdentitiesOnly yes"
	echo $FINAL_STR >> $CONFIG

	_print "Opening your (Public Key) file with name $GIT_ACC.pub"
	echo "Copy what ever is inside & Follow bellow steps"
	echo "Go to Github > Settings > SSH and GPG keys > New SSH Key"
	echo "Paste what is copied & Create new and start using github with SSH"
	sleep 2
	open -a TextEdit $PUB_PATH
}

function create_ssh_and_add_to_agent {
	GIT_ACC=$1
	EMAIL=$2
	SSH_PATH=$3
	PUB_FILE="$GIT_ACC.pub"
	ssh-keygen -t ed25519 -C "$EMAIL"

	_print "Copying SSH keys to Destination"
	
	cp $GIT_ACC $SSH_PATH
	cp $PUB_FILE $SSH_PATH
	
	_print "Inserting Keys to SSH-Agent"
	
	ssh-add -K "$SSH_PATH/$GIT_ACC"

	rm -Rf $GIT_ACC
	rm -Rf $PUB_FILE

}
function _check_for_git_authentication {
	GIT_ACC=$1
	_print "Authenticating $GIT_ACC"
	read -p "Key Added to Github (y/n)? " -n 1 -r
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		echo "Start Authentication"
		ssh -T git@github.com-$GIT_ACC
	else 
		echo "Recurring the Authentication"
		sleep 0.5
		_check_for_git_authentication $GIT_ACC
	fi
}
GIT_ACC=$1
EMAIL=$2
SSH_PATH=$3

_print "Generating SSH Key for $GIT_ACC with Email: $EMAIL"

create_ssh_and_add_to_agent $GIT_ACC $EMAIL $SSH_PATH

_print_config_info_open_edit $GIT_ACC $SSH_PATH

_check_for_git_authentication $GIT_ACC
