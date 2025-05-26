FROM bufbuild/buf:1.28.1

# Install basic dependencies
RUN apk add --no-cache git protobuf-dev build-base curl

# Install Go 1.24.3 directly from official source
RUN curl -L https://go.dev/dl/go1.24.3.linux-amd64.tar.gz | tar -C /usr/local -xzf -
ENV PATH="/usr/local/go/bin:${PATH}"
ENV GOPATH="/go"
ENV PATH="${GOPATH}/bin:${PATH}"

# Install Go protoc plugins
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
RUN go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

# Install Rust using rustup (gets latest version)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable
ENV PATH="/root/.cargo/bin:${PATH}"

# Verify Rust installation
RUN rustc --version && cargo --version

# Install Rust protoc plugins
RUN cargo install protoc-gen-prost
RUN cargo install protoc-gen-tonic

WORKDIR /workspace

CMD ["sh"]
