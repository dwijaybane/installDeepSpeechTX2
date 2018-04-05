#!/bin/bash
# NVIDIA Jetson TX2
# DeepSpeech Installation
# Install DeepSpeech repository then
# setup for compilation
# This does not build DeepSpeech
INSTALL_DIR=$PWD
# This is our project root
cd $HOME/deepspeech
git clone https://github.com/mozilla/DeepSpeech
cd DeepSpeech
git fetch --all --tags --prune
git checkout tags/v0.1.1
# Patch native_client /kenlm/util/double-conversion/utils.h for aarch64 support
patch -p1 < $INSTALL_DIR/patches/utils.patch




