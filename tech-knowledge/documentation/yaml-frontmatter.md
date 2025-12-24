---
title: YAML Frontmatter 元数据规范
category: tech-knowledge/documentation
tags: [YAML, Frontmatter, Markdown, Metadata, Documentation]
created: 2025-12-24
updated: 2025-12-24
mastery: 4
difficulty: 2
review_dates:
  - 2025-12-25
  - 2025-12-27
  - 2025-12-31
  - 2026-01-07
  - 2026-01-24
status: learning
related: []
---

# YAML Frontmatter 元数据规范

## 📋 基本信息
- **主题**: Markdown 文件的元数据格式
- **分类**: tech-knowledge/documentation
- **标签**: #YAML #Frontmatter #Markdown #Metadata
- **创建日期**: 2025-12-24
- **最后更新**: 2025-12-24
- **掌握程度**: ⭐⭐⭐⭐ (已理解并实践)
- **难度等级**: ⭐⭐ (简单，易掌握)

## 🎯 核心概念

### 主要定义
**YAML Frontmatter** 是一种在 Markdown 文件开头嵌入元数据的标准格式，使用 YAML (YAML Ain't Markup Language) 语法。它被 `---` 分隔符包围，位于文件的最顶部。

### 关键特点
- **位置**: 必须在文件开头，第一个 `---` 之前不能有任何内容
- **分隔符**: 使用 `---` 开始和结束元数据块
- **格式**: YAML 键值对格式
- **解析**: 大多数 Markdown 处理器和静态网站生成器支持
- **灵活性**: 可以包含任意结构化数据

## 🔍 详细解释

### 工作原理
1. **解析**: 处理器读取文件时首先检查开头是否为 `---`
2. **提取**: 如果是，则提取直到下一个 `---` 的内容作为 YAML
3. **解析**: 将 YAML 内容解析为键值对数据结构
4. **分离**: 元数据与正文内容分离，供程序使用

### 应用场景
1. **知识管理系统**: 记录学习进度、复习日期、掌握程度
2. **静态网站生成**: Jekyll, Hugo, Hexo 等使用 frontmatter 配置页面
3. **文档系统**: 标题、作者、标签、分类等元信息
4. **博客文章**: 发布日期、更新时间、SEO 信息
5. **任务管理**: 优先级、状态、截止日期等

### 优缺点
**优点**：
- ✅ 标准化格式，广泛支持
- ✅ 人类可读，易于编辑
- ✅ 支持复杂数据结构（列表、嵌套对象）
- ✅ 不影响 Markdown 正文内容

**缺点**：
- ❌ YAML 语法对缩进敏感
- ❌ 需要解析器支持
- ❌ 增加文件大小

## 💻 代码示例

### 示例1：基础用法
```yaml
---
title: 我的文章标题
date: 2025-12-24
author: 张三
tags: [markdown, yaml, frontmatter]
---

# 文章正文开始

这里是可以正常使用的 Markdown 内容。
```

### 示例2：知识库元数据（Claude Code 集成系统）
```yaml
---
title: 知识条目标题
category: ai-ml/agent
tags: [AI, Agent, LLM, ClaudeCode]
created: 2025-12-24
updated: 2025-12-24
mastery: 3  # 1-5星
difficulty: 3  # 1-5星
review_dates:
  - 2025-12-25  # 第1次: 1天后
  - 2025-12-27  # 第2次: 3天后
  - 2025-12-31  # 第3次: 1周后
  - 2026-01-07  # 第4次: 2周后
  - 2026-01-24  # 第5次: 1个月后
  - 2026-04-24  # 第6次: 3个月后
status: learning  # learning/reviewed/mastered
related:
  - llm-basics.md
  - mcp-protocol.md
---
```

### 示例3：复杂嵌套结构
```yaml
---
title: 高级配置示例
metadata:
  project: "My Project"
  version: "1.0.0"
  authors:
    - name: "Alice"
      email: "alice@example.com"
    - name: "Bob"
      email: "bob@example.com"
options:
  debug: true
  max_connections: 100
  features:
    - feature_a
    - feature_b
---
```

### 示例4：Python 解析示例
```python
import yaml
import re

def parse_frontmatter(file_path):
    """读取并解析 Markdown 文件的 frontmatter"""
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # 检查是否有 frontmatter
    if not content.startswith('---'):
        return None, content

    # 提取 frontmatter 内容
    _, fm, body = content.split('---', 2)
    metadata = yaml.safe_load(fm)

    return metadata, body.strip()

# 使用示例
metadata, body = parse_frontmatter('example.md')
print(f"标题: {metadata['title']}")
print(f"标签: {', '.join(metadata['tags'])}")
print(f"掌握度: {metadata['mastery']}/5")
```

## 🔗 相关概念
- [YAML 语法](https://yaml.org/spec/1.2/spec.html) - YAML 官方规范
- [Markdown](https://www.markdownguide.org/) - Markdown 基础语法
- [Jekyll Frontmatter](https://jekyllrb.com/docs/front-matter/) - Jekyll 的 frontmatter 用法
- [Hugo Front Matter](https://gohugo.io/content-management/front-matter/) - Hugo 的 front matter 配置
- [TOML](https://toml.io/) - 另一种配置格式（可选替代）

## 📚 深入学习资源
- 📖 [YAML 官方网站](https://yaml.org/)
- 📰 [Markdown Frontmatter 指南](https://jekyllrb.com/docs/front-matter/)
- 🎥 [YAML in 5 Minutes](https://www.youtube.com/watch?v=cdLNKUoWvqI)
- 🔧 [PyYAML 文档](https://pyyaml.org/wiki/PyYAMLDocumentation)

## 🧠 记忆技巧
**口诀**: "三条线，开头见，中间写完三条线"
- **三条线**: 使用 `---` 作为分隔符
- **开头见**: 必须在文件最开头
- **中间写**: 在两条 `---` 之间写 YAML
- **三条线**: 再用 `---` 结束元数据

## ⚠️ 常见误区

### 误区1: 在 `---` 前有内容
❌ **错误**:
```markdown
这是我的文章

---
title: 文章标题
---
```

✅ **正确**:
```markdown
---
title: 文章标题
---

这是我的文章
```

### 误区2: YAML 缩进错误
❌ **错误** (使用 tab):
```yaml
---
tags:
  - markdown
    - yaml  # 缩进不一致
---
```

✅ **正确** (使用空格，2个空格一级):
```yaml
---
tags:
  - markdown
  - yaml
---
```

### 误区3: 忘记结束的 `---`
❌ **错误**:
```yaml
---
title: 文章标题
# 正文开始，缺少结束的 ---
```

✅ **正确**:
```yaml
---
title: 文章标题
---

# 正文开始
```

## 📈 实际应用

### 知识管理系统中的应用
1. **自动索引**: 根据 category 和 tags 生成目录
2. **复习提醒**: 根据 review_dates 发送提醒
3. **进度跟踪**: 根据 mastery 追踪学习进度
4. **关联推荐**: 根据 related 推荐相关内容
5. **统计分析**: 按日期、分类统计学习情况

### Git Pre-commit Hook 验证
```bash
#!/bin/bash
# 检查新文件的 frontmatter 完整性

for file in $(git diff --cached --name-only --diff-filter=A | grep '\.md$'); do
  # 跳过特定目录
  [[ "$file" =~ .claude/|daily-notes/|templates/ ]] && continue

  # 检查是否有 frontmatter
  if ! head -n 1 "$file" | grep -q '^---$'; then
    echo "❌ $file: 缺少 YAML frontmatter"
    exit 1
  fi

  # 检查必需字段
  required_fields=("title" "category" "tags" "created" "mastery")
  for field in "${required_fields[@]}"; do
    if ! grep -q "^$field:" "$file"; then
      echo "❌ $file: 缺少必需字段 '$field'"
      exit 1
    fi
  done
done

echo "✅ 所有文件的元数据检查通过"
```

## 🔄 复习计划
- **第1次复习**: 2025-12-25 (明天)
- **第2次复习**: 2025-12-27 (3天后)
- **第3次复习**: 2025-12-31 (1周后)
- **第4次复习**: 2026-01-07 (2周后)
- **第5次复习**: 2026-01-24 (1个月后)

## 📝 个人笔记

YAML Frontmatter 是 Claude Code 知识库系统的核心基础设施之一。它让 Markdown 文件不仅能被人类阅读，还能被程序理解和处理。

**关键洞察**：
1. **标准化是自动化的前提**: 没有 frontmatter，无法自动化处理知识库
2. **元数据即数据**: 元数据本身也是宝贵的数据，可以用于分析和优化
3. **简单但强大**: 简单的 `---` 分隔符让 Markdown 变成了结构化数据库

**实践中的发现**：
- Git pre-commit hook 确保元数据完整性非常有效
- 复习日期的计算需要考虑时区
- mastery 和 difficulty 的 1-5 星评分提供了量化指标
- related 字段可以构建知识图谱

**未来优化方向**：
- 添加 `last_reviewed` 字段跟踪实际复习日期
- 添加 `review_count` 字段记录复习次数
- 考虑添加 `sources` 字段记录学习资源来源
- 添加 `confidence` 字段记录对知识的信心程度

---
**状态**: ✅ 已完成
