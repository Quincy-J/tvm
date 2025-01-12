#!/bin/bash -e
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

set -ex

# TVM
# NOTE: TVM is presumed to be mounted already by Vagrantfile.
cd "${TVM_HOME}"

platform="zephyr"
apps/microtvm/reference-vm/rebuild-tvm.sh ${platform}

# Build poetry
cd apps/microtvm/reference-vm/zephyr

poetry env use 3.7

# importers
poetry install -E importer-onnx
poetry install -E importer-tflite

poetry install
poetry run pip3 install -r ${ZEPHYR_BASE}/scripts/requirements.txt

echo "export TVM_LIBRARY_PATH=\"$TVM_HOME\"/build-microtvm-${platform}" >>~/.profile
echo "VENV_PATH=\$((cd \"$TVM_HOME\"/apps/microtvm/reference-vm/zephyr && poetry env list --full-path) | sed -E 's/^(.*)[[:space:]]\(Activated\)\$/\1/g')" >>~/.profile
echo "source \$VENV_PATH/bin/activate" >>~/.profile
echo "export PATH=\"\${PATH}:\${HOME}/zephyr-sdk/sysroots/x86_64-pokysdk-linux/usr/bin\"" >>~/.profile
echo "export CMSIS_PATH=\"\${HOME}/cmsis\"" >>~/.profile
