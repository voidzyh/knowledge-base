# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目定位

这是一个基于 Claude Code 驱动的个人知识管理系统，采用 Markdown 格式组织内容，结合艾宾浩斯遗忘曲线实现知识的高效积累和复习。系统支持个人学习提升、工作技能积累和研究写作，并提供移动端访问能力。

## 核心工作流程

### 1. 创建每日学习笔记
```bash
# 使用自动化脚本快速创建今日笔记
./create-daily-note.sh

# 或手动创建
touch daily-notes/$(date +%Y-%m-%d).md
```

### 2. 整理知识条目
- 将每日笔记中的重要内容整理到对应主题目录
- 使用知识条目模板：`templates/knowledge-entry-template.md`
- 按主题分类存储：`ai-ml/`、`programming/`、`tech-knowledge/`

### 3. Git 管理与提交
```bash
# 添加所有新内容
git add .

# 按日期提交每日学习内容
git commit -m "feat: 添加今日学习笔记 - $(date +%Y-%m-%d)"

# 推送到远程仓库
git push
```

## 目录结构

```
knowledge-base/
├── daily-notes/          # 每日学习笔记（按日期命名）
├── ai-ml/               # AI和机器学习知识
│   ├── agent/           # AI智能体相关
│   ├── llm/             # 大语言模型
│   └── mcp/             # 模型上下文协议
├── programming/         # 编程技术
├── tech-knowledge/      # 技术知识
├── templates/           # 模板文件
└── resources/           # 资源和工具
```

## 模板系统

- **每日笔记模板**：`templates/daily-note-template.md`
- **知识条目模板**：`templates/knowledge-entry-template.md`
- **复习计划模板**：`templates/review-plan-template.md`

## 编写规范

### 文件命名
- 每日笔记：`YYYY-MM-DD.md`
- 知识条目：使用英文和连字符，如 `ai-agent-basics.md`

### 标签系统
- **领域标签**：#AI #LLM #Agent #Swift #Python #WebDev
- **状态标签**：#每日学习 #重要 #待深入 #已掌握 #需复习
- **难度评级**：⭐ 到 ⭐⭐⭐⭐⭐

### 内容格式
- 使用统一的Markdown结构
- 包含代码示例、相关概念链接
- 添加复习计划和掌握程度评估

## 常见任务

### 查找相关内容
```bash
# 搜索AI相关内容
rg "#AI" --type md

# 查找特定主题
rg "agent" ai-ml/ -A 2 -B 2
```

### 整理知识
- 将每日笔记中的重要概念提取为独立知识条目
- 建立知识点之间的交叉引用
- 更新目录索引和复习计划

### 备份和同步
- 使用Git进行版本控制
- 定期推送到GitHub远程仓库
- 创建重要版本的标签备份

## 注意事项

- 保持中文注释和说明的一致性
- 所有知识条目应包含实际应用示例
- 定期回顾和更新已掌握程度
- 使用艾宾浩斯遗忘曲线安排复习计划

---

## 元数据规范

### YAML Frontmatter 结构

所有知识条目文件必须包含 YAML frontmatter 元数据：

```yaml
---
title: 知识条目标题
category: ai-ml/agent  # 主分类/子分类
tags: [AI, Agent, LLM, ClaudeCode]  # 3-7个标签
created: 2025-12-12
updated: 2025-12-12
mastery: 3  # 掌握程度 1-5星
difficulty: 3  # 难度等级 1-5星
review_dates:
  - 2025-12-13  # 第1次：1天后
  - 2025-12-15  # 第2次：3天后
  - 2025-12-19  # 第3次：1周后
  - 2025-12-26  # 第4次：2周后
  - 2026-01-12  # 第5次：1个月后
status: learning  # learning/reviewed/mastered
related:
  - llm-basics.md
  - mcp-protocol.md
---
```

### 元数据字段说明

| 字段 | 类型 | 必需 | 说明 |
|------|------|------|------|
| `title` | string | ✅ | 知识条目标题，简洁明确 |
| `category` | path | ✅ | 分类路径，如 `ai-ml/agent` |
| `tags` | array | ✅ | 3-7个标签，用于分类和搜索 |
| `created` | date | ✅ | 创建日期，格式 YYYY-MM-DD |
| `updated` | date | ✅ | 最后更新日期 |
| `mastery` | integer | ✅ | 掌握程度，1-5星 |
| `difficulty` | integer | ⚪ | 难度等级，1-5星 |
| `review_dates` | array | ✅ | 艾宾浩斯复习日期列表 |
| `status` | string | ✅ | learning/reviewed/mastered |
| `related` | array | ⚪ | 相关知识条目的文件路径 |

### 标签系统规范

**领域标签**（用于分类）：
- #AI #LLM #Agent #Swift #Python #React #WebDev #Database #DevOps

**状态标签**（用于管理）：
- #每日学习 #重要 #待深入 #已掌握 #需复习 #实践项目

**难度评级**：
- ⭐ 入门级
- ⭐⭐ 基础级
- ⭐⭐⭐ 中级
- ⭐⭐⭐⭐ 高级
- ⭐⭐⭐⭐⭐ 专家级

---

## Claude Code 工作流

### Slash Commands

系统提供以下 Slash Commands 来简化和自动化日常任务：

#### 核心命令（阶段1）

**`/daily-note`** - 创建每日学习笔记
- 自动检测今日笔记是否存在
- 提供学习建议（基于昨日笔记和复习计划）
- 提醒到期的复习任务
- 预填充今日目标

**`/extract [日期]`** - 从每日笔记提取知识条目
- 智能识别重要知识点
- 去重检测（搜索相似条目）
- 使用知识条目模板创建
- 自动填充元数据
- 建立反向链接

