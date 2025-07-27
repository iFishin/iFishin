oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\negligible.omp.json" | Invoke-Expression
new-alias -name vi -value nvim
# Clear-Host
# get-content ~/.iFishing.temp3

function scom(){
    cls
    cd "C:\Users\fishley.gong\SCOM"
    python "window.py"
}

function AutoCom {
    param (
        [Parameter(Mandatory=$true)][string]$Dict,
        [Parameter(Mandatory=$true)][int]$Times
    )
    Set-Location -Path "$env:USERPROFILE\AutoCom"
    python "AutoCom.py" -d "$Dict" -l $Times
}

function qcom() {
    cd "C:\Users\fishley.gong\OneDrive\桌面\TOOL\QCOM\ATC"
    python "uploadATC"
}

function Get-Bytes($length) {
    $chars = "0123456789"
    $result = ""
    for ($i = 0; $i -lt $length; $i++) {
        $result += [string]($i % 10)
    }
    return $result
}

function mbedtls($port) {
    cd "D:\#iFIshin\mbedtls\mbedtls_server"
    if ($port) {
        .\ssl_server2.exe server_port=$port debug_level=1 server_addr=192.168.50.2 buffer_size=1024  
    }
}

# 获取 WLAN IP 地址并输出
$wlan_ip = (Get-NetIPAddress | Where-Object { $_.InterfaceAlias -like "*以太网*" }).IPAddress

#systeminfo > ~/sysinfo.txt

# 从文件中获取系统信息并输出，加入框架
#$sysinfo = "~/sysinfo.txt"
$search_str = "主机名", "系统型号"

# 定义固定的字符串长度
$fixed_length = 5

# 对每个字符串执行填充操作，这里填充的是全角空格
$search_str_padded = foreach ($str in $search_str) {
    $str.PadRight($fixed_length, "　").Substring(0, $fixed_length)
}

function Repeat-String ($str, $count) {
    # 使用 for 循环和字符串拼接来重复输出字符串
    $result = ""
    for ($i = 0; $i -lt $count; $i++) {
        $result += $str
    }
    return $result
}

# 输出框架开始
$line = Repeat-String "─" 66
Write-Host "┌$line┐"
$line = Repeat-String " " 66
Write-Host "│$line│"

# 输出 WLAN IP 地址
Write-Host "WLAN IP".PadRight(66)"│"
for ($i = 1; $i -lt $wlan_ip.Count; $i++) {
    Write-Host "│        $($wlan_ip[$i].PadRight(58))│"
}

# # 输出系统信息
# foreach ($line in (Get-Content $sysinfo)) {
#     $match = $false
#     foreach ($str in $search_str) {
#         if ($line -match $str) {
#             # 匹配到关键词，输出带有关键词的内容
#             $output = "       " + "$($line.Split(":")[1].Trim().PadRight(50))"
#             $index = [array]::IndexOf($search_str, $str)
#             Write-Host $search_str_padded[$index].PadRight(53)"│"
#             Write-Host "│ $output│"
#             $match = $true
#             break
#         }
#     }
# }


# 输出框架结束
$line = Repeat-String " " 66
Write-Host "│$line│"
$line = Repeat-String "─" 66
Write-Host "└$line┘"