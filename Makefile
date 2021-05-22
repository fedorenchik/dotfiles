all:
	rsync -aHAX .bash_profile .bashrc .cvsignore .editorconfig .gdbinit .gitconfig \
		.git-prompt.sh .inputrc .local .profile .signature $$HOME/
