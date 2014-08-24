FROM mischief/docker-golang
RUN go get github.com/couchbaselabs/cbfs/tools/cbfsclient \
 && go get github.com/couchbaselabs/cbfs \
 && cp /root/go/bin/cbfs /usr/local/bin \
 && cp /root/go/bin/cbfsclient /usr/local/bin
COPY installer /
COPY run /
CMD /installer