**`/review [主题]`** - 复习特定主题
- 查找主题相关的所有知识条目
- 显示当前掌握程度和最后复习时间
- 提供3种复习模式：快速回顾、主动回忆、深度复习
- 复习后更新掌握程度
- 计算下次复习日期

#### 扩展命令（阶段2+）

**`/learn [主题]`** - 学习新知识并创建知识条目
**`/connect [主题]`** - 发现和建立知识点之间的关联
**`/organize [范围]`** - 分析和整理知识库
**`/summarize [领域]`** - 总结知识领域
**`/plan-review [时间范围]`** - 生成复习计划
**`/find-gaps [范围]`** - 发现知识盲区
**`/sync-status [范围]`** - 同步学习状态

### Sub-agents

系统配置了以下自动化助手来处理特定任务：

#### 每日计划助手（Daily Planner Agent）
- 分析昨日学习内容和成果
- 识别今日需要复习的知识点
- 推荐今日学习主题
- 平衡新学习和复习时间
- 生成可执行的每日计划
- 调度：每日早上自动运行

#### 知识提取助手（Knowledge Extractor Agent）
- 智能分析每日笔记内容
- 识别重要知识点（基于内容特征）
- 去重判断（搜索相似条目）
- 自动生成元数据（分类、标签、重要性）
- 建立知识关联
- 支持批量提取多日笔记

#### 复习提醒助手（Review Reminder Agent）
- 扫描所有知识条目的复习状态
- 基于艾宾浩斯曲线计算到期复习
- 按优先级排序（紧急度、重要性、掌握度）
- 每日自动提醒（9:00、14:00、20:00）
- 跟踪复习完成情况

---

## 艾宾浩斯遗忘曲线复习系统

### 复习间隔

根据艾宾浩斯遗忘曲线，知识条目需要在特定时间点进行复习：

```
学习时刻
  ↓
第1次复习：1天后（短期记忆巩固）
  ↓
第2次复习：3天后（防止快速遗忘）
  ↓
第3次复习：1周后（中期记忆巩固）
  ↓
第4次复习：2周后（长期记忆形成）
  ↓
第5次复习：1个月后（深度记忆巩固）
  ↓
第6次复习：3个月后（永久记忆形成）
```

### 复习模式

**快速回顾模式**（15分钟）：
- 显示核心概念要点
- 快速浏览关键内容
- 适合时间紧张时的复习

**主动回忆模式**（30分钟）：
- 先不看资料，回答测试问题
- 然后查看答案，对比差距
- 适合检验掌握程度

**深度复习模式**（60分钟）：
- 完整阅读所有内容
- 研究代码示例
- 思考应用场景
- 适合重要且困难的知识

### 掌握度评估

复习后根据表现调整掌握度：

| 表现 | 掌握度变化 | 说明 |
|------|-----------|------|
| 回答完美，能举一反三 | +1 | 显著提升 |
| 基本正确，理解清晰 | 不变 | 保持稳定 |
| 部分遗忘，需要提示 | -1 | 安排额外复习 |
| 完全遗忘，需要重新学习 | -2 | 按新知识处理 |

---

## 知识管理最佳实践

### 日常学习流程

```bash
# 1. 开始学习前
/daily-note
# → 创建今日笔记，提供学习建议

# 2. 学习中... 记录笔记到每日笔记文件

# 3. 学习后整理
/extract 2025-12-12
# → 提取今日学到的知识点，创建独立条目

# 4. 建立知识关联
/connect react-server-components
# → 查看相关知识图谱，建立关联

# 5. 复习时间
/review agent-basics
# → 主动回忆测试，更新掌握度
```

### Git 工作流

```bash
# 提交每日学习
git add .
git commit -m "feat: 添加今日学习笔记 - $(date +%Y-%m-%d)"

# 提交知识条目
git commit -m "feat: 提取知识条目 - React Server Components"

# 提交复习更新
git commit -m "review: 复习 Agent 基础 - $(date +%Y-%m-%d)"

# 推送到远程仓库
git push
```

### 移动端访问

系统支持通过 GitHub Issues 和 Obsidian 移动端进行远程访问：

1. **GitHub Issues 工作流**：
   - 在 GitHub mobile app 创建 issue
   - 在评论中提及 @claude 触发执行
   - Claude Code 自动处理并更新 issue

2. **Obsidian 移动端**：
   - 使用 Obsidian Git 插件同步知识库
   - 随时随地查看和编辑知识条目
   - 自动同步回主库

---

## 常见任务

### 查找相关内容
```bash
# 使用 ripgrep 搜索标签
rg "#AI" --type md

# 查找特定主题
rg "agent" ai-ml/ -A 2 -B 2

# 查找特定元数据
rg "mastery: [1-2]" --type md  # 查找未掌握的内容
```

### 知识提取标准
满足以下条件之一的内容应提取为独立知识条目：
- 标记为 #重要 或 ⭐⭐⭐⭐⭐
- 包含代码示例且有深入解释
- 有明确的定义和实际应用说明
- 用户标注为 #待深入
- 构成完整知识体系的一环

### 知识关联建立
创建知识条目时，应考虑以下关联类型：
- **前置知识**：学习此主题前需要掌握的内容
- **后续延伸**：基于此文主题的深入内容
- **相关概念**：相似或对比的概念
- **应用案例**：实际应用此知识的项目或案例
- **工具资源**：相关的工具、库、框架

### 定期整理任务
- **每日**：运行 `/extract` 整理当日笔记
- **每周**：运行 `/organize` 进行轻度整理
- **每月**：运行 `/sync-status` 生成学习报告
- **每季度**：全面审查知识库结构