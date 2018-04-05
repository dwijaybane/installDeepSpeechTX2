#!/bin/bash

set -ex
PROJECT_ROOT=$HOME/deepspeech
LD_LIBRARY_PATH=/usr/local/cuda/targets/aarch64-linux/lib/:/usr/local/cuda/targets/aarch64-linux/lib/stubs:$LD_LIBRARY_PATH

export TF_ENABLE_XLA=0
export TF_NEED_JEMALLOC=1
export TF_NEED_GCP=0
export TF_NEED_HDFS=0
export TF_NEED_OPENCL_SYCL=0
export TF_NEED_MKL=0
export TF_NEED_VERBS=0
export TF_NEED_MPI=0
export TF_NEED_S3=0
export TF_NEED_GDR=0
#export TF_SET_ANDROID_WORKSPACE=0
export GCC_HOST_COMPILER_PATH=/usr/bin/gcc
export TF_NEED_CUDA=1
export TX_CUDA_PATH='/usr/local/cuda'
export TX_CUDNN_PATH='/usr/lib/aarch64-linux-gnu/'
export TF_CUDA_FLAGS="TF_CUDA_CLANG=0 TF_CUDA_VERSION=9.0 TF_CUDNN_VERSION=7.0.5 CUDA_TOOLKIT_PATH=${TX_CUDA_PATH} CUDNN_INSTALL_PATH=${TX_CUDNN_PATH} TF_CUDA_COMPUTE_CAPABILITIES=\"3.0,3.5,3.7,5.2,5.3,6.0,6.1,6.2\""


cd ${PROJECT_ROOT}/tensorflow && \
eval "export ${TF_CUDA_FLAGS}" && (echo "" | ./configure) && \
bazel build -s --explain bazel_kenlm_tf.log \
      --verbose_explanations \
      -c opt \
      --copt=-O3 \
      --config=cuda \
      //native_client:libctc_decoder_with_kenlm.so && \
bazel build -s --explain bazel_monolithic_tf.log \
      --verbose_explanations \
      --config=monolithic \
      -c opt \
      --copt=-O3 \
      --config=cuda \
      --copt=-fvisibility=hidden \
      //native_client:libdeepspeech.so \
      //native_client:deepspeech_utils \
      //native_client:generate_trie
