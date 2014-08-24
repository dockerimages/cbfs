cbfs
====

Installs or runs cbfs &amp; cbfsclient

# cbfs in a can importent this README Includes Parts from japatezo/nsenter becaus i need em as reminder to add that in the readme

This is a small Docker recipe to build `cbfs` easily and install it in your
system. or use it directly inside the container


## What is `cbfs`?

It is a small tool allowing to `mount` couchbase buckets `s`paces. Technically,


## Why build `cbfs` in a container?

This is because my preferred distros (Debian and Ubuntu) ship with an
outdated version of `go` (the package that should build `cbfs`).
Therefore, if you need `cbfs` on those distros, you have to juggle with
APT repository, or compile from source, or… Ain't nobody got time for that.

I'm going to make a very bold assumption: if you landed here, it's because
you want to use cbfs and cbfs monitor

## How do I install `cbfs` with this?

If you want to install `cbfs` into `/usr/local/bin`, just do this:

    docker run --rm -v /usr/local/bin:/target dockerimages/cbfs

The `dockerimages/cbfs` container will detect that `/target` is a
mountpoint, and it will copy the `cbfs` binary into it.

If you don't trust me, and prefer to extract the `cbfs` binary,
rather than allowing my container to potentially wreak havoc into
your system's `$PATH`, you can also do this:

    docker run --rm dockerimaes/cbfs cat /root/go/ > /tmp/cbfs

Then do whatever you want with the binary in `/tmp/nsenter`.


##  How do I *use* `nsenter`?

First, figure out the PID of the container you want to enter:

    PID=$(docker inspect --format {{.State.Pid}} <container_name_or_ID>)

Then enter the container:

    nsenter --target $PID --mount --uts --ipc --net --pid


## What's that docker-enter thing?

It's just a small shell script that wraps up the steps described above into
a tiny helper. It takes the name or ID of a container and optionally the name
of a program to execute inside the namespace. If no command is specified a
shell will be invoked instead.

    # list the root filesystem
    docker-enter my_awesome_container ls -la

## docker-enter with boot2docker

If you are using boot2docker, you can use the function below, to:

- install `nsenter` and `docker-enter` into boot2docker's /var/lib/boot2docker/ directory,
  so they survive restarts.
- execute `docker-enter` inside of boot2docker combined with ssh

```
docker-enter() {
  boot2docker ssh '[ -f /var/lib/boot2docker/nsenter ] || docker run --rm -v /var/lib/boot2docker/:/target jpetazzo/nsenter'
  boot2docker ssh sudo /var/lib/boot2docker/docker-enter "$@"
}
```

You can use it directly from your host (OS X/Windows), no need to ssh into boot2docker.

## Caveats

- This only works on Intel 64 bits platforms. Arguably, this is the
  only officially supported platform for Docker; so it's not a big deal.
  As soon as the Docker registry supports other architectures, I will
  see how to build `nsenter` for those!
- `nsenter` still needs to run from the host; it cannot run inside a
  container (yet).
