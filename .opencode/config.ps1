# INFERX Terminal PowerShell Configuration
# File: config.ps1
# Location: %USERPROFILE%\.config\opencode\config.ps1

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# Read providers from opencode.jsonc
$oc = "$env:USERPROFILE\.config\opencode\opencode.jsonc"
$provMap = @{}
$provKeys = @()
if (Test-Path $oc) {
    try {
        $cfg = Get-Content $oc -Raw -Encoding UTF8 | ConvertFrom-Json
        foreach ($pr in $cfg.provider.PSObject.Properties) {
            if ($pr.Name -eq 'default') { continue }
            foreach ($md in $pr.Value.models.PSObject.Properties) {
                $k = "$($pr.Name)/$($md.Name)"
                $provMap[$k] = @{
                    Id    = $pr.Name
                    Model = $md.Name
                    URL   = $pr.Value.options.baseURL
                    Key   = $pr.Value.options.apiKey
                    Ctx   = $md.Value.limit.context
                }
                $provKeys += $k
            }
        }
    } catch { Write-Host "Config error: $_" -ForegroundColor DarkRed }
}

# Default model
$cur = 'inferx-qwen-coder/Qwen/Qwen3-Coder-Next-FP8'
if ($provMap.ContainsKey($cur)) {
    $x = $provMap[$cur]
} else {
    $cur = $provKeys[0]
    $x = $provMap[$cur]
}

$script:I = $cur
$script:P = $x.Id
$script:M = $x.Model
$script:U = $x.URL
$script:K = $x.Key

# Banner with block-style ASCII art spelling "INFERX"
$w = $host.UI.RawUI.WindowSize.Width
if ($w -gt 0) {
    Clear-Host
    $host.UI.RawUI.WindowTitle = "INFERX - $script:M"
    
    # Terminal window controls (red, yellow, green buttons)
    Write-Host "  ●" -ForegroundColor Red -NoNewline
    Write-Host " ●" -ForegroundColor Yellow -NoNewline
    Write-Host " ●" -ForegroundColor Green -NoNewline
    Write-Host "  InferX" -ForegroundColor White
    Write-Host ""
    
    # Block-style ASCII art for INFERX using Unicode blocks
    Write-Host "  ┌────────────────────────────────────────────────────────────────────┐" -ForegroundColor Gray
    Write-Host "  │                                                                    │" -ForegroundColor Gray
    
    Write-Host "  │  ▒▒▒▒▒▒    ▒▒       ▒▒  ▒▒  ▒▒▒▒▒▒  ▒▒  ▒▒  ▒▒▒▒▒▒  ▒▒      ▒▒     │" -ForegroundColor Gray
    Write-Host "  │  ▒    ▒    ▒▒       ▒▒ ▒▒  ▒    ▒  ▒▒  ▒▒ ▒      ▒▒ ▒▒          │" -ForegroundColor Gray
    Write-Host "  │  ▒▒▒▒▒▒    ▒▒       ▒▒ ▒▒  ▒▒▒▒▒▒  ▒▒▒▒▒▒ ▒      ▒▒ ▒▒    ▒▒    │" -ForegroundColor Gray
    Write-Host "  │  ▒    ▒    ▒▒       ▒▒ ▒▒  ▒    ▒  ▒▒  ▒▒ ▒      ▒▒ ▒▒      ▒▒  │" -ForegroundColor Gray
    Write-Host "  │  ▒▒▒▒▒▒    ▒▒▒▒▒▒   ▒▒  ▒▒  ▒▒▒▒▒▒  ▒▒  ▒▒  ▒▒▒▒▒▒  ▒▒▒▒▒▒ ▒▒▒▒ │" -ForegroundColor Gray
    
    Write-Host "  │                                                                    │" -ForegroundColor Gray
    Write-Host "  └────────────────────────────────────────────────────────────────────┘" -ForegroundColor Gray
    Write-Host ""
    
    $ht = "=" * $w
    Write-Host $ht -ForegroundColor DarkGray
    Write-Host "  INFERX" -ForegroundColor Cyan
    Write-Host "  Model: $($x.Model)" -ForegroundColor Yellow
    Write-Host "  Provider: $($x.Id)" -ForegroundColor DarkGray
    Write-Host "  URL: $($x.URL)" -ForegroundColor DarkGray
    Write-Host $ht -ForegroundColor DarkGray
    Write-Host ""
    Write-Host "Commands:" -ForegroundColor Yellow
    Write-Host "  /models    - List available models"
    Write-Host "  /1 /2 /3   - Switch to that model"
    Write-Host "  /status    - Show current model"
    Write-Host "  /help      - This list"
    Write-Host ""
    Write-Host " Anything else is sent to AI API."
}

