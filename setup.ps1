# claw-code Windows Setup Script
# Run this in PowerShell to prepare your environment

Write-Host "--- Claw Code Windows Setup ---" -ForegroundColor Cyan

# 1. Check for Rust
if (Get-Command "rustc" -ErrorAction SilentlyContinue) {
    $version = rustc --version
    Write-Host "✅ Rust is installed: $version" -ForegroundColor Green
} else {
    Write-Host "❌ Rust not found. Please install it from https://rustup.rs/" -ForegroundColor Red
    exit 1
}

# 2. Install just (Task Runner)
if (Get-Command "just" -ErrorAction SilentlyContinue) {
    Write-Host "✅ 'just' is already installed." -ForegroundColor Green
} else {
    Write-Host "📡 Installing 'just' task runner..." -ForegroundColor Yellow
    cargo install just
}

# 3. Initialize Config Directory
$clawDir = Join-Path $HOME ".claw"
if (-not (Test-Path $clawDir)) {
    Write-Host "📁 Creating config directory at $clawDir" -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $clawDir
} else {
    Write-Host "✅ Config directory exists at $clawDir" -ForegroundColor Green
}

# 4. Environment Template
$envTemplate = "rust\.env.template"
$envFile = "rust\.env"
if (Test-Path $envTemplate) {
    if (-not (Test-Path $envFile)) {
        Write-Host "📄 Copying .env.template to .env..." -ForegroundColor Yellow
        Copy-Item $envTemplate $envFile
        Write-Host "💡 Don't forget to fill in your API keys in rust/.env!" -ForegroundColor Cyan
    } else {
        Write-Host "✅ rust/.env already exists." -ForegroundColor Green
    }
}

Write-Host "`n✨ Setup complete! You can now run 'just build' in the rust directory." -ForegroundColor Cyan
