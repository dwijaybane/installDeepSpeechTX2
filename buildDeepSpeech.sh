#!/bin/bash
# NVIDIA Jetson TX2
# copy native client build script
INSTALL_DIR=$PWD
cp $INSTALL_DIR/scripts/nc-build.sh $HOME/deepspeech
# Build DeepSpeech
cd $HOME/deepspeech
./nc-build.sh
