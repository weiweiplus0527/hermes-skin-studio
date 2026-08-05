#!/usr/bin/env bash
# 皮肤工坊（Skin Studio）一键安装脚本
# 用法: ./install.sh   （或 bash install.sh）
set -euo pipefail

HERMES_HOME="${HERMES_HOME:-$HOME/.hermes}"
SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_NAME="skin-studio"

echo "📦 皮肤工坊 (Skin Studio) 安装程序"
echo "  源目录: $SRC_DIR"
echo "  目标:   $HERMES_HOME"

# 1. 复制桌面插件（前端）
mkdir -p "$HERMES_HOME/desktop-plugins/$PLUGIN_NAME"
cp "$SRC_DIR/plugin.js" "$SRC_DIR/LICENSE" "$SRC_DIR/README.md" "$HERMES_HOME/desktop-plugins/$PLUGIN_NAME/"
echo "✅ 前端插件 → $HERMES_HOME/desktop-plugins/$PLUGIN_NAME/"

# 2. 复制 Python 后端（「应用」按钮 + 皮肤持久化）
mkdir -p "$HERMES_HOME/plugins/$PLUGIN_NAME/dashboard"
cp "$SRC_DIR/dashboard/manifest.json" "$SRC_DIR/dashboard/plugin_api.py" "$HERMES_HOME/plugins/$PLUGIN_NAME/dashboard/"
echo "✅ 后端插件 → $HERMES_HOME/plugins/$PLUGIN_NAME/dashboard/"

# 3. 启用插件（写入 plugins.enabled，YAML 数组格式）
python3 - "$HERMES_HOME/config.yaml" <<'PYEOF'
import os, sys

path = sys.argv[1]
name = "skin-studio"

if not os.path.exists(path):
    print("⚠️  未找到 config.yaml，跳过启用配置（重启后请手动添加 plugins.enabled）")
    sys.exit(0)

with open(path, encoding="utf-8") as f:
    lines = f.read().split("\n")

# 已在文件中（幂等）
if any(name in l for l in lines if l.strip().startswith("- ")):
    print("✅ plugins.enabled 已包含 skin-studio")
    sys.exit(0)

# 找 plugins: 行
pi = None
for i, l in enumerate(lines):
    if l.rstrip() == "plugins:" or l.rstrip().startswith("plugins:"):
        pi = i
        break

if pi is None:
    lines += ["", "plugins:", "  enabled:", f"    - {name}"]
    with open(path, "w", encoding="utf-8") as f:
        f.write("\n".join(lines))
    print("✅ 已在 config.yaml 添加 plugins.enabled")
    sys.exit(0)

# plugins 块内找 enabled:
ei = None
j = pi + 1
while j < len(lines) and (lines[j].startswith("  ") or lines[j].strip() == ""):
    if lines[j].strip().startswith("enabled:"):
        ei = j
        break
    j += 1

if ei is None:
    lines.insert(j, "  enabled:")
    lines.insert(j + 1, f"    - {name}")
    with open(path, "w", encoding="utf-8") as f:
        f.write("\n".join(lines))
    print("✅ 已在 plugins 下添加 enabled")
    sys.exit(0)

# enabled 已存在：如果是数组，追加；否则转数组
k = ei + 1
items = []
while k < len(lines) and lines[k].startswith("    "):
    if lines[k].strip().startswith("- "):
        items.append(lines[k])
    k += 1

if items:
    items.append(f"    - {name}")
    lines[ei + 1 : k] = items
else:
    lines[ei + 1 : k] = [f"    - {name}"]
with open(path, "w", encoding="utf-8") as f:
    f.write("\n".join(lines))
print("✅ 已追加 skin-studio 到 plugins.enabled")

PYEOF

echo ""
echo "🎉 安装完成！接下来："
echo "  1. 完全退出 Hermes Desktop（Cmd+Q）再重新打开"
echo "  2. ⌘K → Reload desktop plugins"
echo "  3. 侧边栏出现「皮肤工坊」→ 选主题 → 点「应用」"
echo ""
echo "有问题或建议：https://github.com/naiyou-dotcom/hermes-skin-studio"
