# ============================================================================
# 【1. 终端初始化】
# ============================================================================

# Oh My Posh 主题初始化
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\negligible.omp.json" | Invoke-Expression

# 别名设置
Set-Alias -Name vi -Value nvim -Force

# ============================================================================
# 【2. 防屏保功能】独立进程,关闭终端后依然有效
# ============================================================================

$Global:KeepAliveProcessName = "KeepAlive_F15"

function Start-KeepAlive {
    <#
    .SYNOPSIS
        启动防屏保功能(独立进程)
    .PARAMETER Interval
        触发间隔(秒),默认50秒
    .EXAMPLE
        Start-KeepAlive
        Start-KeepAlive -Interval 60
    #>
    param([int]$Interval = 50)
    
    # 检查是否已经在运行
    $existingProcess = Get-Process -Name "pwsh" -ErrorAction SilentlyContinue | 
        Where-Object { $_.MainWindowTitle -like "*$Global:KeepAliveProcessName*" }
    
    if ($existingProcess) {
        Write-Host "⚠️  防屏保已在运行中(PID: $($existingProcess.Id)),使用 Stop-KeepAlive 停止" -ForegroundColor Yellow
        return
    }
    
    # 创建独立的 PowerShell 脚本
    $scriptContent = @"
Add-Type -AssemblyName System.Windows.Forms
`$host.UI.RawUI.WindowTitle = '$Global:KeepAliveProcessName'

while (`$true) {
    [System.Windows.Forms.SendKeys]::SendWait('{F15}')
    Start-Sleep -Seconds $Interval
}
"@
    
    # 保存到临时文件 (位置: $env:TEMP\keepalive_temp.ps1)
    $tempScript = [System.IO.Path]::Combine($env:TEMP, "keepalive_temp.ps1")
    $scriptContent | Out-File -FilePath $tempScript -Encoding UTF8 -Force
    
    # 启动独立的隐藏窗口进程
    Start-Process pwsh -ArgumentList "-WindowStyle Hidden", "-NoProfile", "-ExecutionPolicy Bypass", "-File `"$tempScript`"" -WindowStyle Hidden
    
    Start-Sleep -Milliseconds 500
    Write-Host "✅ 防屏保已启动(独立进程,每 $Interval 秒),使用 Stop-KeepAlive 停止" -ForegroundColor Green
    Write-Host "   ℹ️  关闭终端后依然有效" -ForegroundColor Cyan
}

function Stop-KeepAlive {
    <#
    .SYNOPSIS
        停止防屏保功能
    #>
    $process = Get-Process -Name "pwsh" -ErrorAction SilentlyContinue | 
        Where-Object { $_.MainWindowTitle -like "*$Global:KeepAliveProcessName*" }
    
    if (-not $process) {
        Write-Host "ℹ️  防屏保未运行" -ForegroundColor Cyan
        return
    }
    
    $process | Stop-Process -Force
    
    # 清理临时文件
    $tempScript = [System.IO.Path]::Combine($env:TEMP, "keepalive_temp.ps1")
    if (Test-Path $tempScript) {
        Remove-Item $tempScript -Force -ErrorAction SilentlyContinue
    }
    
    Write-Host "🛑 防屏保已停止" -ForegroundColor Red
}

function Get-KeepAliveStatus {
    <#
    .SYNOPSIS
        查看防屏保运行状态
    #>
    $process = Get-Process -Name "pwsh" -ErrorAction SilentlyContinue | 
        Where-Object { $_.MainWindowTitle -like "*$Global:KeepAliveProcessName*" }
    
    if (-not $process) {
        Write-Host "状态: ⭕ 未运行" -ForegroundColor Gray
    }
    else {
        Write-Host "状态: ✅ 运行中 (PID: $($process.Id))" -ForegroundColor Green
        Write-Host "       💾 内存占用: $([math]::Round($process.WorkingSet64/1MB, 2)) MB" -ForegroundColor Cyan
    }
}

# ============================================================================
# 【3. 项目快速启动】
# ============================================================================
function scom {
    <#
    .SYNOPSIS
        启动 SCOM 项目
    #>
    Clear-Host
    Set-Location "D:\#GIT\SCOM"
    python "window.py"
}

function qcom {
    <#
    .SYNOPSIS
        启动 QCOM ATC 上传工具
    #>
    Set-Location "C:\Users\fishley.gong\OneDrive\桌面\TOOL\QCOM\ATC"
    python "uploadATC"
}

function mbedtls {
    <#
    .SYNOPSIS
        启动 mbedtls 服务器
    .PARAMETER port
        服务器端口号
    .EXAMPLE
        mbedtls 8443
    #>
    param($port)
    Set-Location "D:\#iFIshin\mbedtls\mbedtls_server"
    if ($port) {
        .\ssl_server2.exe server_port=$port debug_level=1 server_addr=192.168.50.2 buffer_size=1024
    }
}

# ============================================================================
# 【4. 快速导航】
# ============================================================================

function home { Set-Location ~ }
function docs { Set-Location ~\Documents }
function down { Set-Location ~\Downloads }
function desktop { Set-Location ~\Desktop }

# ============================================================================
# 【5. 系统管理】
# ============================================================================

function restart { 
    <#
    .SYNOPSIS
        重启计算机
    #>
    shutdown /r /t 0 
}

function shutdown { 
    <#
    .SYNOPSIS
        关闭计算机
    #>
    shutdown /s /t 0 
}

function lock { 
    <#
    .SYNOPSIS
        锁定计算机
    #>
    rundll32.exe user32.dll,LockWorkStation 
}

function sysinfo {
    <#
    .SYNOPSIS
        显示系统信息
    #>
    Get-ComputerInfo | Select-Object WindowsProductName, WindowsVersion, OsHardwareAbstractionLayer, 
    TotalPhysicalMemory, CsProcessors
}

# ============================================================================
# 【6. 网络工具】
# ============================================================================

function myip { 
    <#
    .SYNOPSIS
        获取公网IP地址
    #>
    (Invoke-RestMethod http://ipinfo.io/json).ip 
}

function flushdns { 
    <#
    .SYNOPSIS
        清除DNS缓存
    #>
    Clear-DnsClientCache 
}

# ============================================================================
# 【7. 进程管理】
# ============================================================================

function killname {
    <#
    .SYNOPSIS
        根据进程名终止进程
    .PARAMETER name
        进程名称
    .EXAMPLE
        killname chrome
    #>
    param($name)
    Get-Process $name -ErrorAction SilentlyContinue | Stop-Process
}

function findproc {
    <#
    .SYNOPSIS
        查找进程
    .PARAMETER name
        进程名称(支持模糊搜索)
    .EXAMPLE
        findproc chrome
    #>
    param($name)
    Get-Process *$name*
}

# ============================================================================
# 【8. 文件操作】
# ============================================================================

function edit {
    <#
    .SYNOPSIS
        用记事本编辑文件
    .PARAMETER file
        文件路径
    #>
    param($file)
    notepad $file
}

function explore { 
    <#
    .SYNOPSIS
        在资源管理器中打开当前目录
    #>
    explorer . 
}

function mkcd {
    <#
    .SYNOPSIS
        创建目录并进入
    .PARAMETER dir
        目录名称
    .EXAMPLE
        mkcd testdir
    #>
    param($dir)
    New-Item $dir -ItemType Directory -Force
    Set-Location $dir
}

# ============================================================================
# 【9. Git 快捷方式】
# ============================================================================

function gs { git status }
function ga { git add . }
function gc { 
    <#
    .SYNOPSIS
        Git 提交
    .EXAMPLE
        gc "commit message"
    #>
    git commit -m $args 
}
function gp { git push }
function gl { git log --oneline -10 }

# ============================================================================
# 【10. 工具函数】
# ============================================================================

function Get-Bytes {
    <#
    .SYNOPSIS
        生成指定长度的数字字符串
    .PARAMETER length
        字符串长度
    .EXAMPLE
        Get-Bytes 100
    #>
    param($length)
    $result = ""
    for ($i = 0; $i -lt $length; $i++) {
        $result += [string]($i % 10)
    }
    return $result
}

function Repeat-String {
    <#
    .SYNOPSIS
        重复字符串指定次数
    .PARAMETER str
        要重复的字符串
    .PARAMETER count
        重复次数
    #>
    param($str, $count)
    $result = ""
    for ($i = 0; $i -lt $count; $i++) {
        $result += $str
    }
    return $result
}

# ============================================================================
# 【11. 启动信息显示】
# ============================================================================

# 获取网络IP地址
$wlan_ip = (Get-NetIPAddress | Where-Object { $_.InterfaceAlias -like "*以太网*" }).IPAddress

# 显示欢迎框架
$line = Repeat-String "─" 66
Write-Host "┌$line┐"
$line = Repeat-String " " 66
Write-Host "│$line│"

# 输出 IP 地址
Write-Host "WLAN IP".PadRight(66)"│"
for ($i = 1; $i -lt $wlan_ip.Count; $i++) {
    Write-Host "│        $($wlan_ip[$i].PadRight(58))│"
}

# 输出框架结束
$line = Repeat-String " " 66
Write-Host "│$line│"
$line = Repeat-String "─" 66
Write-Host "└$line┘"

# ============================================================================
# 配置文件加载完成
# ============================================================================
