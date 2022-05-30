# Docker Builder: Buildroot, Linux kernel, cross-compile

Docker image for (cross-)compiling stuff. Mainly used for Linux kernel and
Buildroot images.

## High-level workflow

Build the docker image with:

```bash
./scripts/docker_build.sh
```

The script also creates a new persistent volume called `dxb-vol-<build_id>`,
where `build_id` is a random 8 characters values generated the first time
`docker_build.sh` is called. The idea is that you can clone this repository
multiple times and each build will be associated with a different persistent
volume.
However, as shown later it is possible to start the container with any custum
created volume or without any volume at all.

For running the container interactively execute:

```bash
./scripts/docker_run_inter.sh
```

inside the container you can do all your "cross compilation work" (see the
[examples](#examples)).

The first time the container is executed, the entrypoint script will copy the
Buidroot repository in `${HOME}/workspace/buildroot`.
Note also that `${HOME}/workspace` is the directory where the persitent volume
is mounted. Moreover, `${HOME}/shared` is a directory shared with the host. By
default the root directory of `docker-x-builder` from the host is shared with
the contaier.

It is possible to set a custom persistent volume or a custom shared directory (or
both) by using the options `--volume` and `--shared` with the script
`./scripts/docker_run_inter.sh`.

For example, create a new volume with:

```bash
docker volume create --name myvolume
```

and then run:

```bash
./scripts/docker_run_inter.sh --volume myvolume --shared /tmp
```

With the previous command, the container will used the newly create volume
`myvolume` and the host will share the directory `/tmp`

For deleting the image, the volume and the container, run:

```bash
./scripts/docker_remove_all.sh
```

NOTE: This does not remove the content of `workspace` directory:

Also, it is possible to only remove the volume (`dxb-vol-<build_id>`) with:

```bash
./scripts/docker_remove_volume.sh
```

The volume can be recreated with:

```bash
./scripts/docker_create_volume.sh
```

## Examples

* [Simple ARM (32 bits) Buildroot image](./docs/arm32.md)

## References

* [BuildRoot manual](https://buildroot.org/downloads/manual/manual.html)
