---
title: Git Pre-commit Hook 元数据验证
category: tech-knowledge/git
tags: [Git, Hooks, Automation, Validation, DevOps, QualityControl, Bash]
created: 2025-12-24
updated: 2025-12-24
mastery: 2
difficulty: 3
review_dates:
  - 2025-12-24  # 第1次复习: 当天
  - 2025-12-25  # 第2次复习: 1天后（额外加强）
  - 2025-12-27  # 第3次复习: 3天后
  - 2025-12-31  # 第4次复习: 1周后
  - 2026-01-07  # 第5次复习: 2周后
  - 2026-01-24  # 第6次复习: 1月后
status: reviewed
related:
  - ../claude-code/knowledge-base-integration.md
  - ../documentation/yaml-frontmatter.md
---

# Git Pre-commit Hook 元数据验证

## 📋 基本信息
- **主题**: 使用 Git Hooks 自动验证知识库元数据
- **分类**: tech-knowledge/git
- **标签**: #Git #Hooks #Automation #Validation
- **创建日期**: 2025-12-24
- **最后更新**: 2025-12-24
- **掌握程度**: ⭐⭐⭐ (理解并修复过bug)
- **难度等级**: ⭐⭐⭐ (需要 Bash 和 Git 知识)

## 🎯 核心概念

### 主要定义
**Git Pre-commit Hook** 是在执行 `git commit` 命令之前自动触发的脚本，用于验证即将提交的内容是否符合规范。在知识库系统中，它用于自动检查知识条目的元数据完整性。

### 关键特点
- **自动执行**: 每次 commit 前自动运行，无需手动触发
- **阻止提交**: 验证失败时阻止提交，强制保证数据质量
- **可配置**: 可根据需要自定义验证规则
- **位置**: `.git/hooks/pre-commit`
- **语言**: 通常是 Bash 或 Python

## 🔍 详细解释

### 工作原理

#### Git Hooks 机制

```
git commit
    ↓
触发 pre-commit hook
    ↓
执行验证脚本
    ↓
验证结果
    ├── 成功 → 继续提交
    └── 失败 → 中止提交，显示错误
```

#### Hook 执行时机

```bash
git add file.md              # 添加到暂存区
git commit -m "message"      # 触发 pre-commit hook
    ↓
[pre-commit hook 执行]
    ↓
✅ 通过 → 提交成功
❌ 失败 → 提交被拒绝
```

### 验证规则

#### 1. 必备字段检查

验证知识条目包含所有必需的元数据字段：

```yaml
---
title: 知识条目标题          # 必需
category: ai-ml/agent       # 必需
tags: [AI, Agent]           # 必需
created: 2025-12-24         # 必需
updated: 2025-12-24         # 必需
mastery: 3                  # 必需
review_dates:               # 必需
  - 2025-12-25
status: learning            # 可选但有默认值
related:                    # 可选
  - related-file.md
---
```

#### 2. 数据类型验证

- **日期格式**: `YYYY-MM-DD` (正则: `^\d{4}-\d{2}-\d{2}$`)
- **mastery 范围**: 1-5 的整数
- **difficulty 范围**: 1-5 的整数
- **tags 格式**: 数组格式 `[]` 或 `- item`
- **review_dates 格式**: 数组格式，每项一个日期

#### 3. 文件命名规范

```bash
# ✅ 正确
react-hooks.md
yaml-frontmatter.md
ai-agent-basics.md

# ❌ 错误
React Hooks.md          # 包含空格和大写
AI_Agent_Basics.md      # 使用下划线
yaml frontmatter.md     # 包含空格
```

#### 4. 跳过规则

某些文件不需要元数据验证：
- `daily-notes/` - 每日笔记
- `.claude/` - Claude Code 配置
- 文档文件 (TEST-*.md, README.md 等)

### 应用场景

**知识库管理**:
- 保证所有知识条目有完整的元数据
- 统一数据格式
- 提高数据质量

**团队协作**:
- 强制执行编码规范
- 统一提交标准
- 减少错误提交

**自动化集成**:
- CI/CD 流程的一部分
- 自动化测试
- 质量控制

### 优缺点

