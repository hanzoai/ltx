FROM golang:1.26.5 AS builder
# go.mod pins the toolchain. The golang base image sets GOTOOLCHAIN=local,
# which turns a `go` directive newer than the image into a hard build
# failure instead of a download.
ENV GOTOOLCHAIN=auto

WORKDIR /src/ltx
COPY . .

ARG LTX_VERSION=
ARG LTX_COMMIT=

RUN go build -ldflags "-s -w -X 'main.Version=${LTX_VERSION}' -X 'main.Commit=${LTX_COMMIT}' -extldflags '-static'" -o /usr/local/bin/ltx ./cmd/ltx


FROM scratch
COPY --from=builder /usr/local/bin/ltx /usr/local/bin/ltx
ENTRYPOINT ["/usr/local/bin/ltx"]
CMD []
