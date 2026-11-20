param(
    [ValidateSet('Gui', 'Smoke')][string]$Mode = 'Gui',
    [ValidateRange(0, 36000)][int]$QuitAfter = 0
)
$ErrorActionPreference = 'Stop'
$buildRoot = $PSScriptRoot
$stateRoot = Join-Path $buildRoot 'test-user'
$logRoot = Join-Path $buildRoot 'test-logs'
$env:APPDATA = Join-Path $stateRoot 'Roaming'
$env:LOCALAPPDATA = Join-Path $stateRoot 'Local'
$env:DF_NO_UPDATE = '1'
$env:DF_NO_OPENING = '1'
$env:DF_LANG = 'uk'
# Invalid mock ID returns before filesystem/UDP/real Steam initialization. SP baseline only.
$env:DF_STEAM_MOCK = '0'
New-Item -ItemType Directory -Force -Path $env:APPDATA, $env:LOCALAPPDATA, $logRoot | Out-Null
$exe = Join-Path $buildRoot 'DroneFlames.exe'
$gameArgs = @('--log-file', ('"' + (Join-Path $logRoot ($Mode.ToLower() + '-engine.log')) + '"'))
if ($Mode -eq 'Smoke') {
    $gameArgs += @('--headless', '--quit-after', '240', '--', '--lang=uk')
} elseif ($QuitAfter -gt 0) {
    $gameArgs += @('--quit-after', [string]$QuitAfter)
}
Write-Host "Mode=$Mode; isolated APPDATA=$env:APPDATA; Steam initialization bypassed; updater disabled"
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
    updater_disabled = $true; steam_initialization = 'bypassed; no real Steam test'
}
[IO.File]::WriteAllText((Join-Path $logRoot ($Mode.ToLower() + '-result.json')), ($result | ConvertTo-Json -Depth 6))
Write-Host "Exit code: $exitCode; elapsed: $($result.elapsed_seconds)s"
if ($timedOut) { exit 124 }
exit $exitCode
