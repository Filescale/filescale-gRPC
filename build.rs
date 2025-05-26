fn main() -> Result<(), Box<dyn std::error::Error>> {
    // This build script generates the lib.rs file for Rust
    let lib_content = r#"
//! # Filescale Protocol
//! 
//! Generated gRPC protocol definitions for the Filescale distributed filesystem monitoring system.
//! 
//! This crate provides Rust types and gRPC client/server traits for communicating between
//! Filescale clients and servers.
//! 
//! ## Usage
//! 
//! ```rust
//! use filescale_gRPC::{
//!     client_service_client::ClientServiceClient,
//!     RegisterClientRequest,
//!     ClientCapabilities,
//!     PlatformInfo
//! };
//! 
//! // Create a gRPC client
//! let mut client = ClientServiceClient::connect("http://server:9090").await?;
//! 
//! // Register with server
//! let request = RegisterClientRequest {
//!     client_id: "my-client".to_string(),
//!     hostname: "laptop".to_string(),
//!     version: "0.1.0".to_string(),
//!     watched_paths: vec!["/home/user/files".to_string()],
//!     capabilities: Some(ClientCapabilities::default()),
//!     platform: Some(PlatformInfo::default()),
//! };
//! 
//! let response = client.register_client(request).await?;
//! ```

pub mod filescale {
    pub mod v1 {
        tonic::include_proto!("filescale.v1");
    }
}

// Re-export everything from v1 for convenience
pub use filescale::v1::*;
"#;

    std::fs::write("gen/rust/src/lib.rs", lib_content)?;

    Ok(())
}
