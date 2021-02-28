all:
	rsync -aHAX .bash_profile .bashrc .cvsignore .gdbinit .gitconfig \
		.git-prompt.sh .inputrc .local .profile .signature $$HOME/
