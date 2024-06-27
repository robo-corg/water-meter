# WIP: Low water sensor

## Sensors

### Gikfun XKC-Y25-NPN

Cable

Brown wire : VCC ( DC 5-12V connects power positive)
Yellow wire: OUT( signal output)
Blue wire: GND(connects power negative)
Black wire:M(mode of NO/NC)



## Setup

```
rustup toolchain install nightly --component rust-src
rustup target add riscv32imc-unknown-none-elf
rustup target add riscv32imac-unknown-none-elf
rustup update
cargo install espup ldproxy cargo-espflash

espup install
```