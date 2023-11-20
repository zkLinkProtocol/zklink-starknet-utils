# zklink-starknet-utils
## About

zklink-starknet-utils is a collection of useful functions and data structures implemented in Cairo.

## Getting Started

### Prerequisites

- [Cairo](https://github.com/starkware-libs/cairo)
- [Scarb](https://docs.swmansion.com/scarb)

### Installation

zklink-starknet-utils is a collection of utility Cairo functions and data structures.
`zklink_starknet_utils` package can be installed by adding the following line to your `Scarb.toml`:

```toml
[dependencies]
zklink_starknet_utils = { git = "https://github.com/zkLinkProtocol/zklink-starknet-utils.git" }
```

then add the following line in your `.cairo` file

```rust
use zklink_starknet_utils::bytes::{Bytes, BytesTrait};
```

## Usage

### Build

```bash
scarb build
```

### Test

```bash
scarb test
```

### Format

```bash
scarb fmt
```