  __      __   _ __    ___
 / _ \    / _| | '_ \  / __|
| |_| |  | (_ | | | | | (__ 
 \__\_\   \__| |_| |_|  \___|
                        
INFERX - Windows Terminal Config

This repository contains the PowerShell configuration for the InferX terminal experience.

## Features

- Custom terminal prompt with INFERX branding
- Model switching with /1, /2, /3 commands  
- Context limit display (K/M)
- ASCII art banner in terminal
- AI API integration

## Installation

1. Copy `config.ps1` to: `%USERPROFILE%\.config\opencode\config.ps1`
2. Restart PowerShell or run `INFERX` command

## Usage

Type `INFERX` in your terminal to start the custom experience.

### Available Commands

- `/models` - List all available models
- `/1`, `/2`, `/3` - Switch to that model
- `/status` - Show current model
- `/help` - Show this help message

## Configuration

The config reads from `~\.config\opencode\opencode.jsonc` for provider settings.

## License

MIT

## Author

Created for the InferX AI terminal experience