**优点**:
- ✅ 自动化执行，无需人工干预
- ✅ 阻止不符合规范的提交
- ✅ 即时反馈，快速修正
- ✅ 保证数据质量
- ✅ 可扩展的验证规则

**缺点**:
- ❌ 需要编写和维护脚本
- ❌ 可能拖慢提交速度（如果验证复杂）
- ❌ 只在本地执行，远程仓库无法强制
- ❌ 可以被 `--no-verify` 绕过

## 💻 代码示例

### 示例1: 基础 Pre-commit Hook

```bash
#!/bin/bash

# Git pre-commit hook for knowledge base
# 检查新文件的元数据完整性

echo "🔍 运行 pre-commit 检查..."

# 获取暂存的新增文件
NEW_FILES=$(git diff --cached --name-only --diff-filter=A | grep "\.md$" || true)

if [ -z "$NEW_FILES" ]; then
    echo "✅ 没有新的 Markdown 文件，跳过检查"
    exit 0
fi

ERRORS=0

# 检查每个文件
for file in $NEW_FILES; do
    echo "检查: $file"

    # 跳过每日笔记和配置文件
    if [[ $file =~ ^daily-notes/|\.claude/ ]]; then
        echo "  ⏭️  跳过检查"
        continue
    fi

    # 检查 YAML frontmatter
    if ! grep -q "^---$" "$file"; then
        echo "  ❌ 缺少 YAML frontmatter"
        ERRORS=$((ERRORS + 1))
    else
        # 提取 frontmatter 内容
        frontmatter=$(awk '/^---$/{if (++count == 2) exit; next} 1' "$file")

        # 检查必备字段
        REQUIRED_FIELDS=("title:" "category:" "tags:" "created:" "mastery:")

        for field in "${REQUIRED_FIELDS[@]}"; do
            if ! echo "$frontmatter" | grep -q "^$field"; then
                echo "  ❌ 缺少必备字段: $field"
                ERRORS=$((ERRORS + 1))
            fi
        done
    fi

    echo ""
done

# 显示结果
if [ $ERRORS -gt 0 ]; then
    echo "❌ 发现 $ERRORS 个错误，请修复后再提交"
    echo "提示: 使用 'git commit --no-verify' 跳过检查（不推荐）"
    exit 1
else
    echo "✅ 所有检查通过"
fi

exit 0
```

### 示例2: 完整验证脚本（含所有检查）