# Custom prompt - returns only the newline character
function prompt {
    return "`n"
}

# Slash command handler
function Handle-Cmd($line) {
    $f = $line -replace '^\s+|\s+$', ''
    $keys = $provKeys
    if ($f -eq '/help' -or $f -eq '/h') {
        Write-Host "`n=== InferX Commands ===" -ForegroundColor Yellow
        Write-Host "  /models    - List all models"
        Write-Host "  /1 /2 /3   - Switch models"
        Write-Host "  /status    - Show current model"
        Write-Host "  /help      - Show this help"
        Write-Host "  Any text -> Send to API`n"
        return $true
    }
    if ($f -eq '/models' -or $f -eq '/ms') {
        Write-Host "`n=== InferX Models ===" -ForegroundColor Yellow
        Write-Host ""
        for ($i = 0; $i -lt $keys.Count; $i++) {
            $kk = $keys[$i]; $pv = $provMap[$kk]
            $is = if ($pv.Id -eq $script:P -and $pv.Model -eq $script:M) { " *current" } else { "" }
            $ctxVal = $pv.Ctx
            if ($ctxVal -match 'K$') { $ctxVal = $ctxVal -replace 'K$', '' }
            if ($ctxVal -match 'M$') { $ctxVal = $ctxVal -replace 'M$', '' }
            $ctxInt = [int]$ctxVal
            $cctx = if ($ctxInt -ge 1MB) { "$([int]($ctxInt / 1MB))M" } else { "$([int]($ctxInt / 1KB))K" }
            $clr = if ($pv.Model -eq $script:M) { 'Green' } else { 'White' }
            Write-Host "  [$($i+1)] $($pv.Model)  ($cctx)   $($pv.Id)   $is" -ForegroundColor $clr
        }
        Write-Host ""
        Write-Host "Type /1 /2 /3 to switch.`n" -ForegroundColor Cyan
        return $true
    }
    if ($f -eq '/status') {
        Write-Host "`nCurrent: $($script:P)/$($script:M)" -ForegroundColor Yellow
        Write-Host "URL: $($script:U)`n" -ForegroundColor Cyan
        return $true
    }
    if ($f -match '^/(\d+)$') {
        $n = [int]$Matches[1] - 1
        if ($n -ge 0 -and $n -lt $keys.Count) {
            $kk = $keys[$n]; $pv = $provMap[$kk]
            $script:I = $kk; $script:P = $pv.Id; $script:M = $pv.Model
            $script:U = $pv.URL; $script:K = $pv.Key
            $host.UI.RawUI.WindowTitle = "INFERX - $($pv.Model)"
            Write-Host "`nSwitched to $($pv.Id)/$($pv.Model)`n" -ForegroundColor Green
            return $true
        } else {
            Write-Host "`nInvalid number.`n" -ForegroundColor DarkRed; return $true
        }
    }
    if ($f -match '^/') {
        Write-Host "`nUnknown command. /help for options.`n" -ForegroundColor DarkRed
        return $true
    }
    return $false
}

# CommandNotFoundAction - capture commands starting with /
$executionContext.SessionState.InvokeCommand.CommandNotFoundAction = {
    param($sender, $e)
    $cmd = $e.CommandName
    $txt = $MyInvocation.Line.Trim()
    
    # Handle slash commands starting with /
    if ($cmd -match '^/') {
        $h = Handle-Cmd $txt
        if ($h) { $e.StopSearch = $true; return }
    }
    
    # Skip other invalid commands
    if ($cmd -match '^\.|^\\|^[a-zA-Z]:\\|^\$|^#|^\{|^@|^"') { return }
    
    # Send to AI API
    try {
        $body = @{
            model = $script:M
            messages = @(@{role = 'user'; content = $txt})
            max_tokens = 1024; temperature = 0.7
        } | ConvertTo-Json -Compress
        $r = Invoke-RestMethod -Uri "$script:U/chat/completions" -Method Post -ContentType 'application/json' -Headers @{Authorization = "Bearer $script:K"} -Body $body -TimeoutSec 30 -ErrorAction Stop
        if ($r.choices[0].message.content) { Write-Host $r.choices[0].message.content -ForegroundColor Green }
    } catch { Write-Host ("INFERX API error: " + $_) -ForegroundColor DarkRed }
    $e.StopSearch = $true
}
