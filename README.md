### InferX Windows Terminal Config

This repository contains the PowerShell configuration for the InferX terminal experience.

## Features

- Custom terminal prompt with INFERX branding
- Model switching with /1, /2, /3 commands
- Context limit display (K/M)
- ASCII art banner
- AI API integration

## Installation

1. Copy `config.ps1` to: `%USERPROFILE%\.config\opencode\config.ps1`

2. Restart PowerShell or reload the module

## Usage

Type `INFERX` in your terminal to start the custom experience.

### Available Commands

- `/models` - List all available models
- `/1`, `/2`, `/3` - Switch to that model
- `/status` - Show current model
- `/help` - Show this help message

### Example Output

```
   __      __   _ __    ___
  / _ \    / _| | '_ \  / __|
 | |_| |  | (_ | | | | | (__ 
  \__\_\   \__| |_| |_|  \___|
                        
INFERX Model: Qwen/Qwen3-Coder-Next-FP8
Provider: inferx-qwen-coder

Commands:
  /models    - List available models
  /1 /2 /3   - Switch to that model
  /status    - Show current model
  /help      - This list

INFERX > /models

=== InferX Models ===
  [1] Qwen/Qwen3.6-35B-A3B-FP8  (1000K)   inferx
  [2] Qwen/Qwen3-Coder-Next-FP8  (250K)   inferx-qwen-coder    *current
  [3] google/gemma-4-31B-it  (256K)   inferx-gemma

Type /1 /2 /3 to switch.
```

## Configuration

The config reads from `~\.config\opencode\opencode.jsonc` for provider settings.

## License

MIT

## Author

Created for the InferX AI terminal experience