```bash
#!/bin/bash
# .git/hooks/pre-commit

set -e

echo "🔍 运行 pre-commit 检查..."

NEW_FILES=$(git diff --cached --name-only --diff-filter=A | grep "\.md$" || true)

if [ -z "$NEW_FILES" ]; then
    echo "✅ 没有新的 Markdown 文件"
    exit 0
fi

echo "📝 检查文件:"
echo "$NEW_FILES"
echo ""

ERRORS=0
WARNINGS=0

for file in $NEW_FILES; do
    echo "检查: $file"

    # 跳过规则
    if [[ $file =~ ^daily-notes/ ]]; then
        echo "  ⏭️  每日笔记，跳过"
        continue
    fi

    if [[ $file =~ ^\.claude/ ]]; then
        echo "  ⏭️  配置文件，跳过"
        continue
    fi

    if [[ $file =~ ^(TEST|README|SETUP|STAGE) ]]; then
        echo "  ⏭️  文档文件，跳过"
        continue
    fi

    # 1. 检查 YAML frontmatter
    if ! grep -q "^---$" "$file"; then
        echo "  ❌ 缺少 YAML frontmatter"
        ERRORS=$((ERRORS + 1))
        continue
    fi

    # 提取 frontmatter
    frontmatter=$(awk '/^---$/{if (++count == 2) exit; next} 1' "$file")

    # 2. 检查必备字段
    REQUIRED_FIELDS=("title:" "category:" "tags:" "created:" "updated:" "mastery:" "review_dates:")

    for field in "${REQUIRED_FIELDS[@]}"; do
        if ! echo "$frontmatter" | grep -q "^$field"; then
            echo "  ❌ 缺少必备字段: $field"
            ERRORS=$((ERRORS + 1))
        fi
    done

    # 3. 检查 mastery 范围
    if echo "$frontmatter" | grep -q "^mastery:"; then
        mastery=$(echo "$frontmatter" | grep "^mastery:" | sed 's/mastery: *//' | sed 's/ #.*$//' | tr -d '\r')
        if ! [[ $mastery =~ ^[1-5]$ ]]; then
            echo "  ❌ mastery 值无效: $mastery (应该是 1-5)"
            ERRORS=$((ERRORS + 1))
        fi
    fi

    # 4. 检查日期格式
    date_fields=("created:" "updated:")
    for field in "${date_fields[@]}"; do
        if echo "$frontmatter" | grep -q "^$field"; then
            date_value=$(echo "$frontmatter" | grep "^$field" | sed "s/^$field *//" | sed 's/ #.*$//' | tr -d '\r')
            if ! [[ $date_value =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
                echo "  ⚠️  $field 日期格式不正确: $date_value"
                WARNINGS=$((WARNINGS + 1))
            fi
        fi
    done

    # 5. 检查文件命名
    filename=$(basename "$file")
    if [[ ! $filename =~ ^[a-z0-9-]+\.md$ ]]; then
        echo "  ⚠️  文件命名不规范: $filename"
        echo "      建议使用小写字母、数字和连字符"
        WARNINGS=$((WARNINGS + 1))
    fi

    echo ""
done

# 显示汇总
echo "---"
echo "📊 检查结果:"

if [ $ERRORS -gt 0 ]; then
    echo "  ❌ 错误: $ERRORS 个"
    echo "  ⚠️  警告: $WARNINGS 个"
    echo ""
    echo "请修复错误后再提交"
    exit 1
elif [ $WARNINGS -gt 0 ]; then
    echo "  ⚠️  警告: $WARNINGS 个"
    echo ""
    echo "建议修复警告，但可以继续提交"
    read -p "是否继续? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
else
    echo "  ✅ 所有检查通过"
fi

exit 0
```

### 示例3: Python 版本（跨平台）

```python
#!/usr/bin/env python3
"""
Git pre-commit hook for knowledge base validation
跨平台版本，功能更强大
"""

import os
import re
import sys
import yaml
from pathlib import Path

def get_staged_files():
    """获取暂存的新 Markdown 文件"""
    import subprocess
    result = subprocess.run(
        ['git', 'diff', '--cached', '--name-only', '--diff-filter=A'],
        capture_output=True,
        text=True
    )
    files = result.stdout.strip().split('\n')
    return [f for f in files if f.endswith('.md')]

def should_skip(file_path):
    """判断是否应该跳过检查"""
    skip_patterns = [
        r'^daily-notes/',
        r'^\.claude/',
        r'^(TEST|README|SETUP|STAGE|IMPLEMENTATION|MCP|OBSIDIAN)',
    ]
    for pattern in skip_patterns:
        if re.match(pattern, file_path):
            return True
    return False

def extract_frontmatter(file_path):
    """提取 YAML frontmatter"""
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    if not content.startswith('---'):
        return None

    parts = content.split('---', 2)
    if len(parts) < 3:
        return None

    try:
        return yaml.safe_load(parts[1])
    except yaml.YAMLError as e:
        print(f"  ❌ YAML 解析错误: {e}")
        return None

def validate_metadata(file_path, metadata):
    """验证元数据"""
    errors = []
    warnings = []

    # 必备字段
    required = ['title', 'category', 'tags', 'created', 'updated', 'mastery', 'review_dates']
    for field in required:
        if field not in metadata:
            errors.append(f"缺少字段: {field}")

    # mastery 范围
    if 'mastery' in metadata:
        if not isinstance(metadata['mastery'], int) or not 1 <= metadata['mastery'] <= 5:
            errors.append(f"mastery 值无效: {metadata['mastery']}")

    # 日期格式
    date_pattern = re.compile(r'^\d{4}-\d{2}-\d{2}$')
    for field in ['created', 'updated']:
        if field in metadata:
            if not date_pattern.match(str(metadata[field])):
                warnings.append(f"{field} 日期格式错误: {metadata[field]}")

    # review_dates 格式
    if 'review_dates' in metadata:
        if not isinstance(metadata['review_dates'], list):
            errors.append("review_dates 应该是数组")
        else:
            for date in metadata['review_dates']:
                if not date_pattern.match(str(date)):
                    warnings.append(f"review_dates 中有无效日期: {date}")

    # 文件命名
    filename = Path(file_path).name
    if not re.match(r'^[a-z0-9-]+\.md$', filename):
        warnings.append(f"文件命名不规范: {filename}")

    return errors, warnings

def main():
    print("🔍 运行 pre-commit 检查...")

    files = get_staged_files()
    if not files:
        print("✅ 没有新的 Markdown 文件")
        return 0

    print(f"📝 检查 {len(files)} 个文件\n")

    total_errors = 0
    total_warnings = 0

    for file_path in files:
        print(f"检查: {file_path}")

        if should_skip(file_path):
            print("  ⏭️  跳过\n")
            continue

        frontmatter = extract_frontmatter(file_path)
        if frontmatter is None:
            print("  ❌ 缺少 YAML frontmatter\n")
            total_errors += 1
            continue

        errors, warnings = validate_metadata(file_path, frontmatter)

        for error in errors:
            print(f"  ❌ {error}")
        for warning in warnings:
            print(f"  ⚠️  {warning}")

        if errors or warnings:
            print()

        total_errors += len(errors)
        total_warnings += len(warnings)

    # 显示汇总
    print("---")
    print("📊 检查结果:")

    if total_errors > 0:
        print(f"  ❌ 错误: {total_errors} 个")
        print(f"  ⚠️  警告: {total_warnings} 个")
        print("\n请修复错误后再提交")
        return 1
    elif total_warnings > 0:
        print(f"  ⚠️  警告: {total_warnings} 个")
        print("\n建议修复警告")
        return 0
    else:
        print("  ✅ 所有检查通过")
        return 0

if __name__ == '__main__':
    sys.exit(main())
```

