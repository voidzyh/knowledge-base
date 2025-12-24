#!/bin/bash

# 增强版每日笔记创建脚本
# 集成 AI 分析和学习建议

set -e

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 默认日期为今天
DATE=${1:-$(date +%Y-%m-%d)}
NOTE_FILE="daily-notes/${DATE}.md"
TEMPLATE_FILE="templates/daily-note-template.md"

# 检查日期格式
if ! [[ $DATE =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
    echo -e "${RED}❌ 错误: 日期格式不正确${NC}"
    echo "使用方法: $0 [YYYY-MM-DD]"
    echo "默认: 使用今天的日期"
    exit 1
fi

# 创建目录
mkdir -p "$(dirname "$NOTE_FILE")"

# 检查文件是否已存在
if [ -f "$NOTE_FILE" ]; then
    echo -e "${YELLOW}⚠️  笔记已存在: $NOTE_FILE${NC}"
    echo ""
    echo "📄 文件内容预览:"
    echo "---"
    head -n 20 "$NOTE_FILE"
    echo "---"
    echo ""
    read -p "是否打开现有文件? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # 尝试使用默认编辑器
        if [ -n "$EDITOR" ]; then
            $EDITOR "$NOTE_FILE"
        elif command -v code &> /dev/null; then
            code "$NOTE_FILE"
        elif command -v vim &> /dev/null; then
            vim "$NOTE_FILE"
        else
            open "$NOTE_FILE"
        fi
    fi
    exit 0
fi

# 检查模板文件是否存在
if [ ! -f "$TEMPLATE_FILE" ]; then
    echo -e "${RED}❌ 模板文件不存在: $TEMPLATE_FILE${NC}"
    echo "使用默认模板创建文件..."

    # 创建默认模板
    cat > "$NOTE_FILE" << EOF
# 每日学习笔记 - $DATE

## 📅 基本信息
- **日期**: $DATE
- **星期**: $(date -j -f "%Y-%m-%d" "$DATE" "+%A" 2>/dev/null || date "+%A")
- **天气**:
- **心情**:
- **效率**: ⭐⭐⭐⭐⭐

## 🎯 今日目标

### 学习计划
- [ ] 目标1
- [ ] 目标2
- [ ] 目标3

### 复习任务
- [ ] 复习主题1
- [ ] 复习主题2

## 📚 学习内容

### 主题1: [主题名称]
**时间**: [时间段]

#### 核心概念
- 概念1
- 概念2

#### 重要笔记
[记录学习内容]

#### 代码示例
\`\`\`language
// 代码内容
\`\`\`

#### 疑问和思考
[记录疑问和思考]

### 主题2: [主题名称]
[同样的结构...]

## 💡 灵感和想法
[记录灵感、想法、待办事项]

## 📝 总结
### 今日收获
- 收获1
- 收获2

### 遇到的问题
- 问题1及解决方案

### 明日计划
- 计划1
- 计划2

## 🔗 相关资源
- [链接1](URL)
- [链接2](URL)

---

**标签**: #每日学习 #$(date +%Y) #$(date +%m)
EOF
else
    # 使用模板文件
    DAY_OF_WEEK=$(date -j -f "%Y-%m-%d" "$DATE" "+%A" 2>/dev/null || echo "Unknown")

    # 替换模板变量
    sed -e "s/{{DATE}}/$DATE/g" \
        -e "s/{{DAY_OF_WEEK}}/$DAY_OF_WEEK/g" \
        -e "s/{{YEAR}}/$(date -j -f "%Y-%m-%d" "$DATE" "+%Y" 2>/dev/null || date +%Y)/g" \
        -e "s/{{MONTH}}/$(date -j -f "%Y-%m-%d" "$DATE" "+%m" 2>/dev/null || date +%m)/g" \
        "$TEMPLATE_FILE" > "$NOTE_FILE"
fi

echo -e "${GREEN}✅ 每日笔记已创建: $NOTE_FILE${NC}"
echo ""

# 尝试获取学习建议（如果 Claude Code 可用）
if command -v claude &> /dev/null; then
    echo -e "${BLUE}🤖 正在分析学习历史并生成建议...${NC}"
    echo ""

    # 这里可以调用 Claude Code 的分析功能
    # 暂时只显示提示信息
    echo "💡 提示: 运行 '/daily-note' 命令获取智能学习建议"
    echo ""
fi

# 显示昨日的笔记（如果存在）
YESTERDAY=$(date -j -v-1d -f "%Y-%m-%d" "$DATE" "+%Y-%m-%d" 2>/dev/null || echo "unknown")
YESTERDAY_NOTE="daily-notes/${YESTERDAY}.md"

if [ -f "$YESTERDAY_NOTE" ]; then
    echo -e "${BLUE}📖 昨日笔记: $YESTERDAY_NOTE${NC}"
    echo "可以参考昨日未完成的目标..."
    echo ""
fi

# 检查今日是否有到期的复习
echo -e "${BLUE}⏰ 复习提醒${NC}"
echo "运行以下命令查看今日复习任务:"
echo "  claude /review --due=today"
echo ""

# 询问是否打开编辑器
read -p "是否现在打开编辑器? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # 尝试使用默认编辑器
    if [ -n "$EDITOR" ]; then
        $EDITOR "$NOTE_FILE"
    elif command -v code &> /dev/null; then
        code "$NOTE_FILE"
    elif command -v vim &> /dev/null; then
        vim "$NOTE_FILE"
    elif command -v open &> /dev/null; then
        open "$NOTE_FILE"
    else
        echo -e "${YELLOW}⚠️  无法自动打开编辑器${NC}"
        echo "文件位置: $(pwd)/$NOTE_FILE"
    fi
fi

echo ""
echo -e "${GREEN}🎯 学习愉快！${NC}"
echo ""
echo "💡 常用命令:"
echo "  /daily-note     - 创建每日笔记"
echo "  /extract [日期] - 提取知识条目"
echo "  /review [主题]  - 复习知识"
