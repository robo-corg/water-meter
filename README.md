# WIP: Low water sensor

## Setup

```
rustup toolchain install nightly --component rust-src
rustup target add riscv32imc-unknown-none-elf
rustup target add riscv32imac-unknown-none-elf
rustup update
cargo install espup ldproxy cargo-espflash

espup install
```