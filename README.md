  __      __   _ __    ___
 / _ \    / _| | '_ \  / __|
| |_| |  | (_ | | | | | (__ 
 \__\_\   \__| |_| |_|  \___|
                        
INFERX - Windows Terminal Configuration

This repository contains the PowerShell configuration for the InferX terminal experience.

## Features

- Custom terminal prompt with INFERX branding
- Model switching with /1, /2, /3 commands
- Context limit display (K/M)
- ASCII art banner

## Installation

1. Copy this file to: `%USERPROFILE%\.config\opencode\config.ps1`

2. Restart PowerShell or reload the module

## Usage

Type `INFERX` in your terminal to start the custom experience.

Available commands:
- `/models` - List all available models
- `/1`, `/2`, `/3` - Switch to that model
- `/status` - Show current model
- `/help` - Show this help message

## License

MIT
