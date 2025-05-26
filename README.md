# filescale-gRPC

gRPC protocol definitions for the Filescale distributed filesystem monitoring system.

## Overview

This repository contains the protocol buffer definitions and generated code for communication between Filescale clients and servers.

## Languages Supported

- **Go**: `github.com/Filescale/filescale-gRPC/go`
- **Rust**: `filescale-gRPC` (on crates.io)

## Usage

### Go (Server)

```go
import pb "github.com/yourorg/filescale-protocol/go/filescale/v1"

// Implement gRPC services
type server struct {
    pb.UnimplementedClientServiceServer
}
```

