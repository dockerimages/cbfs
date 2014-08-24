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


How do I get the stuff
======================

    go get github.com/couchbaselabs/cbfs

And you'll find the source in
`$GOPATH/src/github.com/couchbaselabs/cbfs` (and a `cbfs` binary
should be in your path)

How do I build the stuff
========================

```
cd $GOPATH/src/pkg/github.com/couchbaselabs/cbfs
go build
```

How do I run the stuff
======================

```
mkdir -p /tmp/localdata
./cbfs -nodeID=$mynodeid \
       -bucket=cbfs \
       -couchbase=http://$mycouchbaseserver:8091/
       -root=/tmp/localdata \
       -viewProxy
```

The server will be empty at this point, you can install the monitor
using cbfsclient (`go get github.com/couchbaselabs/cbfs/tools/cbfsclient`)

```
cbfsclient http://localhost:8484/ upload \
    $GOPATH/src/github.com/couchbaselabs/cbfs/monitor monitor
```

Then go to [http://localhost:8484/monitor/](http://localhost:8484/monitor/)


## Caveats

- This only works on Intel 64 bits platforms. Arguably, this is the
  only officially supported platform for Docker; so it's not a big deal.
  As soon as the Docker registry supports other architectures, I will
  see how to build `nsenter` for those!
- `nsenter` still needs to run from the host; it cannot run inside a
  container (yet).
