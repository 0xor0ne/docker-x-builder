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

if [ ! -z "${ID_FILE}" ] ; then
  BID=`get_builder_id ${ROOT_DIR}/${DXB_ID_FILE}`

  docker stop ${DXB_CNTR_NAME}-${BID}
  docker rm ${DXB_CNTR_NAME}-${BID}
fi

exit 0
