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

VOLN=""
SHARED=""
POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
  case $1 in
    -v|--volume)
      VOLN="$2"
      shift # past argument
      shift # past value
      ;;
    -s|--shared)
      SHARED="$2"
      shift # past argument
      shift # past value
      ;;
    *)
      POSITIONAL_ARGS+=("$1") # save positional arg
      shift # past argument
      ;;
  esac
done

set -- "${POSITIONAL_ARGS[@]}" # restore positional parameters

DOCKFILE=${ROOT_DIR}/Dockerfile

BID=`get_builder_id ${ROOT_DIR}/${DXB_ID_FILE}`

IS_RUNNING=$(docker ps --format '{{.Names}}' | \
  grep ${DXB_CNTR_NAME}-${BID})

args="/bin/bash"
if [ ! "$1" = "" ] ; then
  args="$@"
fi

VOLN_MNT="--mount type=volume,src=${DXB_VOL_BASE_NAME}-${BID},dst=/home/${DXB_IMG_USER}/${DXB_VOL_DIR}"
if [ ! -z "${VOLN}" ] ; then
  VOLN_MNT="--mount type=volume,src=${VOLN},dst=/home/${DXB_IMG_USER}/${DXB_VOL_DIR}"
fi

SHARED_MNT="-v ${ROOT_DIR}:/home/${DXB_IMG_USER}/${DXB_SHARED_DIR}"
if [ ! -z ${SHARED} ] ; then
  SHARED_MNT="-v ${SHARED}:/home/${DXB_IMG_USER}/${DXB_SHARED_DIR}"
fi

if [ "${IS_RUNNING}" != "${DXB_CNTR_NAME}-${BID}" ] ; then
  echo "Running container ${DXB_CNTR_NAME}-${BID}"
  docker run -it --rm \
    --name ${DXB_CNTR_NAME}-${BID} \
    --cap-add=NET_ADMIN \
    --device=/dev/net/tun \
    ${VOLN_MNT} ${SHARED_MNT} \
    ${DXB_IMG_NAME} \
    ${args}
else
  echo "Container ${DXB_CNTR_NAME}-${BID} already running. Executing command."
  docker exec -it \
    ${DXB_CNTR_NAME}-${BID} \
    "$@"
fi

exit 0