### 示例4: 安装 Hook

```bash
#!/bin/bash
# install-hooks.sh
# 自动安装 pre-commit hook

HOOK_FILE=".git/hooks/pre-commit"
SCRIPT_FILE="scripts/pre-commit.sh"

# 复制脚本
cp "$SCRIPT_FILE" "$HOOK_FILE"

# 添加执行权限
chmod +x "$HOOK_FILE"

echo "✅ Pre-commit hook 已安装"
echo "📍 位置: $HOOK_FILE"
```

## 🔗 相关概念

- [Git Hooks 官方文档](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks) - Git Hooks 完整指南
- [YAML Frontmatter](../documentation/yaml-frontmatter.md) - 元数据格式规范
- [Claude Code 知识库集成](../claude-code/knowledge-base-integration.md) - 完整系统说明
- [Bash 脚本编程](https://www.gnu.org/software/bash/manual/) - Bash 官方手册
- [正则表达式](https://regex101.com/) - 在线正则测试工具

## 📚 深入学习资源

- 📖 [Git Hooks 指南](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks)
- 📰 [Pre-commit 框架](https://pre-commit.com/) - 多语言 pre-commit 框架
- 🎥 [Bash 脚本教程](https://www.youtube.com/results?search_query=bash+tutorial)
- 🔧 [Husky](https://github.com/typicode/husky) - Git hooks 管理工具（Node.js）

## 🧠 记忆技巧

**记忆口诀**: "暂存触发，自动执行"
- **暂存**: `git add` 后进入暂存区
- **触发**: `git commit` 时自动触发
- **自动**: 无需手动运行
- **执行**: 验证规则并返回结果

**验证流程**:
```
1. 获取暂存文件
2. 跳过特殊文件
3. 检查 frontmatter
4. 验证字段
5. 检查格式
6. 返回结果
```

## ⚠️ 常见误区

### 误区1: Hook 会在远程执行
❌ **错误**: Hook 会在 push 到远程时执行
✅ **正确**: Hook 只在本地执行，远程无法强制

**解决**: 在 CI/CD 中添加相同的验证

### 误区2: --no-verify 是安全的
❌ **错误**: 经常使用 `--no-verify` 没问题
✅ **正确**: 应该修复问题而不是绕过检查

**建议**: 仅在紧急情况下使用，事后要修复

### 误区3: Hook 可以验证所有内容
❌ **错误**: Hook 可以检查提交后的内容
✅ **正确**: Hook 只能检查暂存区的内容

**注意**: Hook 无法检查已提交的历史

### 误区4: Shell 脚本不可移植
❌ **错误**: Bash hook 在 Windows/Mac/Linux 不兼容
✅ **正确**: 使用 Python 可以跨平台

**选择**:
- Bash: Unix/Linux/Mac (简单快速)
- Python: 跨平台 (功能强大)

## 📈 实际应用

### 安装和使用

**步骤 1: 创建 Hook 文件**
```bash
# 方法 1: 手动创建
vim .git/hooks/pre-commit

# 方法 2: 从脚本复制
cp scripts/pre-commit.sh .git/hooks/pre-commit

# 方法 3: 使用符号链接
ln -s ../../scripts/pre-commit.sh .git/hooks/pre-commit
```

**步骤 2: 添加执行权限**
```bash
chmod +x .git/hooks/pre-commit
```

**步骤 3: 测试**
```bash
# 添加一个不符合规范的文件
git add invalid-file.md

# 尝试提交（应该失败）
git commit -m "test"

# 修复后重试
git add valid-file.md
git commit -m "test"  # 应该成功
```

### 调试技巧

**启用调试输出**:
```bash
# 在脚本开头添加
set -x  # 显示执行的命令

# 或使用
BASH_XTRACEFD=1 git commit -m "test"
```

**手动测试 Hook**:
```bash
# 直接运行 Hook
.git/hooks/pre-commit

# 或使用 bash -x
bash -x .git/hooks/pre-commit
```

**绕过 Hook（仅用于测试）**:
```bash
git commit --no-verify -m "test"
```

### 集成到团队工作流

**共享 Hooks**:
```bash
# 方法 1: 在 .git/scripts/ 目录存放脚本
# 方法 2: 使用 git config 设置核心路径
git config core.hooksPath .githooks

# 方法 3: 使用 npm/yarn 安装（Node.js 项目）
npm install --save-dev husky
npx husky install
```

**CI/CD 集成**:
```yaml
# .github/workflows/validate.yml
name: Validate Metadata

on: [push, pull_request]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Validate Metadata
        run: |
          python scripts/validate_metadata.py
```

## 🔄 复习计划

- **第1次复习**: 2025-12-25 (明天)
- **第2次复习**: 2025-12-27 (3天后)
- **第3次复习**: 2025-12-31 (1周后)
- **第4次复习**: 2026-01-07 (2周后)
- **第5次复习**: 2026-01-24 (1个月后)
- **第6次复习**: 2026-04-24 (3个月后)

## 📝 个人笔记

Git Hooks 是自动化数据质量保证的关键工具。在知识库项目中，pre-commit hook 扮演了"守门员"的角色，确保所有新增的知识条目都符合规范。

**关键发现**:

1. **Bug 修复经历**:
   - **问题1**: Hook 匹配了整个文件而非仅 frontmatter
     - **解决**: 使用 `awk` 提取 frontmatter 部分
   - **问题2**: `head -n -1` 在 macOS 上不支持
     - **解决**: 改用 `awk` 命令

2. **性能考虑**:
   - Hook 执行时间应该 < 1秒
   - 避免复杂的网络请求
   - 优化文件搜索和匹配

3. **用户体验**:
   - 清晰的错误提示
   - 友好的跳过规则
   - 不影响正常工作流

4. **维护成本**:
   - Hook 脚本需要测试
   - 跨平台兼容性需要考虑
   - 团队成员需要了解规则

**最佳实践**:
- ✅ 简单的验证规则
- ✅ 清晰的错误信息
- ✅ 合理的跳过规则
- ✅ 版本控制 Hook 脚本
- ✅ 定期更新和测试

**未来改进**:
- [ ] 添加更多验证规则（内容质量、标签一致性）
- [ ] 支持自动修复某些问题
- [ ] 集成到 CI/CD 流程
- [ ] 提供可视化报告
- [ ] 支持自定义配置

---
**状态**: ✅ 已实施并修复 bug
