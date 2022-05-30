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

# Generate new builder ID if required
if [ "$(cat ${ROOT_DIR}/${DXB_ID_FILE})" == "default" -o \
      ! -f ${ROOT_DIR}/${DXB_ID_FILE} ] ; then
  TMP=`generate_builder_id`
  echo -n ${TMP} > ${ROOT_DIR}/${DXB_ID_FILE}
fi

BID=`get_builder_id ${ROOT_DIR}/${DXB_ID_FILE}`

VOLN="${DXB_VOL_BASE_NAME}-${BID}"

if [ -z "$(docker volume ls | grep "${VOLN}")" ] ; then
  echo "Creating volume ${VOLN}"
  docker volume create --name ${VOLN}
else
  echo "#######################################################################"
  echo "#######################################################################"
  echo "Volume ${VOLN} exists."
  echo "If you want to recreate it, run:"
  echo ""
  echo "docker volume rm ${VOLN} && ${ROOT_DIR}/scripts/docker_create_volume.sh"
  echo "#######################################################################"
  echo "#######################################################################"
fi

