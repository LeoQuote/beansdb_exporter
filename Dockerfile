FROM golang:alpine as build-env

RUN apk add git

# Copy source + vendor
COPY . /go/src/github.com/messagebird/beansdb_exporter
WORKDIR /go/src/github.com/messagebird/beansdb_exporter

# Build
ENV GOPATH=/go
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GO111MODULE=off go build -v -a -ldflags "-s -w" -o /go/bin/beansdb_exporter .

FROM scratch
COPY --from=build-env /go/bin/beansdb_exporter /usr/bin/beansdb_exporter
ENTRYPOINT ["beansdb_exporter"]
CMD ["-beansdb.address", "localhost:11211"]