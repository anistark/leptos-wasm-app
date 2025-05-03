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

# Deploy to GitHub Pages
deploy: build
    @echo "Deploying to GitHub Pages..."
    # Store the absolute path to the dist directory
    DIST_PATH="$(pwd)/dist" && \
    
    # Create a clean temporary directory
    rm -rf .gh-pages-tmp || true && \
    mkdir -p .gh-pages-tmp && \
    
    # Clone the repository into the temporary directory
    git clone $(git config --get remote.origin.url) .gh-pages-tmp && \
    cd .gh-pages-tmp && \
    
    # Fetch gh-pages branch if it exists
    git fetch origin gh-pages || true && \
    
    # Check if gh-pages branch exists remotely or locally
    if git rev-parse --verify --quiet origin/gh-pages >/dev/null; then \
        git checkout -B gh-pages origin/gh-pages; \
    else \
        git checkout --orphan gh-pages && \
        git reset --hard; \
    fi && \
    
    # Remove all existing files
    git rm -rf . || true && \
    
    # Copy the dist contents using the absolute path
    cp -r "$DIST_PATH"/* ./ && \
    
    # Add, commit and push the changes
    git add . && \
    git commit -m "Deploy to GitHub Pages" || echo "No changes to commit" && \
    git push origin gh-pages --force && \
    
    # Return to parent directory and cleanup
    cd .. && \
    rm -rf .gh-pages-tmp && \
    
    @echo "Deployment complete! Site available at https://$(git config --get remote.origin.url | sed -e 's/.*github.com[\/:]\(.*\)\.git/\1/' | sed 's/\// /g' | awk '{print $1".github.io/"$2}')/"
    
    @echo "Deployment complete! Site available at https://$(git config --get remote.origin.url | sed -e 's/.*github.com[\/:]\(.*\)\.git/\1/' | sed 's/\// /g' | awk '{print $1".github.io/"$2}')/"
    
    @echo "Deployment complete! Site available at https://$(git config --get remote.origin.url | sed -e 's/.*github.com[\/:]\(.*\)\.git/\1/' | sed 's/\// /g' | awk '{print $1".github.io/"$2}')/"

# Clean project
clean:
    @echo "Cleaning project..."
    rm -rf dist
    cargo clean
