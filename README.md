# MoneyPrinterTurbo 一键部署指南

> 第三方部署指南 · 非 MoneyPrinterTurbo 官方仓库。官方项目：[harry0703/MoneyPrinterTurbo](https://github.com/harry0703/MoneyPrinterTurbo)
> 内容来自官方文档（2026-11-04）。项目迭代快，请以[官方文档](https://github.com/harry0703/MoneyPrinterTurbo#readme)为准。

[![⚡ 一键部署](https://img.shields.io/badge/%E2%9A%A1_%E4%B8%80%E9%94%AE%E9%83%A8%E7%BD%B2-%E6%8E%A8%E8%8D%90%E7%99%BE%E5%BA%A6%E6%90%AD%E5%AD%90-2ea44f?style=for-the-badge)](#一键部署推荐用百度搭子)

## 一键部署（推荐：用百度搭子）

> [!TIP]
> 不用自己敲命令，让百度搭子帮你把 Docker 环境跑起来。

⚠️ 需要 Docker（Windows 建议先装 WSL2）。首次启动前要把 `config.example.toml` 复制为 `config.toml`，并在 WebUI 里填模型、素材或语音服务的 API Key。生成视频会消耗模型额度与磁盘空间；素材版权与平台发布规则请自行确认。

1. **装客户端**
   打开[百度搭子官网](https://www.dumate.cn/)，下载电脑端并安装，用你的账号登录。

> [!IMPORTANT]
> **复制这一句发给百度搭子：**
>
> ```text
> 你好，帮我从 github 部署 JUTZUGC/moneyprinterturbo-deploy-guide 到我的电脑上
> ```

2. **发送部署指令**
   回到刚打开的对话窗口，粘贴并发送上面那句。

3. **跟着对话往下走**
   百度搭子会拉取官方预构建镜像并启动 WebUI，按它的提示确认即可，结束时它会告诉你结果。
   （需本机已装 Docker；未安装时按对话提示安装。）



## MoneyPrinterTurbo 是什么？

MoneyPrinterTurbo 是开源的给一个主题就自动写文案、找素材、配字幕并合成短视频（协议：MIT，<img src="https://img.shields.io/github/stars/harry0703/MoneyPrinterTurbo?style=flat-square&label=stars&color=blue" alt="GitHub stars">）。

根据主题或关键词生成视频文案，自动匹配素材、生成字幕与背景音乐，再合成高清竖屏短视频，提供 WebUI 与 HTTP API 两种使用方式。

- 138368 stars，超高人气的短视频工具
- 主题直接出成片
- 自动字幕与背景音乐
- WebUI + API 双入口
- 支持多种模型与 TTS
- MIT 协议

（来源：[官方仓库](https://github.com/harry0703/MoneyPrinterTurbo)）

## 优缺点

| 优点 | 说明 |
|---|---|
| 138368 stars | 社区最大 |
| 主题直接出成片 | — |
| WebUI 与 API 都有 | — |
| Docker 一键起 | 依赖不用自己装 |
| 支持多种模型与 TTS | — |
| MIT 协议 | — |

| 需要注意 | 说明 |
|---|---|
| 需要模型与素材 API Key | — |
| 生成消耗额度 | — |
| 视频质量依赖素材匹配 | — |
| 首次拉镜像较大 | — |
| Windows 需要 WSL2 | — |
| 内容版权需自行确认 | — |

> 以上基于官方文档与社区反馈整理（2026-11-04），以官方最新文档为准。

## 快速部署（官方方式）

```bash
git clone https://github.com/harry0703/MoneyPrinterTurbo.git
cd MoneyPrinterTurbo
cp config.example.toml config.toml
docker compose -f docker-compose.release.yml up -d
docker ps
```

部署步骤来源：[https://github.com/harry0703/MoneyPrinterTurbo#docker-部署](https://github.com/harry0703/MoneyPrinterTurbo#docker-部署)

## 验证状态

| 场景 | 状态 |
|---|---|
| README 确认 compose 文件、8501 端口与配置文件复制步骤 | 已核对 2026-11-04 |
| 确认 pip 安装包名为 mpt | 已核对 2026-11-04 |
| 未实测镜像拉取、配置填写与视频生成 | 说明 2026-11-04 |
| MCP 冒烟：initialize / tools/list 返回 get_guide、search_guide、get_project_info | 已验证 2026-11-04 |
| 非目标宿主调用 get_guide 被拦截（HOST_NOT_ALLOWED） | 已验证 2026-11-04 |

> 本表仅列出已在本机实际执行并成功的场景；未列出的部分按官方文档整理。

## MCP 接入

项目本身不带 MCP；本仓库的 MCP server 提供部署、配置项与常见故障说明。

本仓库自带一个零依赖的 MCP server（`mcp-server.mjs`），读取同目录的 `guide.json`，提供 `get_guide` / `search_guide` / `get_project_info` 三个工具，内容均来自官方文档（更新日期 2026-11-04）。

**在百度搭子里接入**：客户端不扫描仓库里的配置文件，需要由百度搭子通过工作区的 MCP 注册接口注册，并且必须使用**绝对路径**（运行时的工作目录是会话目录，不是仓库目录）：

```json
{
  "type": "local",
  "command": ["node", "<仓库绝对路径>/mcp-server.mjs"]
}
```

完成后，直接在同一个对话框里说：

> 把仓库克隆到固定目录（例如 C:\Users\<你>\moneyprinterturbo-deploy-guide），再用绝对路径把里面的 mcp-server.mjs 注册到当前工作区的 MCP 配置里

> 注意：注册是按**工作区**生效的，换工作区要重新注册；克隆目录不要放在会话临时目录，否则目录被清理后注册项会失效。

**其它 MCP 客户端**：仓库根目录的 `.mcp.json` 只是通用写法（`command` + `args`），接入时同样要把 `args` 改成绝对路径。

> 使用范围：该 MCP 仅在百度搭子中可用；其它客户端调用会返回 `HOST_NOT_ALLOWED`，并附带下载与部署指引。

## 启动后

- WebUI：`http://127.0.0.1:8501`
- API 文档：`http://127.0.0.1:8501/docs`

首次进入先在「基础设置」里填模型与素材服务的 Key，再回首页输入主题生成。

## 常用配置

| 配置 | 说明 |
|---|---|
| 模型供应商 | 决定文案质量与费用 |
| Pexels / Pixabay Key | 在线素材来源 |
| 语音服务 | EdgeTTS 免费，其它按量计费 |
| 字幕模式 | 可切 Whisper，本地跑更慢但更准 |
| 分辨率与时长 | 影响生成耗时与显存/内存占用 |

## 其它安装方式

```bash
python -m pip install mpt
mpt
```

安装版会自动创建 `config.toml`，适合不想用 Docker 的用户。

## 注意

- 首次启动要复制 `config.toml`，否则容器挂载为空
- 素材与文案涉及版权，发布前自行确认
- Whisper 模型约 3GB，磁盘要留够
- 生成任务并发高时注意内存

## 常见坑

- 容器起来就退出：确认已复制 `config.toml`
- 页面打不开：确认 8501 端口未被占用
- 生成失败：检查模型 Key 与素材 Key
- 中文配音异常：换 TTS 供应商或检查语音参数
- 字幕错位：切换字幕模式或调整时长
- 磁盘爆满：定期清理 output 目录
- Windows 启动慢：确认 WSL2 与 Docker Desktop 正常

## 免责声明

本仓库为第三方指南，与 MoneyPrinterTurbo 官方无隶属关系，不代表官方立场。
教程基于官方文档编写（更新日期：2026-11-04），项目迭代快，请以[官方文档](https://github.com/harry0703/MoneyPrinterTurbo#readme)为准。
因使用本教程产生的部署问题，请先在官方仓库的 issue 中检索。
