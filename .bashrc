[[ $- != *i* ]] && return

colors() {
	local fgc bgc vals seq0

	printf "Color escapes are %s\n" '\e[${value};...;${value}m'
	printf "Values 30..37 are \e[33mforeground colors\e[m\n"
	printf "Values 40..47 are \e[43mbackground colors\e[m\n"
	printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

	# foreground colors
	for fgc in {30..37}; do
		# background colors
		for bgc in {40..47}; do
			fgc=${fgc#37} # white
			bgc=${bgc#40} # black

			vals="${fgc:+$fgc;}${bgc}"
			vals=${vals%%;}

			seq0="${vals:+\e[${vals}m}"
			printf "  %-9s" "${seq0:-(default)}"
			printf " ${seq0}TEXT\e[m"
			printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
		done
		echo; echo
	done
}

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

[[ -f /usr/share/bash-completion/completions/git ]] && . /usr/share/bash-completion/completions/git
[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

if [ -d "$HOME/bin" ] ; then
	PATH="$HOME/bin:$PATH"
fi

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export SDL_IM_MODULE=fcitx
export GLFW_IM_MODULE=ibus

ulimit -c unlimited

HISTTIMEFORMAT="%F %T "
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=10000
HISTFILESIZE=20000
HISTIGNORE="ls:cd:cd -:pwd:exit:date"
shopt -s checkwinsize
shopt -s globstar
shopt -s expand_aliases

GREP_OPTIONS="--color=auto"
LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD

source ~/.git-prompt.sh

xhost +local:root > /dev/null 2>&1
complete -cf sudo

ATTR_PREFIX='\[\e['
ATTR_SUFFIX='m\]'
ATTR_SEPARATOR=';'

ATTR_RESET='0'
ATTR_BOLD='1'
ATTR_UNDERLINED='4'

ATTR_DEFAULT='39'
ATTR_BLACK='30'
ATTR_RED='31'
ATTR_GREEN='32'
ATTR_YELLOW='33'
ATTR_BLUE='34'
ATTR_MAGENTA='35'
ATTR_CYAN='36'
ATTR_LIGHT_GRAY='37'
ATTR_DARK_GRAY='90'
ATTR_LIGHT_RED='91'
ATTR_LIGHT_GREEN='92'
ATTR_LIGHT_YELLOW='93'
ATTR_LIGHT_BLUE='94'
ATTR_LIGHT_MAGENTA='95'
ATTR_LIGHT_CYAN='96'
ATTR_WHITE='97'

ATTR_BG_DEFAULT='49'
ATTR_BG_BLACK='40'
ATTR_BG_RED='41'
ATTR_BG_GREEN='42'
ATTR_BG_YELLOW='43'
ATTR_BG_BLUE='44'
ATTR_BG_MAGENTA='45'
ATTR_BG_CYAN='46'
ATTR_BG_LIGHT_GRAY='47'
ATTR_BG_DARK_GRAY='100'
ATTR_BG_LIGHT_RED='101'
ATTR_BG_LIGHT_GREEN='102'
ATTR_BG_LIGHT_YELLOW='103'
ATTR_BG_LIGHT_BLUE='104'
ATTR_BG_LIGHT_MAGENTA='105'
ATTR_BG_LIGHT_CYAN='106'
ATTR_BG_WHITE='107'

COLOR_RESET=${ATTR_PREFIX}${ATTR_RESET}${ATTR_SUFFIX}
C_R=$COLOR_RESET
COLOR_YELLOW=${ATTR_PREFIX}${ATTR_YELLOW}${ATTR_SUFFIX}
C_Y=$COLOR_YELLOW
COLOR_MAGENTA=${ATTR_PREFIX}${ATTR_MAGENTA}${ATTR_SUFFIX}
C_M=$COLOR_MAGENTA
COLOR_BOLD_GREEN=${ATTR_PREFIX}${ATTR_BOLD}${ATTR_SEPARATOR}${ATTR_GREEN}${ATTR_SUFFIX}
C_B_G=$COLOR_BOLD_GREEN
COLOR_BOLD_BLUE=${ATTR_PREFIX}${ATTR_BOLD}${ATTR_SEPARATOR}${ATTR_BLUE}${ATTR_SUFFIX}
C_B_B=$COLOR_BOLD_BLUE
COLOR_BOLD_LIGHT_YELLOW=${ATTR_PREFIX}${ATTR_BOLD}${ATTR_SEPARATOR}${ATTR_LIGHT_YELLOW}${ATTR_SUFFIX}
C_B_L_Y=$COLOR_BOLD_LIGHT_YELLOW

GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWUPSTREAM="auto"
GIT_PS1_SHOWUPSTREAM="verbose name git"
GIT_PS1_DESCRIBE_STYLE="branch"
GIT_PS1_SHOWCOLORHINTS=1

function prompt_command()
{
	__git_ps1 "${debian_chroot:+($debian_chroot)}${CONDA_DEFAULT_ENV:+(conda ${CONDA_DEFAULT_ENV})}${VIRTUAL_ENV:+(py ${VIRTUAL_ENV##*/})}$C_B_G\u@\h!\l$C_R:$C_B_B\w$C_R " " \n $C_Y{\j}$C_R $C_M\t$C_R [\$?] \\\$ " "<%s>"
}

PROMPT_COMMAND=prompt_command

use_color=true

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.
safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
	&& type -P dircolors >/dev/null \
	&& match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color} ; then
	# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
	if type -P dircolors >/dev/null ; then
		if [[ -f ~/.dir_colors ]] ; then
			eval $(dircolors -b ~/.dir_colors)
		elif [[ -f /etc/DIR_COLORS ]] ; then
			eval $(dircolors -b /etc/DIR_COLORS)
		fi
	fi

	if [[ ${EUID} == 0 ]] ; then
		PS1='\[\033[01;31m\][\h\[\033[01;36m\] \W\[\033[01;31m\]]\$\[\033[00m\] '
	else
		PS1='\[\033[01;32m\][\u@\h\[\033[01;37m\] \W\[\033[01;32m\]]\$\[\033[00m\] '
	fi

	alias ls='ls --color=auto'
	alias grep='grep --colour=auto'
	alias egrep='egrep --colour=auto'
	alias fgrep='fgrep --colour=auto'
else
	if [[ ${EUID} == 0 ]] ; then
		# show root@ when we don't have colors
		PS1='\u@\h \W \$ '
	else
		PS1='\u@\h \w \$ '
	fi
fi

unset use_color safe_term match_lhs sh

if which zoxide >/dev/null 2>&1; then
	eval "$(zoxide init bash)"
	alias cd="z"
fi

if which exa >/dev/null 2>&1; then
	alias ls="exa --icons"
fi

if which bat >/dev/null 2>&1; then
	alias cat="bat"
fi

export FZF_DEFAULT_COMMAND='find . \! \( -type d -path ./.git -prune \) \! -type d \! -name '\''*.tags'\'' -printf '\''%P\n'\'

if which delta >/dev/null 2>&1; then
	alias less="delta"
fi

if which rg >/dev/null 2>&1; then
	alias grep="rg"
fi

if which tre >/dev/null 2>&1; then
	alias tree="tre"
fi

if which dua >/dev/null 2>&1; then
	alias du="dua"
fi

if which micro >/dev/null 2>&1; then
	alias nano="micro"
fi

alias cp="cp -i"
alias free='free -h'
#alias np='nano -w PKGBUILD'
alias more=less
alias ll='ls -lh'
alias la='ls -A'
alias l='ls'
complete -F _longopt l
alias b=exit
alias f='pcmanfm-qt >/dev/null 2>&1 & disown'
alias g=git
complete -o bashdefault -o default -o nospace -F __git_wrap__git_main g
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias vman='MANPAGER="gvim --not-a-term -M +MANPAGER -" man'

export LFS=/mnt/lfs
export PYENV_ROOT="$HOME/.pyenv"
[[ "$HOSTNAME" == "orion" ]] && export DATA_STORAGE=/data/data3
if [ "$DATA_STORAGE" != "" ] && [ -d "$DATA_STORAGE" ]; then
    export VAGRANT_HOME="$DATA_STORAGE/vagrant.d"
    export NLTK_DATA="$DATA_STORAGE/nltk_data"
    export GOPATH="$DATA_STORAGE/go"
    export MAMBA_ROOT_PREFIX="$DATA_STORAGE/micromamba"
    export TFDS_DATA_DIR="$DATA_STORAGE/tensorflow_datasets"
    export CONDA_ENVS_DIRS="$DATA_STORAGE/conda_home/envs"
    export GEM_HOME="$DATA_STORAGE/gem_home"
    export GEM_PATH="$DATA_STORAGE/gem_home"
    export CARGO_HOME="$DATA_STORAGE/cargo_home"
    export JULIA_DEPOT_PATH="$DATA_STORAGE/julia_home"
    export KERAS_HOME="$DATA_STORAGE/keras_home"
    export NPM_CONFIG_CACHE="$DATA_STORAGE/npm_home"
    export GRADLE_USER_HOME="$DATA_STORAGE/gradle_home"
    export PYENV_ROOT="$DATA_STORAGE/pyenv_root"
    export FVM_HOME="$DATA_STORAGE/fvm"
elif [ "$HOSTNAME" == "vega" ]; then
    export FVM_HOME="$HOME/.local/opt/fvm"
fi

# ex - archive extractor
# usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1    ;;
      *.tar.gz)    tar xzf $1    ;;
      *.bz2)       bunzip2 $1    ;;
      *.rar)       unrar x $1    ;;
      *.gz)        gunzip $1     ;;
      *.tar)       tar xf $1     ;;
      *.tbz2)      tar xjf $1    ;;
      *.tgz)       tar xzf $1    ;;
      *.zip)       unzip $1      ;;
      *.Z)         uncompress $1 ;;
      *.7z)        7z x $1       ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

