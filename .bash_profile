#!/bin/bash
export LFS=/mnt/lfs
[[ "$HOSTNAME" == "vega" ]] && export DATA_STORAGE=/data
[[ "$HOSTNAME" == "orion" ]] && export DATA_STORAGE=/data/data3
if [ "$DATA_STORAGE" != "" ]; then
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
    export ANDROID_USER_HOME="$DATA_STORAGE/android_home"
    export GRADLE_USER_HOME="$DATA_STORAGE/gradle_home"
fi
[[ -f ~/.bashrc ]] && . ~/.bashrc
