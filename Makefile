.PHONY: generate validate lint clean test dev build help


# Get current user ID and group ID for Docker
USER_ID := $(shell id -u)
GROUP_ID := $(shell id -g)

# Export for docker-compose
export USER_ID
export GROUP_ID

# Build the Docker image
build:
	@echo "Building protocol generator image..."
	@docker compose build generator
	@echo "Generator image built successfully"

# Generate code using Docker (just buf, no lib.rs creation)
generate:
	@echo "Generating protocol code..."
	@docker compose run --rm generator buf generate
	@echo "Protocol code generated successfully"
	# @echo "Building Rust protocol code in container..."
	# @docker compose run --rm generator sh -c "cargo build --release"
	# @echo "Rust protocol code built successfully"

# Validate protocol files using Docker
validate:
	@echo "Validating protocol files..."
	@docker compose run --rm generator buf lint
	@echo "Validation passed"

# Test Go code compilation using Docker
test-go:
	@echo "Testing Go compilation..."
	@docker compose run --rm generator sh -c "cd gen/go && go mod tidy && go build ./..."
	@echo "Go compilation test passed"

# Clean generated code
clean:
	@echo "Cleaning generated code..."
	@rm -rf gen/go/filescale/
	@rm -rf gen/rust/
	@echo "Generated code cleaned"

# Full development workflow
dev: build generate validate test-go
	@echo "Development workflow complete!"

# Show available commands
help:
	@echo "Available commands:"
	@echo "  make build     - Build the Docker generator image"
	@echo "  make generate  - Generate Go and Rust code from protobuf"
	@echo "  make validate  - Validate protocol files"
	@echo "  make test-go   - Test Go code compilation"
	@echo "  make clean     - Clean generated code"
	@echo "  make dev       - Full development workflow"
