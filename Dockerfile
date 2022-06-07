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

From debian:stable-slim

LABEL description="Container for linux cross-compilation"

ARG user=user
ARG root_password=rootpasswd
ARG volume_dir=workspace

# Setup environment
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y
# Required for Linux kernel
RUN apt-get install -y --no-install-recommends \
      build-essential \
      ncurses-dev \
      kmod \
      jfsutils \
      reiserfsprogs \
      xfsprogs \
      pcmciautils \
      quota \
      iproute2 \
      uml-utilities \
      iptables \
      iputils-ping \
      ppp \
      openssh-client \
      libgmp-dev \
      libmpc-dev \
      btrfs-progs \
      squashfs-tools \
      bc \
      git \
      flex \
      bison \
      locales \
      libssl-dev \
      vim \
      rsync \
      ca-certificates \
      file \
      wget \
      cpio \
      unzip \
      sudo
# Other dependencies
# RUN apt-get install -y --no-install-recommends \

# Enable UTF-8 locale
RUN sed -i 's/# \(en_US.UTF-8\)/\1/' /etc/locale.gen && \
  /usr/sbin/locale-gen

# Set root password
RUN echo "root:${root_password}" | chpasswd

# Add user
RUN useradd -ms /bin/bash ${user} && \
  chown -R ${user}:${user} /home/${user}
RUN echo "${user} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
WORKDIR /home/${user}/

# Copy utility scripts
# TODO

# This is where the volume will be mounted
RUN mkdir ${volume_dir} && chown -R ${user}:${user} ${volume_dir}
RUN mkdir data && chown -R ${user}:${user} data

# Fix terminfo database for gdb
RUN rm -r /usr/share/terminfo/ && \
  ln -s /lib/terminfo/ /usr/share/terminfo

# Clone buildroot
RUN cd data && \
  git clone https://github.com/buildroot/buildroot.git buildroot && \
  cd buildroot && git checkout `git describe --tag --abbrev=0`

# Copy entrypoint script
COPY scripts/entrypoint.sh /entrypoint.sh

# Copy environment file
COPY config.env /config.env
RUN chown ${user}:${user} /config.env

USER ${user}
ENV LC_ALL en_US.UTF-8
ENV TERM xterm-256color
ENTRYPOINT ["/entrypoint.sh"]

CMD ["/bin/bash"]

