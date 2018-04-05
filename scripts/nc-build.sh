#!/bin/bash

SYSTEM_TARGET=host
EXTRA_LOCAL_CFLAGS="-march=armv8-a"
EXTRA_LOCAL_LDFLAGS="-L/usr/local/cuda/targets/aarch64-linux/lib/ -L/usr/local/cuda/targets/aarch64-linux/lib/stubs -lcudart -lcuda"
SETUP_FLAGS="--project_name deepspeech-gpu"
DS_TFDIR="${HOME}/deepspeech/tensorflow"
cd ./DeepSpeech
mkdir -p wheels
make clean 
EXTRA_CFLAGS="${EXTRA_LOCAL_CFLAGS}" \
EXTRA_LDFLAGS="${EXTRA_LOCAL_LDFLAGS}" \
EXTRA_LIBS="${EXTRA_LOCAL_LIBS}" \
make -C native_client/ \TARGET=${SYSTEM_TARGET} \
      TFDIR=${DS_TFDIR} \
      SETUP_FLAGS="${SETUP_FLAGS}" \
      bindings-clean bindings

cp native_client/dist/*.whl wheels

make -C native_client/ bindings-clean
