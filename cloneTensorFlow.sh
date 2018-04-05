#!/bin/bash
# NVIDIA Jetson TX2
# mozilla/TensorFlow Installation
# Install Tensorflow repository then
# setup for compilation
# This does not build tensorflow
INSTALL_DIR=$PWD
# This is our project root
cd $HOME/deepspeech
git clone https://github.com/mozilla/tensorflow
cd tensorflow && git checkout r1.5
#put a symlink to native client
ln -s ../DeepSpeech/native_client ./
cd $HOME
ln -s deepspeech/DeepSpeech ./
ln -s deepspeech/tensorflow ./
# Patch up the Workspace.bzl for the Github Checksum issue
#patch -p1 < $INSTALL_DIR/patches/workspacebzl.patch




