# installDeepSpeechTX2
April 4, 2018
Dwijay Bane

Install DeepSpeech on the NVIDIA Jetson TX2 Development Kit

Jetson TX2 is flashed with JetPack 3.2 which installs:
* L4T 28.2 an Ubuntu 16.04 64-bit variant (aarch64)
* CUDA 9.0
* cuDNN 7.0.5

### Pre-built installation

If you are only interested in installing DeepSpeech on the TX2, not building from source, pre-built wheel files are available here: 

If you are interested in building from source, read on.
### Preparation
Before installing DeepSpeech, a swap file should be created (minimum of 8GB recommended). The Jetson TX2 does not have enough physical memory to compile TensorFlow. The swap file may be located on the internal eMMC, and may be removed after the build.

There is a convenience script for building a swap file. To build a 8GB swapfile on the eMMC in the home directory:

`$ ./createSwapfile.sh -d ~/ -s 8`

You can also create swap on a pendrive with empty space of > 8 GB:

`$ ./createSwapfile.sh -d /media/<pendrive>/ -s 8`

After TensorFlow has finished building, the swap file is no longer needed and may be removed.
Go to location where swapfile is then
`sudo swapoff swapfile`

DeepSpeech v0.1.1 should be built in the following order:

#### installPrerequisites.sh
Installs Java and other dependencies needed. Also builds Bazel version 0.11.1.

#### setENV.sh
This sets up the enviornment for setup. If you want to install in virtual env then makes changes as required in this script.

#### cloneDeepSpeech.sh
Git clones v0.1.1 from the mozilla/DeepSpeech repository. This contains the native-client we will
use in tensorflow.

#### cloneTensorFlow.sh
Git clones v1.5.0 from the mozilla/TensorFlow repository and patches the source code for aarch64

## Build DeepSpeech
Once the environment configured, it is time to build DeepSpeech.

#### buildTensorFlow.sh
First we need to build TensorFlow.

#### buildDeepSpeech.sh
Now we can build DeepSpeech wheel.

#### packageDeepSpeech.sh
Once DeepSpeech has finished building, this script may be used to create a 'wheel' file, a package for installing with Python. The wheel file will be in the $HOME directory.

#### Install wheel file
For Python 2.X

`$ pip install $HOME/<em>wheel file</em>`

To install in python virtual enviornment created by setENV.sh (uncomment the section in script):
```
$ source ~/tf-venv-ds/bin/activate
$ pip install deepspeech_gpu-0.1.1-cp27-cp27mu-linux_aarch64.whl
$ pip show deepspeech-gpu
```

### Run inference on a pretrained model 
First download pretrained model
```
$ cd $HOME/deepspeech
$ mkdir pretrained
$ cd pretrained
$ wget -O - https://github.com/mozilla/DeepSpeech/releases/download/v0.1.1/deepspeech-0.1.1-models.tar.gz | tar xvfz -
```

Now run this pretrained model (Its recommended to convert model to mmaped model)
`$ deepspeech models/output_graph.pb models/alphabet.txt test/test3.wav`

This will fail sometimes so better is make mmap-able model as described below.

### Making a mmap-able model for inference
The output_graph.pb model file will be loaded in memory to be dealt with when running inference. This will result in extra loading time and memory consumption. One way to avoid this is to directly read data from the disk.

`$ bazel build tensorflow/contrib/util:convert_graphdef_memmapped_format`

`$ bazel-bin/tensorflow/contrib/util/convert_graphdef_memmapped_format --in_graph=pretrained/models/output_graph.pb --out_graph=pretrained/models/output_graph.pbmm`

Upon sucessfull run, it should report about conversion of a non zero number of nodes. If it reports converting 0 nodes, something is wrong: make sure your model is a frozen one, and that you have not applied any incompatible changes (this includes quantize_weights).
```
$ cd $HOME
$ sudo ./jetson_clocks.sh
$ sudo nvpmodel -m 0
$ source ~/tf-venv-ds/bin/activate   (if you have installed deepspeech in virtual env)
$ cd $HOME/deepspeech/pretrained     (change to directory where your pretrained model is)
```

Now to run inference using mmaped model (This will run fast and consistent)
`$ deepspeech models/output_graph.pbmm models/alphabet.txt models/lm.binary models/trie test/test3.wav`

#### To generate test audio use Audacity
$ sudo apt-get install audacity

Run audacity and record using this config:
16KHz 16bit mono wav file

#### For Building mozilla/Tensorflowr1.5.0
Note: Make sure swap is ON and Performance config to MAX
```
$ cd $HOME/deepspeech/tensorflow
$ bazel build -c opt --local_resources 3072,4.0,1.0 --verbose_failures --config=cuda //tensorflow/tools/pip_package:build_pip_package
$ bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg
$ mv /tmp/tensorflow_pkg/tensorflow-*.whl $HOME/
```
To install in Python virtualEnv:
```
$ source ~/tf-venv-ds/bin/activate
$ cd $HOME
$ pip install tensorflow_warpctc-1.5.0-cp27-cp27mu-linux_aarch64.whl
$ pip show tensorflow-warpctc
$ python -c "import tensorflow as tf; print(tf.__version__)" 
```

### Notes
This Deepspeech installation procedure was derived from these discussion threads: 

<ul>
<li>https://github.com/mozilla/DeepSpeech#getting-the-pre-trained-model</li>
<li>https://github.com/mozilla/DeepSpeech/issues/761</li>
<li>https://discourse.mozilla.org/t/arm-native-client-with-gpu-support/23250/38</li>
<li>https://petewarden.com/2016/09/27/tensorflow-for-mobile-poets/</li>
</ul>



## License
MIT License

Copyright (c) 2018 Dwijay Bane

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
