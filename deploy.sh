#!/usr/bin/env bash
set -euo pipefail
# MoneyPrinterTurbo 一键部署脚本（第三方指南）——按官方文档封装
# 官方文档：https://github.com/harry0703/MoneyPrinterTurbo#readme
# 更新日期：2026-11-04
# 类型：docker
cd "$(dirname "${BASH_SOURCE[0]}")"

command -v git >/dev/null 2>&1 || { echo "需要先安装 Git"; exit 1; }
command -v docker >/dev/null 2>&1 || { echo "需要先安装 Docker"; exit 1; }
docker compose version >/dev/null 2>&1 || { echo "需要 Docker Compose v2（docker compose 子命令）"; exit 1; }

mkdir -p .download
cd .download

git clone https://github.com/harry0703/MoneyPrinterTurbo.git
cd MoneyPrinterTurbo
cp config.example.toml config.toml
docker compose -f docker-compose.release.yml up -d
docker ps

echo ""

echo "部署完成"
echo "若结果异常或需要改配置，请参考官方文档：https://github.com/harry0703/MoneyPrinterTurbo#readme"
