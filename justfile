# Justfile for Leptos WASM App

# Add WebAssembly target if not already installed
setup:
    @echo "Setting up WASM target..."
    rustup target add wasm32-unknown-unknown

# Run the development server
dev: setup
    @echo "Starting development server..."
    trunk serve --open

# Build the app for production
build: setup
    @echo "Building for production..."
    trunk build --release

# Clean project
clean:
    @echo "Cleaning project..."
    rm -rf dist
    cargo clean
