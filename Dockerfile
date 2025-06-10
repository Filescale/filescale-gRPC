FROM bufbuild/buf:1.28.1

# Install basic dependencies
RUN apk add --no-cache git protobuf-dev build-base curl sudo

# Install Go 1.24.3 directly from official source
RUN curl -L https://go.dev/dl/go1.24.3.linux-amd64.tar.gz | tar -C /usr/local -xzf -
ENV PATH="/usr/local/go/bin:${PATH}"
ENV GOPATH="/go"
ENV PATH="${GOPATH}/bin:${PATH}"

# Create Go directories with proper permissions
RUN mkdir -p /go/pkg/mod /go/bin && chmod -R 777 /go
RUN mkdir -p /tmp/go && chmod -R 777 /tmp/go

# Install Go protoc plugins
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
RUN go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

# Install Rust using rustup (gets latest version)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable
ENV PATH="/root/.cargo/bin:${PATH}"

# Install Rust protoc plugins and copy them to global location
RUN cargo install protoc-gen-prost protoc-gen-tonic
RUN cp /root/.cargo/bin/protoc-gen-* /usr/local/bin/

# Create a non-root user with same UID/GID as host user (if provided)
ARG USER_ID=1000
ARG GROUP_ID=1000
RUN addgroup -g ${GROUP_ID} -S devuser && \
    adduser -u ${USER_ID} -S devuser -G devuser -s /bin/sh

RUN chown -R devuser:devuser /go

# Give devuser sudo access
RUN echo "devuser ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

WORKDIR /workspace

# Override the default buf entrypoint - use shell instead
ENTRYPOINT []
CMD ["sh"]
