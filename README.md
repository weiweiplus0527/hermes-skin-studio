# 皮肤工坊（Skin Studio）— 给 Hermes Desktop 换装

**Hermes Desktop 主题编辑器插件：壁纸/动态视频背景、扩展调色板、文字加粗、聊天字体大小、Markdown 强调色、汉字雨动画背景。**

- ✅ 无需构建、不改应用代码——一个 ESM 文件 + 可选 Python 后端
- ✅ **一键应用**：通过 Hermes 原生皮肤机制（`/skin` 同款热路径）
- ✅ **实时编辑**：改动即刻重绘当前主题
- ✅ **15 款预设主题**：6 款中国风 + 4 款动漫风 + 5 款经典款

> 本插件复刻自开源项目 [Theme Forge](https://github.com/NousResearch/hermes-example-plugins/pull/8)（MIT 协议），
> 深度改造：全中文界面、新增中国风/动漫风主题、汉字雨特效。

## 内置主题

### 中国风系列

| 主题 | 视觉 | 特效 |
|------|------|------|
| **水墨** | 宣纸白 + 墨色 + 朱砂印章红 | — |
| **青花瓷** | 釉白 + 钴蓝，东方典雅 | — |
| **故宫** | 宫墙红 + 琉璃金，皇家气派 | — |
| **竹林** | 竹青 + 墨绿，清雅空灵 | — |
| **敦煌** | 沙金 + 壁画赭石，丝路色彩 | — |
| **汉字雨** | 墨黑宣纸 + 印章红 | 🌧️ **汉字从天而降**（中国版数字雨） |

### 动漫风系列

| 主题 | 视觉 | 特效 |
|------|------|------|
| **EVA 初号机** | 初号机紫 + 荧光绿 | — |
| **高达** | RX-78 白蓝红三色 | — |
| **初音未来** | 初音青绿 | — |
| **鬼灭之刃** | 炭治郎黑绿格纹 + 日轮刀红 | — |

### 经典款（继承自 Theme Forge）

| 主题 | 视觉 | 特效 |
|------|------|------|
| **赛博** | 纯黑 + 荧光绿 + 紫 + 金 | — |
| **玻璃** | 冷调半透明中性色 + 青色 | — |
| **纸感** | 暖调纸感浅色 + 陶土色 | — |
| **数字雨** | 纯黑 + 磷光绿 | 🌧️ 片假名数字雨 |
| **黑客** | 荧光绿终端 + 紫 + 金 | 📺 CRT 扫描线 |
| **自定义** | 可编辑主题（持久保存） | 全部可调 |

## 它能做什么原生做不到的事

| 功能 | 为什么原生没有 |
|------|----------------|
| **图片/视频壁纸** + 遮罩 + 模糊 | `DesktopTheme` 模型只有纯色 |
| **扩展调色板**（`--ui-red/green/blue/…`） | 这些颜色固定在应用 `styles.css` 里 |
| **文字加粗**（3 级） | 主题模型没有字重控制 |
| **聊天字体大小**（11–18px） | token 存在但无 UI |
| **强调色**（标题/链接/代码） | 不可配置 |
| **汉字雨 / 数字雨 / CRT 扫描线** | 主题模型无法表达动画 |
| **一键应用主题** | 桌面端未向插件暴露 `setTheme` |

## 安装

### 一键安装（推荐）

```bash
git clone https://github.com/naiyou-dotcom/hermes-skin-studio.git
cd hermes-skin-studio
./install.sh
```

脚本自动完成：前端 → `~/.hermes/desktop-plugins/`、后端 → `~/.hermes/plugins/`、
启用配置 → `plugins.enabled`。之后**重启 Hermes Desktop**（Cmd+Q 再打开），
⌘K → Reload desktop plugins 即可。

### 手动安装

#### 1. 桌面插件（必需）

```bash
mkdir -p ~/.hermes/desktop-plugins
cp -R skin-studio ~/.hermes/desktop-plugins/
```

（命名 profile：`~/.hermes/profiles/<名称>/desktop-plugins/`）

#### 2. Python 后端（推荐——启用「应用」按钮）

```bash
mkdir -p ~/.hermes/plugins
cp -R skin-studio ~/.hermes/plugins/       # 使用 dashboard/manifest.json + plugin_api.py
```

启用插件（`plugins.enabled` 必须是 **YAML 数组**格式，编辑 `~/.hermes/config.yaml`）：

```yaml
plugins:
  enabled:
    - skin-studio
```

然后重启 gateway（`hermes gateway restart` 或重启 Hermes Desktop）。

> 后端挂载 `POST /api/plugins/skin-studio/activate`——把主题写成真正的 Hermes 皮肤
> （`~/.hermes/skins/<名称>.yaml`）并在约 1 秒内激活到**所有界面**（CLI、TUI、桌面）。
> 不装后端也能用：⌘K → 主题 手动激活（皮肤工坊的主题会出现在主题网格里）。

### 3. 在应用里激活

Hermes Desktop：**⌘K → Reload desktop plugins**。侧边栏出现 **皮肤工坊** 入口（在
Capabilities/Messaging/Artifacts 旁边），编辑器面板在右侧栏。

## 使用

1. **应用主题**：面板里选主题 → 点「应用」；或在 **⌘K → 主题** 里选（原生网格）。
2. **一键配色**（不用手动调色）：
   - **🎨 从图片自动配色**：背景页放入图片后，点「从图片自动配色」——自动提取图片
     主色板（中位切分算法），生成整套主题（背景/文字/强调色/扩展色板）
   - **📦 配色模板**：颜色页顶部 10 套预设（莫兰迪/马卡龙/赛博霓虹/暗夜森林/深海/
     落日/薄荷/玫瑰金/黑白极简/复古胶片），点一下整套套用
3. **手动编辑**（可选）：三个标签页——
   - **颜色**：核心色 + 扩展调色板 + 侧边栏逐元素颜色
   - **背景**：图片或动态视频（本地选择或粘贴 URL）、遮罩 0–90%、模糊 0–12px
   - **文字**：字体、字号、加粗等级、标题/链接/代码强调色
4. **持久化**：全部自动保存；「自定义」跨会话保留。主题在 Hermes 更新后依然存活：
   启动时插件会重写 `display.skin`，触发 gateway watcher 重新广播 `skin.changed`。

## 架构

- `plugin.js` — 注册 15 款主题（`THEMES_AREA`）、编辑器面板与页面
  （`ROUTES_AREA` + `SIDEBAR_NAV_AREA`）、⌘K 命令（`PALETTE_AREA`）；
  **CSS 注入引擎**：`MutationObserver` 监听 `<html>` 的 `data-hermes-theme`，注入
  `<style>` 应用扩展色/加粗/字号；壁纸（图片**或** `<video autoplay muted loop>`）
  是 `position:fixed; z-index:-1` 容器里的媒体层（模糊只作用于背景，不糊 UI），
  遮罩、汉字雨、扫描线按 z-index 0–3 堆叠。重新注册主题 bump `$registryVersion`
  → 应用即时重绘。
- `dashboard/plugin_api.py` — `POST /activate`：hex 白名单校验 → 写
  `skins/<名称>.yaml` → 设置 `display.skin`；gateway watcher 广播 `skin.changed`，
  所有界面重绘（皮肤格式为 Hermes 规范格式 `apps/shared/src/skin.ts`）。

## 已知限制

- 本地图片转 **data URI**（约 2.5MB 上限）、本地视频约 3.5MB——超出后背景当前
  会话可用但不持久（存储配额），插件会提示。大图请粘贴 URL。
- 「应用」走皮肤调色板（终端优先转换）；**扩展功能**（壁纸、加粗、强调色、汉字雨）
  在主题激活时由插件提供。
- 激活是全局皮肤（Hermes 的 skin）——CLI/TUI/桌面都会生效。

## 开发

- 热重载：应用监听文件，保存后约 5 秒生效（或 ⌘K → Reload desktop plugins）。
  报错见 `~/.hermes/logs/desktop.log`。
- 动漫主题为调色板灵感致敬，与相关 IP 无官方关联。

## 许可

MIT — 见 `LICENSE`。复刻自 Theme Forge（MIT，Copyright 2026 Theme Forge contributors）。