lh()
{
	if [ "$*" == "" ]; then
		ls -d .*
	else
		for i in "$@"; do
			if [ -d "$i" ]; then
				ls -d "$i"/.*
			elif [ -f "$i" ]; then
				ls "$i"
			else
				ls "$i"
			fi
		done
	fi
}

e()
{
	gvim "$@" 2>>/tmp/gvim.out
}

r()
{
	gvim -M -R -i NONE "$@" 2>>/tmp/gvim.out
}

S()
{
	gvim --cmd 'let g:vimrc_auto_session=1' "$@" 2>>/tmp/gvim.out
}

# usage: codi [filetype] [filename]
codi()
{
	local syntax="${1:-python}"
	shift
	gvim -c \
		"let g:startify_disable_at_vimenter = 1 |\
		set bt=nofile ls=0 noru nonu nornu |\
		hi ColorColumn cctermbg=NONE |\
		hi VertSplit ctermbg=NONE |\
		hi NonText ctermfg=0 |\
		Codi $syntax" "$@"
}

# argument can be 'c' or 'c++'
gcc_include_search()
{
	echo $(gcc -E -v -x "$1" /dev/null 2>&1 | sed -e '1,/#include </d' -e '/^End/,$d')
}

export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

export VAGRANT_DEFAULT_PROVIDER=libvirt

