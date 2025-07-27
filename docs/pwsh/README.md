# PWSH

## z

`z` 是一个 **智能目录跳转工具**，可以学习你的常用目录习惯，通过模糊匹配快速跳转，大幅减少 `cd` 命令的输入时间。它特别适合经常在多个深层次目录间切换的场景（比如开发项目）。

### **常用指令**

| 指令         | 作用                               | 示例                                     |
| :----------- | :--------------------------------- | :--------------------------------------- |
| `z <关键词>` | 跳转到匹配的目录                   | `z doc` → 跳转到 `C:\Users\me\Documents` |
| `z -l`       | 列出所有记录过的目录（按权重排序） | `z -l`                                   |
| `z -x`       | 从数据库中删除当前目录             | `z -x`                                   |
| `z -t`       | 仅按最近访问时间匹配（忽略频率）   | `z -t proj`                              |
| `z -r`       | 按匹配路径的层级深度排序           | `z -r git`                               |

### **安装与配置**

1. **安装**（PowerShell）：

   ```powershell
   Install-Module -Name z -AllowClobber -Force
   ```

2. **自动加载**（添加到 `$PROFILE`）：

   ```powershell
   Import-Module z
   ```

---

## THEME

```powershell
# Install Oh-my-Posh
Get-Module -Name oh-my-posh -ListAvailable
Install-Module oh-my-posh -Scope CurrentUser -Force

# 查看可用主题
Get-PoshTheme

# 初始化并设置主题（临时生效）
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\bubbles.omp.json" | Invoke-Expression


```

