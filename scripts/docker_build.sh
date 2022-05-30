#!/usr/bin/env bash

#
# docker-x-builder
# Copyright (C) 2022  0xor0ne
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with
# this program. If not, see <https://www.gnu.org/licenses/>.

# Get script actual directory
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ROOT_DIR=${SCRIPT_DIR}/..
source ${SCRIPT_DIR}/common.sh
source_env

DOCKFILE=${ROOT_DIR}/Dockerfile

echo "===================================================="
echo "### Building docker image ${DXB_IMG_NAME}"
echo "===================================================="
docker build -f ${DOCKFILE} -t ${DXB_IMG_NAME} \
  --build-arg user=${DXB_IMG_USER} \
  --build-arg volume_dir=${DXB_VOL_DIR} \
  ${ROOT_DIR}

echo "===================================================="
echo "### Creating volume"
echo "===================================================="
${ROOT_DIR}/scripts/docker_create_volume.sh

