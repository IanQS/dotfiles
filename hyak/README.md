# .zshenv

To make sure we can access everything and that the paths line up, specify the following

```bash
export UV_CACHE_DIR="/gscratch/scrubbed/itq/uv_cache"
export CARGO_HOME=/gscratch/scrubbed/itq/rust_cargo
export RUSTUP_HOME=/gscratch/scrubbed/itq/rust_rustup
export UV_INSTALL_DIR="/gscratch/scrubbed/itq/uv"
```

# Rust Config

```bash
RUSTUP_HOME=$RUSTUP_HOME CARGO_HOME=$CARGO_HOME bash -c 'curl https://sh.rustup.rs -sSf | sh'
```

# UV config

`curl -LsSf https://astral.sh/uv/install.sh | env UV_INSTALL_DIR=$UV_INSTALL_DIR sh`

