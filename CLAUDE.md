# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 仓库概述

这是一个个人知识库系统，用于系统化地收集、整理和复习AI、技术和编程知识。仓库采用Markdown格式组织内容，支持每日学习记录和知识条目管理。

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