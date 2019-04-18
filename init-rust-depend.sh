#!/bin/sh

cargo install racer
cargo install --force rustfmt
cargo install --force rls

rustup component add rls-preview
rustup component add rust-analysis
rustup component add rust-src
