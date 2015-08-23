FROM mischief/docker-golang
MAINTAINER Frank Lemanschik @ DIREKTSPEED LTD <frank@dspeed.eu>
RUN go get github.com/couchbaselabs/cbfs \
 && go build -o /cbfs github.com/couchbaselabs/cbfs

COPY installer /
COPY run /
CMD /run
