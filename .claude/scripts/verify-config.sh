#!/bin/bash

# SuitAgent 配置一致性检查脚本 - 简化版
# 版本: v1.1
set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 路径
PROJECT_ROOT="/Users/maoking/Library/Application Support/maoscripts/SuitAgent"
TEMPLATE_DIR="$PROJECT_ROOT/.claude/templates/case-templates"

# 错误计数
ERRORS=0

# 旧命名映射（手动定义）
OLD0="01_案件分析"
NEW0="02 - 📄 案件分析"

OLD1="02_法律研究"
NEW1="03 - 🔍 法律研究"

OLD2="03_证据材料"
NEW2="05 - 📎 证据材料"

OLD3="04_法律文书"
NEW3="06 - 📝 法律文书"

OLD4="05_综合报告"
NEW4="10 - 📊 综合报告"

OLD5="06_日程管理"
NEW5="00 - 📅 日程管理"

# 检查单个文件
check_file() {
    local file=$1
    local file_errors=0

    if [[ ! -f "$file" ]]; then
        echo -e "${YELLOW}⚠  文件不存在: $file${NC}"
        return 0
    fi

    # 检查每个模式
    if grep -q "$OLD0" "$file" 2>/dev/null; then
        echo -e "${RED}✗ 发现旧命名: $OLD0${NC}"
        grep -n "$OLD0" "$file" 2>/dev/null | head -3 | sed 's/^/  /'
        ((file_errors++))
        ((ERRORS++))
    fi

    if grep -q "$OLD1" "$file" 2>/dev/null; then
        echo -e "${RED}✗ 发现旧命名: $OLD1${NC}"
        grep -n "$OLD1" "$file" 2>/dev/null | head -3 | sed 's/^/  /'
        ((file_errors++))
        ((ERRORS++))
    fi

    if grep -q "$OLD2" "$file" 2>/dev/null; then
        echo -e "${RED}✗ 发现旧命名: $OLD2${NC}"
        grep -n "$OLD2" "$file" 2>/dev/null | head -3 | sed 's/^/  /'
        ((file_errors++))
        ((ERRORS++))
    fi

    if grep -q "$OLD3" "$file" 2>/dev/null; then
        echo -e "${RED}✗ 发现旧命名: $OLD3${NC}"
        grep -n "$OLD3" "$file" 2>/dev/null | head -3 | sed 's/^/  /'
        ((file_errors++))
        ((ERRORS++))
    fi

    if grep -q "$OLD4" "$file" 2>/dev/null; then
        echo -e "${RED}✗ 发现旧命名: $OLD4${NC}"
        grep -n "$OLD4" "$file" 2>/dev/null | head -3 | sed 's/^/  /'
        ((file_errors++))
        ((ERRORS++))
    fi

    if grep -q "$OLD5" "$file" 2>/dev/null; then
        echo -e "${RED}✗ 发现旧命名: $OLD5${NC}"
        grep -n "$OLD5" "$file" 2>/dev/null | head -3 | sed 's/^/  /'
        ((file_errors++))
        ((ERRORS++))
    fi

    if [[ $file_errors -eq 0 ]]; then
        echo -e "${GREEN}✓ ${file#$PROJECT_ROOT/}${NC}"
    else
        echo -e "${RED}✗ ${file#$PROJECT_ROOT/} - 发现 $file_errors 处问题${NC}"
    fi
}

# 主检查函数
check_all() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}  SuitAgent 配置一致性检查${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""

    # 检查的文件列表
    echo -e "${BLUE}开始检查配置文件...${NC}"

    check_file "$PROJECT_ROOT/CLAUDE.md"
    check_file "$PROJECT_ROOT/.claude/tools/pdf_processor.md"
    check_file "$PROJECT_ROOT/.claude/memory/README.md"
    check_file "$PROJECT_ROOT/.claude/templates/README.md"

    echo ""
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}  检查完成${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""

    if [[ $ERRORS -eq 0 ]]; then
        echo -e "${GREEN}✓ 恭喜！所有配置都一致。${NC}"
        exit 0
    else
        echo -e "${YELLOW}检查结果:${NC}"
        echo -e "  ${RED}错误: $ERRORS${NC}"
        echo ""
        echo -e "${YELLOW}说明：${NC}"
        echo "  脚本检测到配置文件中使用了旧的路径命名格式。"
        echo "  旧格式：01_案件分析、02_法律研究等"
        echo "  新格式：01 - 🤝 委托材料、02 - 📄 案件分析等"
        exit 1
    fi
}

# 帮助信息
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo "SuitAgent 配置一致性检查脚本"
    echo ""
    echo "用法: $0 [--help|--verbose]"
    echo ""
    echo "选项:"
    echo "  --help, -h     显示帮助信息"
    echo "  --verbose, -v  显示详细检查过程"
    exit 0
fi

# 运行检查
check_all
