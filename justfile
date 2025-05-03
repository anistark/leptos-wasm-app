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
    # Create a temporary directory for deployment
    rm -rf .gh-pages-tmp || true
    mkdir -p .gh-pages-tmp
    
    # Copy the dist contents to the temporary directory
    cp -r dist/* .gh-pages-tmp/
    
    # Switch to gh-pages branch or create it if it doesn't exist
    git fetch origin gh-pages || true
    if git show-ref --verify --quiet refs/heads/gh-pages; then \
        git checkout gh-pages; \
    else \
        git checkout --orphan gh-pages; \
        git rm -rf .; \
    fi
    
    # Copy the built files to the root
    cp -r .gh-pages-tmp/* .
    
    # Add all files to git
    git add .
    
    # Commit the changes
    git commit -m "Deploy to GitHub Pages" || echo "No changes to commit"
    
    # Push to GitHub
    git push origin gh-pages
    
    # Return to previous branch
    git checkout -
    
    # Clean up temporary directory
    rm -rf .gh-pages-tmp
    
    @echo "Deployment complete! Your site is now available at https://$(git config --get remote.origin.url | sed -e 's/.*github.com[\/:]\(.*\)\.git/\1/' | sed 's/\// /g' | awk '{print $1".github.io/"$2}')/"

# Clean project
clean:
    @echo "Cleaning project..."
    rm -rf dist
    cargo clean
