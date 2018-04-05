#!/bin/bash
# NVIDIA Jetson TX2
# copy and replace tc-build.sh script in tensorflow
INSTALL_DIR=$PWD
cp -nrf $INSTALL_DIR/scripts/tc-build.sh $HOME/deepspeech/tensorflow/
# Build Tensorflow
cd $HOME/deepspeech/tensorflow
./tc-build.sh
