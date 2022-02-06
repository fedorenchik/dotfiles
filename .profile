# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

if [ -n "$BASH_VERSION" ]; then
	if [ -f "$HOME/.bashrc" ]; then
		. "$HOME/.bashrc"
	fi
fi

if [ -d "$HOME/.local/bin" ] ; then
	PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/bin" ] ; then
	PATH="$HOME/bin:$PATH"
fi

# Needed to run GUI apps in Docker
xhost +local:root >/dev/null 2>&1

export QT_STYLE_OVERRIDE=kvantum
