#!/bin/bash
# NVIDIA Jetson TX2
# DeepSpeech Installation

cd $HOME
mkdir deepspeech
#Run all 6 cores at full performance
sudo ./jetson_clocks.sh
sudo nvpmodel -m 0

#if you want to install deepspeech in python virtual enviornment
#sudo pip install virtualenv
#cd $HOME
#mkdir tf-venv-ds
#virtualenv --system-site-packages ~/tf-venv-ds
