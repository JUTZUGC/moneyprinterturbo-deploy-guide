# MoneyPrinterTurbo 一键部署脚本（第三方指南）——按官方文档封装
# 官方文档：https://github.com/harry0703/MoneyPrinterTurbo#readme
# 更新日期：2026-11-04
# 类型：docker
$ErrorActionPreference = 'Stop'
Set-Location -Path $PSScriptRoot

foreach ($cmd in @('git', 'docker')) {
  if (-not (Get-Command $cmd -ErrorAction SilentlyContinue)) { throw "需要先安装 $cmd" }
}
docker compose version | Out-Null
if ($LASTEXITCODE -ne 0) { throw '需要 Docker Compose v2（docker compose 子命令）' }

New-Item -ItemType Directory -Force -Path .download | Out-Null
Set-Location -Path .download

git clone https://github.com/harry0703/MoneyPrinterTurbo.git
Set-Location MoneyPrinterTurbo
Copy-Item config.example.toml config.toml
docker compose -f docker-compose.release.yml up -d
docker ps

Write-Host ''

Write-Host '部署完成'
Write-Host '若结果异常或需要改配置，请参考官方文档：https://github.com/harry0703/MoneyPrinterTurbo#readme'
