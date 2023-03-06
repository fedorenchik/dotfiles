export LFS=/mnt/lfs
[[ "$HOSTNAME" == "vega" ]] && export DATA_STORAGE=/data
[[ "$HOSTNAME" == "orion" ]] && export DATA_STORAGE=/data/data3
export VAGRANT_HOME=$DATA_STORAGE/vagrant
[[ -f ~/.bashrc ]] && . ~/.bashrc
