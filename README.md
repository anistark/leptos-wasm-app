# Leptos WASM App

A simple web application built with Leptos and compiled to WebAssembly.

## Features

- Built with Rust and Leptos
- Compiles to WebAssembly for fast browser performance
- Includes a reactive counter example
- Includes a todo list example with state management

## Prerequisites

- Rust (latest stable)
- `wasm32-unknown-unknown` target
- Trunk (WASM bundler)

## Quick Start

### Setup

```sh
just setup
```

```sh
# Install the required target
rustup target add wasm32-unknown-unknown

# Install Trunk
cargo install trunk
```

### Development

```sh
# Start the development server
just dev

# Or if you don't have Just installed:
trunk serve --open
```

### Production Build

```sh
# Build for production
just build

# Or if you don't have Just installed:
trunk build --release
```

### Deployment

The project is configured for easy deployment to GitHub Pages:

```sh
# Deploy to GitHub Pages
just deploy
```

## Project Structure

- `src/main.rs`: Entry point for the application
- `src/lib.rs`: Component definitions and application logic
- `index.html`: HTML template for Trunk
- `styles.css`: Application styles