# python virtualenv
export VIRTUAL_ENV_DISABLE_PROMPT=1
export WORKON_HOME=~/.virtualenvs
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
if [ -x /usr/local/bin/virtualenvwrapper.sh ]; then
	source /usr/local/bin/virtualenvwrapper.sh
fi

# direnv
if command -v direnv >/dev/null 2>&1; then
	eval "$(direnv hook bash)"
fi

export PIP_REQUIRE_VIRTUALENV=true
gpip() {
	PIP_REQUIRE_VIRTUALENV="" pip "$@"
}

# Anaconda / Miniconda
conda-init() {
CONDA='miniconda3'
if [ -e /opt/anaconda/bin/conda ]; then
	CONDA='anaconda'
fi
__conda_setup="$('/opt/$CONDA/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
	eval "$__conda_setup"
else
	if [ -f "/opt/$CONDA/etc/profile.d/conda.sh" ]; then
		. "/opt/$CONDA/etc/profile.d/conda.sh"
	else
		export PATH="/opt/$CONDA/bin:$PATH"
	fi
fi
unset __conda_setup
unset CONDA
# conda init
}

espidf-init() {
. "$HOME/.local/opt/esp-idf-v5.3.2/export.sh"
}

idf-init() {
espidf-init
}

pio-init() {
. "$HOME/.platformio/penv/bin/activate"
}

nvm-init() {
	. /usr/share/nvm/init-nvm.sh
}

[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
