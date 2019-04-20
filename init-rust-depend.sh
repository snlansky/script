#!/bin/sh

cargo install protobuf-codegen
cargo install grpcio-compiler
cargo install racer
cargo install --force rustfmt
cargo install --force rls

rustup component add rls-preview
rustup component add rust-analysis
rustup component add rust-src
rustup component add clippy-preview
