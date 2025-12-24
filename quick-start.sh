#!/bin/bash

# 快速开始脚本 - Claude Code 集成
# 这个脚本帮助你快速开始使用新的知识库系统

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║         Claude Code 个人知识库系统 - 快速开始              ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}✅ 阶段1 实施完成！${NC}"
echo ""
echo "📚 已创建的核心功能:"
echo "  ✓ /daily-note  - 智能创建每日学习笔记"
echo "  ✓ /extract     - 从笔记中提取知识条目"
echo "  ✓ /review      - 基于艾宾浩斯曲线的复习系统"
echo "  ✓ Git pre-commit hook - 元数据自动检查"
echo ""
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "🚀 快速开始你的学习之旅:"
echo ""
echo "1. 创建今日笔记:"
echo "   $ ./tools/create-daily-note.sh"
echo "   或者在 Claude Code 中运行: /daily-note"
echo ""
echo "2. 开始学习..."
echo "   记录你的学习内容到每日笔记"
echo ""
echo "3. 提取知识条目:"
echo "   $ claude /extract 2025-12-24"
echo ""
echo "4. 复习时间:"
echo "   $ claude /review --due=today"
echo ""
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "📖 查看详细文档:"
echo "   $ cat CLAUDE-CODE-SETUP.md"
echo ""
echo "📊 查看实施计划:"
echo "   $ cat .claude/plans/rustling-twirling-wand.md"
echo ""
echo "💡 提示:"
echo "  - 所有知识条目需要包含 YAML frontmatter 元数据"
echo "  - Git commit 时会自动检查元数据完整性"
echo "  - 使用 /extract 命令自动创建知识条目"
echo ""
echo -e "${GREEN}🎯 学习愉快！${NC}"
echo ""
