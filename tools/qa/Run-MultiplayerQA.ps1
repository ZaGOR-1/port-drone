param(
    [ValidateSet('Gui', 'Smoke')][string]$Mode = 'Gui',
    [ValidateSet('LAN', 'Steam')][string]$Transport = 'LAN',
    [ValidatePattern('^[A-Za-z0-9_-]+$')][string]$Peer = 'peer1',
    [ValidateRange(0, 36000)][int]$QuitAfter = 0
)
$ErrorActionPreference = 'Stop'
$buildRoot = $PSScriptRoot
$stateRoot = Join-Path (Join-Path $buildRoot 'mpqa-user') $Peer
$logRoot = Join-Path (Join-Path $buildRoot 'mpqa-logs') $Peer
$env:APPDATA = Join-Path $stateRoot 'Roaming'
$env:LOCALAPPDATA = Join-Path $stateRoot 'Local'
$env:DF_NO_UPDATE = '1'
$env:DF_NO_OPENING = '1'
$env:DF_LANG = 'uk'
# Real Steam initialization is enabled only by the user's explicit -Transport Steam run.
if ($Transport -eq 'Steam') {
    Remove-Item Env:DF_STEAM_MOCK -ErrorAction SilentlyContinue
} else {
    $env:DF_STEAM_MOCK = '0'
}
New-Item -ItemType Directory -Force -Path $env:APPDATA, $env:LOCALAPPDATA, $logRoot | Out-Null
$exe = Join-Path $buildRoot 'DroneFlames.exe'
$gameArgs = @('--log-file', ('"' + (Join-Path $logRoot ($Mode.ToLower() + '-engine.log')) + '"'))
if ($Mode -eq 'Smoke') {
    $gameArgs += @('--headless', '--quit-after', '240', '--', '--lang=uk')
} elseif ($QuitAfter -gt 0) {
    $gameArgs += @('--quit-after', [string]$QuitAfter)
}
Write-Host "Mode=$Mode; isolated APPDATA=$env:APPDATA; Transport=$Transport; peer=$Peer; updater disabled"
$info = New-Object System.Diagnostics.ProcessStartInfo
$info.FileName = $exe
$info.Arguments = $gameArgs -join ' '
$info.WorkingDirectory = $buildRoot
$info.UseShellExecute = $false
$info.RedirectStandardOutput = $true
$info.RedirectStandardError = $true
$info.CreateNoWindow = $true
$process = New-Object System.Diagnostics.Process
$process.StartInfo = $info
$null = $process.Start()
$stdoutTask = $process.StandardOutput.ReadToEndAsync()
$stderrTask = $process.StandardError.ReadToEndAsync()
$timer = [Diagnostics.Stopwatch]::StartNew()
$loadedModules = @{}
$timedOut = $false
while (-not $process.WaitForExit(1000)) {
    try {
        foreach ($module in $process.Modules) {
            if ($module.ModuleName -match 'godotsteam|webrtc_native|steam_api64') {
                $loadedModules[$module.ModuleName] = $module.FileName
            }
        }
    } catch { }
    if ($Mode -ne 'Gui' -and $timer.Elapsed.TotalSeconds -gt 120) {
        $process.Kill()
        $timedOut = $true
        break
    }
}
$process.WaitForExit()
$stdoutText = $stdoutTask.GetAwaiter().GetResult()
$stderrText = $stderrTask.GetAwaiter().GetResult()
[IO.File]::WriteAllText((Join-Path $logRoot ($Mode.ToLower() + '-stdout.log')), $stdoutText)
[IO.File]::WriteAllText((Join-Path $logRoot ($Mode.ToLower() + '-stderr.log')), $stderrText)
$exitCode = $process.ExitCode
if ($null -eq $exitCode) { throw 'Unable to obtain child exit code' }
$result = [ordered]@{
    mode = $Mode; exit_code = $exitCode; timed_out = $timedOut
    elapsed_seconds = [Math]::Round($timer.Elapsed.TotalSeconds, 3)
    executable = $exe; arguments = $info.Arguments
    appdata = $env:APPDATA; localappdata = $env:LOCALAPPDATA
    expected_user_data = (Join-Path $env:APPDATA 'Godot\app_userdata\DroneFlames')
    user_data_exists = (Test-Path (Join-Path $env:APPDATA 'Godot\app_userdata\DroneFlames'))
    loaded_native_modules = $loadedModules
    updater_disabled = $true; transport_requested = $Transport; peer_label = $Peer
    exe_sha256 = (Get-FileHash -Algorithm SHA256 $exe).Hash.ToLowerInvariant()
    steam_initialization = $(if ($Transport -eq 'Steam') { 'enabled by explicit manual option; test result must be recorded separately' } else { 'bypassed; LAN/ENet only' })
}
[IO.File]::WriteAllText((Join-Path $logRoot ($Mode.ToLower() + '-result.json')), ($result | ConvertTo-Json -Depth 6))
Write-Host "Exit code: $exitCode; elapsed: $($result.elapsed_seconds)s"
if ($timedOut) { exit 124 }
exit $exitCode
