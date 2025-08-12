# Makefile for Blockfrost Lean4 SDK

.PHONY: build test clean demo health check help

# Default target
all: build

# Build the project
build:
	@echo "🔨 Building Blockfrost SDK..."
	lake build

# Run all tests
test: build
	@echo "🧪 Running all tests..."
	./.lake/build/bin/demo

# Quick health check
health: build
	@echo "🏥 Running health check..."
	./.lake/build/bin/demo health

# Run network tests
network: build
	@echo "🌐 Running network tests..."
	./.lake/build/bin/demo network

# Run account tests  
accounts: build
	@echo "👤 Running account tests..."
	./.lake/build/bin/demo accounts

# Run demo examples
demo: build
	@echo "🚀 Running demo examples..."
	lean --run Examples/Demo.lean

# Check if environment is set up
check:
	@echo "🔍 Checking environment..."
	@if [ -z "$$BLOCKFROST_PROJECT_ID" ]; then \
		echo "❌ BLOCKFROST_PROJECT_ID environment variable not set"; \
		echo "   Please set it with: export BLOCKFROST_PROJECT_ID=your_project_id"; \
		exit 1; \
	else \
		echo "✅ BLOCKFROST_PROJECT_ID is set"; \
	fi
	@echo "✅ Environment check passed"

# Clean build artifacts
clean:
	@echo "🧹 Cleaning build artifacts..."
	lake clean

# Setup development environment
setup:
	@echo "⚙️ Setting up development environment..."
	@echo "Make sure you have:"
	@echo "  - Lean 4 installed"
	@echo "  - libcurl development headers"
	@echo "  - A Blockfrost project ID from https://blockfrost.io"
	@echo ""
	@echo "Then run: export BLOCKFROST_PROJECT_ID=your_project_id"

# Show help
help:
	@echo "Blockfrost Lean4 SDK - Available commands:"
	@echo ""
	@echo "🔨 Build:"
	@echo "  make build     - Build the project"
	@echo "  make clean     - Clean build artifacts"
	@echo ""
	@echo "🧪 Testing:"
	@echo "  make test      - Run all tests"
	@echo "  make health    - Run health check only"
	@echo "  make network   - Run network tests only"  
	@echo "  make accounts  - Run account tests only"
	@echo ""
	@echo "🚀 Demo:"
	@echo "  make demo      - Run example usage"
	@echo "  make check     - Check environment setup"
	@echo ""
	@echo "📚 Help:"
	@echo "  make help      - Show this help"
	@echo "  make setup     - Show setup instructions"

# Quick start (check environment then run health test)
start: check health
	@echo "🎉 Quick start completed successfully!"
	@echo "Try running 'make test' to run the full test suite"