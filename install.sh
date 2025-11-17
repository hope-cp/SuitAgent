#!/usr/bin/env bash

#############################################################################
# SuitAgent 自动化安装脚本
# 用途：一键安装和配置 SuitAgent 诉讼法律服务智能分析系统
# 作者：SuitAgent Team
# 版本：1.0.0
# 项目地址：https://github.com/cat-xierluo/SuitAgent
#############################################################################

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# 配置变量
SCRIPT_VERSION="1.0.0"
NODE_MIN_VERSION="18.0.0"
PYTHON_MIN_VERSION="3.8.0"
PIP_MIN_VERSION="21.0.0"

# 打印函数
print_header() {
    clear
    echo -e "${PURPLE}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║${WHITE}              SuitAgent 自动化安装向导 v${SCRIPT_VERSION}              ${PURPLE}║${NC}"
    echo -e "${PURPLE}║${WHITE}        诉讼法律服务智能分析系统 - 一键安装配置         ${PURPLE}║${NC}"
    echo -e "${PURPLE}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo
}

print_step() {
    echo -e "\n${CYAN}▸ $1${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ 错误: $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ 警告: $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

print_question() {
    echo -e "\n${WHITE}❓ $1${NC}"
}

# 检查命令是否存在
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# 获取操作系统类型
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if grep -q Microsoft /proc/version 2>/dev/null; then
            echo "wsl"
        else
            echo "linux"
        fi
    elif [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
        echo "windows"
    elif [[ "$OS" == "Windows_NT" ]]; then
        echo "windows"
    else
        echo "unknown"
    fi
}

# 检查 Node.js 版本
check_nodejs() {
    if command_exists node; then
        NODE_VERSION=$(node --version | cut -d'v' -f2)
        REQUIRED_VERSION="18.0.0"

        if [ "$(printf '%s\n' "$REQUIRED_VERSION" "$NODE_VERSION" | sort -V | head -n1)" = "$REQUIRED_VERSION" ]; then
            print_success "Node.js 已安装 (版本: $NODE_VERSION)"
            return 0
        else
            print_warning "Node.js 版本过低 (当前: $NODE_VERSION, 需要: >=$NODE_MIN_VERSION)"
            return 1
        fi
    else
        print_info "Node.js 未安装"
        return 1
    fi
}

# 安装 Node.js (macOS)
install_nodejs_macos() {
    print_step "安装 Node.js (macOS)..."

    if ! command_exists brew; then
        print_warning "需要先安装 Homebrew"
        print_info "正在安装 Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # 配置 Homebrew (Apple Silicon Mac)
        if [[ $(uname -m) == "arm64" ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    fi

    brew install node
    print_success "Node.js 安装完成"
}

# 安装 Node.js (Linux)
install_nodejs_linux() {
    print_step "安装 Node.js (Linux)..."

    if command_exists apt-get; then
        # Ubuntu/Debian
        curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
        sudo apt-get install -y nodejs
    elif command_exists yum; then
        # CentOS/RHEL
        curl -fsSL https://rpm.nodesource.com/setup_lts.x | sudo bash -
        sudo yum install -y nodejs
    else
        print_error "不支持的 Linux 发行版"
        exit 1
    fi

    print_success "Node.js 安装完成"
}

# 安装 Node.js (Windows)
install_nodejs_windows() {
    print_step "安装 Node.js (Windows)..."

    print_info "检测到 Windows 操作系统"
    print_info "推荐以下安装方式："
    echo
    echo -e "  ${CYAN}方式 1 - 使用 Chocolatey (推荐):${NC}"
    echo -e "  1. 先安装 Chocolatey: 打开 PowerShell (管理员)"
    echo -e "     ${YELLOW}Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))${NC}"
    echo -e "  2. 安装 Node.js:"
    echo -e "     ${YELLOW}choco install nodejs${NC}"
    echo
    echo -e "  ${CYAN}方式 2 - 手动下载安装:${NC}"
    echo -e "  1. 访问 ${BLUE}https://nodejs.org/${NC}"
    echo -e "  2. 下载 Windows Installer (.msi)"
    echo -e "  3. 运行安装程序"
    echo
    echo -e "  ${CYAN}方式 3 - 使用 WSL (推荐Linux用户):${NC}"
    echo -e "  在 WSL 终端中重新运行此脚本"
    echo

    print_question "是否已安装 Node.js？ (Y/n): "
    read -r installed

    if [[ ! "$installed" =~ ^[Nn]$ ]]; then
        if check_nodejs; then
            print_success "Node.js 已安装"
            return 0
        fi
    fi

    print_warning "请先安装 Node.js，然后重新运行此脚本"
    print_info "访问: https://nodejs.org/"
    exit 1
}

# 安装 Node.js
install_nodejs() {
    OS=$(detect_os)

    if [[ "$OS" == "macos" ]]; then
        install_nodejs_macos
    elif [[ "$OS" == "linux" || "$OS" == "wsl" ]]; then
        install_nodejs_linux
    elif [[ "$OS" == "windows" ]]; then
        install_nodejs_windows
    else
        print_error "不支持的操作系统: $OS"
        exit 1
    fi
}

# 检查 Python 版本
check_python() {
    if command_exists python3; then
        PYTHON_VERSION=$(python3 --version | cut -d' ' -f2)
        REQUIRED_VERSION=$PYTHON_MIN_VERSION

        if [ "$(printf '%s\n' "$REQUIRED_VERSION" "$PYTHON_VERSION" | sort -V | head -n1)" = "$REQUIRED_VERSION" ]; then
            print_success "Python3 已安装 (版本: $PYTHON_VERSION)"
            return 0
        else
            print_warning "Python3 版本过低 (当前: $PYTHON_VERSION, 需要: >=$PYTHON_MIN_VERSION)"
            return 1
        fi
    else
        print_info "Python3 未安装"
        return 1
    fi
}

# 检查 pip 是否可用
check_pip() {
    if command_exists pip3; then
        PIP_VERSION=$(pip3 --version | cut -d' ' -f2)
        REQUIRED_VERSION=$PIP_MIN_VERSION

        if [ "$(printf '%s\n' "$REQUIRED_VERSION" "$PIP_VERSION" | sort -V | head -n1)" = "$REQUIRED_VERSION" ]; then
            print_success "pip 已安装 (版本: $PIP_VERSION)"
            return 0
        else
            print_warning "pip 版本过低 (当前: $PIP_VERSION, 需要: >=$PIP_MIN_VERSION)"
            return 1
        fi
    else
        print_info "pip 未安装"
        return 1
    fi
}

# 安装系统依赖 (macOS)
install_system_deps_macos() {
    print_step "安装系统依赖 (macOS)..."

    if ! command_exists brew; then
        print_warning "需要先安装 Homebrew"
        print_info "正在安装 Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # 配置 Homebrew (Apple Silicon Mac)
        if [[ $(uname -m) == "arm64" ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    fi

    print_info "正在安装 Tesseract OCR, Poppler, Pandoc, LibreOffice..."
    brew install tesseract poppler pandoc
    brew install --cask libreoffice

    print_success "系统依赖安装完成 (macOS)"
}

# 安装系统依赖 (Linux)
install_system_deps_linux() {
    print_step "安装系统依赖 (Linux)..."

    if command_exists apt-get; then
        # Ubuntu/Debian
        print_info "更新软件包列表..."
        sudo apt-get update -qq

        print_info "安装 Tesseract OCR, Poppler, Pandoc, LibreOffice..."
        sudo apt-get install -y tesseract-ocr poppler-utils pandoc libreoffice

    elif command_exists yum; then
        # CentOS/RHEL
        print_info "安装 Tesseract OCR 和 Poppler..."
        sudo yum install -y tesseract poppler-utils
        print_warning "Pandoc 和 LibreOffice 可能需要手动安装"

    elif command_exists dnf;
    then
        # Fedora
        print_info "安装 Tesseract OCR 和 Poppler..."
        sudo dnf install -y tesseract poppler-utils
        print_warning "Pandoc 和 LibreOffice 可能需要手动安装"

    else
        print_warning "不支持的 Linux 发行版，请手动安装以下软件包："
        echo "  - tesseract-ocr (Tesseract OCR)"
        echo "  - poppler-utils (PDF转图片工具)"
        echo "  - pandoc (文档转换)"
        echo "  - libreoffice (Office文档处理)"
        return 1
    fi

    print_success "系统依赖安装完成 (Linux)"
}

# 安装系统依赖 (Windows)
install_system_deps_windows() {
    print_step "安装系统依赖 (Windows)..."

    print_warning "Windows 用户请手动安装以下软件："
    echo
    echo -e "  ${CYAN}1. Tesseract OCR (OCR文字识别):${NC}"
    echo -e "     ${YELLOW}下载地址:${NC} ${BLUE}https://github.com/UB-Mannheim/tesseract/wiki${NC}"
    echo -e "     ${YELLOW}安装步骤:${NC}"
    echo -e "       - 下载并安装 Tesseract-OCR installer"
    echo -e "       - 记住安装路径 (通常为 C:\\Program Files\\Tesseract-OCR)"
    echo -e "       - 添加到系统 PATH 环境变量"
    echo
    echo -e "  ${CYAN}2. Poppler (PDF处理):${NC}"
    echo -e "     ${YELLOW}下载地址:${NC} ${BLUE}https://blog.alivate.com.au/install-poppler-windows/${NC}"
    echo -e "     ${YELLOW}安装步骤:${NC}"
    echo -e "       - 下载 poppler for Windows"
    echo -e "       - 解压到 C:\\poppler-xx\\"
    echo -e "       - 将 C:\\poppler-xx\\bin 添加到 PATH 环境变量"
    echo
    echo -e "  ${CYAN}3. Pandoc (文档转换):${NC}"
    echo -e "     ${YELLOW}下载地址:${NC} ${BLUE}https://pandoc.org/installing.html${NC}"
    echo -e "     ${YELLOW}安装步骤:${NC}"
    echo -e "       - 下载 Windows installer"
    echo -e "       - 运行安装程序"
    echo
    echo -e "  ${CYAN}4. LibreOffice (Office文档处理):${NC}"
    echo -e "     ${YELLOW}下载地址:${NC} ${BLUE}https://www.libreoffice.org/download/${NC}"
    echo -e "     ${YELLOW}安装步骤:${NC}"
    echo -e "       - 下载 Windows 版本"
    echo -e "       - 运行安装程序"
    echo
    echo -e "  ${CYAN}注意:${NC} 安装完成后需要重启终端使 PATH 生效"

    print_question "是否已完成系统依赖安装？ (Y/n): "
    read -r deps_installed

    if [[ ! "$deps_installed" =~ ^[Nn]$ ]]; then
        return 0
    else
        print_warning "请先安装系统依赖，然后重新运行此脚本"
        return 1
    fi
}

# 安装系统依赖
install_system_deps() {
    OS=$(detect_os)

    if [[ "$OS" == "macos" ]]; then
        install_system_deps_macos
    elif [[ "$OS" == "linux" || "$OS" == "wsl" ]]; then
        install_system_deps_linux
    elif [[ "$OS" == "windows" ]]; then
        install_system_deps_windows
    else
        print_warning "不支持的操作系统: $OS"
        print_info "请手动安装以下软件包："
        echo "  - tesseract-ocr (Tesseract OCR)"
        echo "  - poppler-utils (PDF转图片工具)"
        return 1
    fi
}

# 安装 Python 依赖
install_python_deps() {
    print_step "安装 Python 依赖包..."

    if [ ! -f "requirements.txt" ]; then
        print_error "requirements.txt 文件不存在"
        return 1
    fi

    print_info "正在安装 Python 依赖包 (这可能需要几分钟)..."
    print_info "安装的包: pypdf, python-docx, python-pptx, openpyxl, Pillow, pandas, PyYAML, 等"

    # 升级 pip
    print_info "升级 pip..."
    pip3 install --upgrade pip --quiet

    # 安装依赖
    print_info "安装 Python 依赖包..."
    if pip3 install -r requirements.txt; then
        print_success "Python 依赖包安装完成"
        return 0
    else
        print_error "Python 依赖包安装失败"
        print_info "请检查网络连接或尝试手动安装: pip3 install -r requirements.txt"
        return 1
    fi
}

# 验证 Python 依赖
verify_python_deps() {
    print_step "验证 Python 依赖..."

    local errors=0

    # 测试关键包
    print_info "测试关键包导入..."

    if python3 -c "import pypdf; print('  ✓ pypdf')" 2>/dev/null; then
        print_success "pypdf 验证通过"
    else
        print_error "pypdf 验证失败"
        ((errors++))
    fi

    if python3 -c "import docx; print('  ✓ python-docx')" 2>/dev/null; then
        print_success "python-docx 验证通过"
    else
        print_error "python-docx 验证失败"
        ((errors++))
    fi

    if python3 -c "import pptx; print('  ✓ python-pptx')" 2>/dev/null; then
        print_success "python-pptx 验证通过"
    else
        print_error "python-pptx 验证失败"
        ((errors++))
    fi

    if python3 -c "import openpyxl; print('  ✓ openpyxl')" 2>/dev/null; then
        print_success "openpyxl 验证通过"
    else
        print_error "openpyxl 验证失败"
        ((errors++))
    fi

    if python3 -c "from PIL import Image; print('  ✓ Pillow')" 2>/dev/null; then
        print_success "Pillow 验证通过"
    else
        print_error "Pillow 验证失败"
        ((errors++))
    fi

    if python3 -c "import pandas; print('  ✓ pandas')" 2>/dev/null; then
        print_success "pandas 验证通过"
    else
        print_error "pandas 验证失败"
        ((errors++))
    fi

    if python3 -c "import yaml; print('  ✓ PyYAML')" 2>/dev/null; then
        print_success "PyYAML 验证通过"
    else
        print_error "PyYAML 验证失败"
        ((errors++))
    fi

    # 测试系统依赖
    print_info "测试系统依赖..."

    if command_exists tesseract; then
        print_success "Tesseract OCR 验证通过"
    else
        print_warning "Tesseract OCR 未找到，部分功能可能受限"
    fi

    if command_exists pdftoppm 2>/dev/null || command_exists pdfinfo 2>/dev/null; then
        print_success "Poppler 验证通过"
    else
        print_warning "Poppler 未找到，部分功能可能受限"
    fi

    return $errors
}

# 安装 Claude Code CLI
install_claude_code() {
    print_step "安装 Claude Code CLI..."

    if ! command_exists npm; then
        print_error "npm 未安装，请先安装 Node.js"
        exit 1
    fi

    sudo npm install -g @anthropic-ai/claude-code

    if command_exists claude; then
        CLAUDE_VERSION=$(claude --version 2>/dev/null || echo "unknown")
        print_success "Claude Code CLI 安装完成 (版本: $CLAUDE_VERSION)"
    else
        print_error "Claude Code CLI 安装失败"
        exit 1
    fi
}

# 安装 Zed 编辑器
install_zed_editor() {
    print_step "安装 Zed 编辑器 (可选，推荐新手)"

    if command_exists zed; then
        print_success "Zed 编辑器已安装"
        return 0
    fi

    print_question "是否安装 Zed 编辑器？提供图形化界面和内置终端，新手推荐 (Y/n): "
    read -r install_zed

    if [[ "$install_zed" =~ ^[Nn]$ ]]; then
        print_info "跳过 Zed 编辑器安装"
        return 0
    fi

    OS=$(detect_os)
    print_info "正在安装 Zed 编辑器..."

    if [[ "$OS" == "macos" ]]; then
        # macOS 使用 Homebrew Cask
        if ! command_exists brew; then
            print_warning "需要先安装 Homebrew"
            print_info "正在安装 Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

            # 配置 Homebrew (Apple Silicon Mac)
            if [[ $(uname -m) == "arm64" ]]; then
                echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
                eval "$(/opt/homebrew/bin/brew shellenv)"
            fi
        fi

        # 添加 Zed 的 Homebrew Cask
        brew tap homebrew/cask
        brew install --cask zed
        print_success "Zed 编辑器安装完成 (macOS)"

    elif [[ "$OS" == "linux" || "$OS" == "wsl" ]]; then
        # Linux 下载 AppImage
        ZED_VERSION=$(curl -s https://api.github.com/repos/zed-industries/zed/releases/latest | grep -o '"tag_name": "v[^"]*"' | cut -d'"' -f4)
        ZED_URL="https://github.com/zed-industries/zed/releases/download/${ZED_VERSION}/zed-linux-$(uname -m).tar.xz"

        TMP_DIR=$(mktemp -d)
        cd "$TMP_DIR"

        print_info "正在下载 Zed 编辑器..."
        wget -q "$ZED_URL" -O zed.tar.xz

        print_info "正在安装..."
        tar -xf zed.tar.xz
        mv zed ~/.local/bin/zed

        # 添加到 PATH（如果不存在）
        if ! grep -q '~/.local/bin' ~/.bashrc 2>/dev/null; then
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
            export PATH="$HOME/.local/bin:$PATH"
        fi

        rm -rf "$TMP_DIR"
        print_success "Zed 编辑器安装完成 (Linux)"

    elif [[ "$OS" == "windows" ]]; then
        # Windows 下载 .exe 安装包
        print_warning "Windows 上请使用以下方式安装 Zed:"
        echo
        echo -e "  ${CYAN}方式 1 - 手动下载 (推荐):${NC}"
        echo -e "  1. 访问 ${BLUE}https://zed.dev/download${NC}"
        echo -e "  2. 下载 Windows 版本"
        echo -e "  3. 运行安装程序"
        echo
        echo -e "  ${CYAN}方式 2 - 使用 Chocolatey:${NC}"
        echo -e "  ${YELLOW}choco install zed${NC}"
        echo
        echo -e "  ${CYAN}方式 3 - 使用 Scoop:${NC}"
        echo -e "  ${YELLOW}scoop install zed${NC}"
        echo

        print_question "是否已安装 Zed 编辑器？ (Y/n): "
        read -r installed_zed

        if [[ ! "$installed_zed" =~ ^[Nn]$ ]]; then
            if command_exists zed; then
                print_success "Zed 编辑器已安装"
            else
                print_warning "请先安装 Zed 编辑器"
            fi
        fi

    else
        print_warning "不支持的操作系统，请手动下载 Zed: https://zed.dev/download"
        return 1
    fi

    # 验证安装
    if command_exists zed; then
        print_success "Zed 编辑器验证通过"
    else
        print_warning "Zed 编辑器安装可能未成功，请手动下载: https://zed.dev/download"
    fi
}

# 在 Zed 中打开项目
open_in_zed() {
    if ! command_exists zed; then
        return 1
    fi

    print_question "是否现在在 Zed 中打开 SuitAgent 项目？ (Y/n): "
    read -r open_zed

    if [[ "$open_zed" =~ ^[Nn]$ ]]; then
        return 0
    fi

    print_info "正在在 Zed 中打开项目..."
    CURRENT_DIR=$(pwd)

    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        open -a Zed "$CURRENT_DIR"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        nohup zed "$CURRENT_DIR" >/dev/null 2>&1 &
    else
        # Windows 或其他
        zed "$CURRENT_DIR" 2>/dev/null &
    fi

    print_success "已尝试在 Zed 中打开项目"
}

# 选择 AI 模型供应商
select_ai_provider() {
    print_step "选择 AI 模型供应商"

    echo -e "\n${WHITE}可用的 AI 模型供应商:${NC}"
    echo -e "  ${GREEN}1.${NC} ${CYAN}智谱AI${NC} - GLM-4.6 (推荐 ⭐⭐⭐⭐⭐)"
    echo -e "  ${GREEN}2.${NC} ${CYAN}月之暗面${NC} - kimi-k2-turbo (推荐 ⭐⭐⭐⭐⭐)"
    echo -e "  ${GREEN}3.${NC} ${CYAN}MiniMax${NC} - MiniMax-M2 (免费 ⭐⭐⭐⭐)"
    echo -e "  ${GREEN}4.${NC} ${CYAN}DeepSeek${NC} - DeepSeek-V3.2 (推荐 ⭐⭐⭐⭐)"
    echo -e "  ${GREEN}5.${NC} ${CYAN}退出安装${NC}"

    while true; do
        print_question "请选择 (1-5): "
        read -r choice

        case $choice in
            1)
                PROVIDER="zhipu"
                print_info "选择了智谱AI - GLM-4.6"
                break
                ;;
            2)
                PROVIDER="moonshot"
                print_info "选择了月之暗面 - kimi-k2-turbo"
                break
                ;;
            3)
                PROVIDER="minimax"
                print_info "选择了 MiniMax - MiniMax-M2"
                break
                ;;
            4)
                PROVIDER="deepseek"
                print_info "选择了 DeepSeek - DeepSeek-V3.2"
                break
                ;;
            5)
                print_info "安装已取消"
                exit 0
                ;;
            *)
                print_error "无效选择，请输入 1-5"
                ;;
        esac
    done
}

# 获取 API 密钥
get_api_key() {
    print_step "配置 API 密钥"

    case $PROVIDER in
        zhipu)
            print_info "智谱AI开放平台: https://open.bigmodel.cn/"
            print_info "请在控制台获取 API Key"
            ;;
        moonshot)
            print_info "月之暗面开放平台: https://platform.moonshot.cn/"
            print_info "请在控制台获取 API Key"
            ;;
        minimax)
            print_info "MiniMax开放平台: https://www.minimaxi.com/"
            print_info "请在控制台获取 API Key"
            ;;
        deepseek)
            print_info "DeepSeek开放平台: https://platform.deepseek.com/"
            print_info "请在控制台获取 API Key"
            ;;
    esac

    while true; do
        print_question "请输入 API Key (输入 'q' 取消): "
        read -rs API_KEY

        if [[ "$API_KEY" == "q" || "$API_KEY" == "Q" ]]; then
            print_info "安装已取消"
            exit 0
        fi

        if [ -z "$API_KEY" ]; then
            print_error "API Key 不能为空"
        else
            break
        fi
    done
}

# 生成配置文件
generate_config() {
    print_step "生成配置文件..."

    # 确保目录存在
    mkdir -p .claude

    # 根据供应商生成配置
    case $PROVIDER in
        zhipu)
            cat > .claude/settings.local.json <<EOF
{
  "env": {
    "ANTHROPIC_AUTH_TOKEN": "$API_KEY",
    "ANTHROPIC_BASE_URL": "https://open.bigmodel.cn/api/anthropic",
    "ANTHROPIC_MODEL": "GLM-4.6",
    "ANTHROPIC_SMALL_FAST_MODEL": "GLM-4.6"
  }
}
EOF
            ;;
        moonshot)
            cat > .claude/settings.local.json <<EOF
{
  "env": {
    "ANTHROPIC_AUTH_TOKEN": "$API_KEY",
    "ANTHROPIC_BASE_URL": "https://api.moonshot.cn/anthropic",
    "ANTHROPIC_MODEL": "kimi-k2-turbo-preview",
    "ANTHROPIC_SMALL_FAST_MODEL": "kimi-k2-turbo-preview"
  }
}
EOF
            ;;
        minimax)
            cat > .claude/settings.local.json <<EOF
{
  "env": {
    "ANTHROPIC_AUTH_TOKEN": "$API_KEY",
    "ANTHROPIC_BASE_URL": "https://api.minimaxi.com/anthropic",
    "ANTHROPIC_MODEL": "MiniMax-M2",
    "ANTHROPIC_SMALL_FAST_MODEL": "MiniMax-M2"
  }
}
EOF
            ;;
        deepseek)
            cat > .claude/settings.local.json <<EOF
{
  "env": {
    "ANTHROPIC_AUTH_TOKEN": "$API_KEY",
    "ANTHROPIC_BASE_URL": "https://api.deepseek.com/anthropic",
    "ANTHROPIC_MODEL": "DeepSeek-V3.2-Exp",
    "ANTHROPIC_SMALL_FAST_MODEL": "DeepSeek-V3.2-Exp"
  }
}
EOF
            ;;
    esac

    print_success "配置文件已生成: .claude/settings.local.json"
}

# 验证安装
verify_installation() {
    print_step "验证安装..."

    local errors=0

    # 检查 Node.js
    if check_nodejs; then
        print_success "Node.js 验证通过"
    else
        print_error "Node.js 验证失败"
        ((errors++))
    fi

    # 检查 npm
    if command_exists npm; then
        NPM_VERSION=$(npm --version)
        print_success "npm 验证通过 (版本: $NPM_VERSION)"
    else
        print_error "npm 未安装"
        ((errors++))
    fi

    # 检查 Python3
    if check_python; then
        print_success "Python3 验证通过"
    else
        print_error "Python3 验证失败"
        ((errors++))
    fi

    # 检查 pip
    if check_pip; then
        print_success "pip 验证通过"
    else
        print_error "pip 验证失败"
        ((errors++))
    fi

    # 检查 Python 依赖包
    if verify_python_deps; then
        print_success "Python 依赖包验证通过"
    else
        print_error "Python 依赖包验证失败"
        ((errors++))
    fi

    # 检查 Claude Code
    if command_exists claude; then
        print_success "Claude Code CLI 验证通过"
    else
        print_error "Claude Code CLI 验证失败"
        ((errors++))
    fi

    # 检查配置文件
    if [ -f ".claude/settings.local.json" ]; then
        print_success "配置文件验证通过"
    else
        print_error "配置文件验证失败"
        ((errors++))
    fi

    return $errors
}

# 显示启动指南
show_startup_guide() {
    echo
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║${WHITE}                      安装完成！                       ${GREEN}║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo
    echo -e "${WHITE}快速开始:${NC}"
    echo
    echo -e "  ${CYAN}1.${NC} 启动 SuitAgent (两种方式):"
    echo -e "     ${YELLOW}方式A - 使用终端:${NC}"
    echo -e "     claude"
    echo
    if command_exists zed; then
        echo -e "     ${YELLOW}方式B - 使用 Zed 编辑器:${NC}"
        echo -e "     zed ."
        echo -e "     (在 Zed 中按 ${PURPLE}Cmd + \`${NC} 打开终端)"
    fi
    echo
    echo -e "  ${CYAN}2.${NC} 系统支持以下功能:"
    echo -e "     ${GREEN}✓${NC} PDF 文档处理与 OCR 识别"
    echo -e "     ${GREEN}✓${NC} Word/Excel/PPT 文档分析"
    echo -e "     ${GREEN}✓${NC} Markdown 与 Word 互转"
    echo -e "     ${GREEN}✓${NC} 自动化法律文书生成"
    echo
    echo -e "  ${CYAN}3.${NC} 上传法律文档或描述需求，例如:"
    echo -e "     ${YELLOW}• "我收到起诉状，需要应诉"${NC}"
    echo -e "     ${YELLOW}• "有新证据需要质证"${NC}"
    echo -e "     ${YELLOW}• "需要起草答辩状"${NC}"
    echo
    echo -e "  ${CYAN}4.${NC} 系统会自动执行分析并生成文书"
    echo
    echo -e "${WHITE}更多信息:${NC}"
    echo -e "  • 详细文档: ${BLUE}README.md${NC}"
    echo -e "  • 安装指南: ${BLUE}INSTALL.md${NC}"
    echo -e "  • 快速开始: ${BLUE}QUICKSTART.md${NC}"
    echo -e "  • 依赖列表: ${BLUE}requirements.txt${NC}"
    echo -e "  • Claude Code: ${BLUE}https://docs.anthropic.com/claude-code${NC}"
    echo
}

# 主函数
main() {
    print_header

    echo -e "${WHITE}欢迎使用 SuitAgent 自动化安装向导！${NC}"
    echo -e "\n${WHITE}本向导将帮助您:${NC}"
    echo -e "  ${CYAN}1.${NC} 检查并安装必要的依赖 (Node.js, Python3, pip)"
    echo -e "  ${CYAN}2.${NC} 安装系统依赖 (Tesseract OCR, Poppler)"
    echo -e "  ${CYAN}3.${NC} 安装 Python 依赖包"
    echo -e "  ${CYAN}4.${NC} 安装 Claude Code CLI"
    echo -e "  ${CYAN}5.${NC} 选择并配置 AI 模型供应商"
    echo -e "  ${CYAN}6.${NC} 验证安装结果"
    echo

    print_question "是否开始安装? (Y/n): "
    read -r confirm

    if [[ "$confirm" =~ ^[Nn]$ ]]; then
        print_info "安装已取消"
        exit 0
    fi

    # 开始安装流程
    print_step "开始安装 SuitAgent..."

    # 检查系统
    OS=$(detect_os)
    print_info "检测到操作系统: $OS"
    echo

    # 检查并安装 Node.js
    if ! check_nodejs; then
        print_info "正在安装 Node.js..."
        install_nodejs

        # 重新检查
        if ! check_nodejs; then
            print_error "Node.js 安装失败"
            exit 1
        fi
    fi

    # 检查并安装 Python3 和 pip
    if ! check_python; then
        print_info "Python3 未安装或版本过低"
        print_warning "请先安装 Python3 (>= $PYTHON_MIN_VERSION)"
        print_info "推荐安装方式:"
        echo -e "  ${CYAN}macOS:${NC} ${YELLOW}brew install python3${NC}"
        echo -e "  ${CYAN}Ubuntu/Debian:${NC} ${YELLOW}sudo apt-get install python3 python3-pip python3-venv${NC}"
        echo -e "  ${CYAN}Windows:${NC} ${YELLOW}从 https://python.org 下载安装${NC}"
        print_warning "安装 Python3 后，请重新运行此脚本"
        exit 1
    fi

    # 检查 pip
    if ! check_pip; then
        print_info "正在安装 pip..."
        python3 -m ensurepip --upgrade
        if ! check_pip; then
            print_error "pip 安装失败"
            print_info "请手动安装: sudo apt-get install python3-pip (Ubuntu/Debian) 或 brew install python3 (macOS)"
            exit 1
        fi
    fi

    # 安装系统依赖 (Tesseract OCR, Poppler, Pandoc, LibreOffice)
    print_step "安装系统依赖..."
    if install_system_deps; then
        print_success "系统依赖安装完成"
    else
        print_warning "系统依赖安装可能不完整，部分功能可能受限"
    fi

    # 安装 Python 依赖包
    if install_python_deps; then
        print_success "Python 依赖包安装完成"
    else
        print_error "Python 依赖包安装失败"
        exit 1
    fi

    # 安装 NPM 全局包 (pptxgenjs, markitdown, sharp)
    print_step "安装 NPM 全局包..."
    print_info "正在安装: pptxgenjs, markitdown, sharp"
    npm install -g pptxgenjs markitdown sharp 2>/dev/null || {
        print_warning "部分 NPM 包安装可能失败，但不影响核心功能"
    }
    print_success "NPM 全局包安装完成"

    # 安装 Claude Code CLI
    install_claude_code

    # 安装 Zed 编辑器（可选）
    install_zed_editor

    # 选择 AI 供应商
    select_ai_provider

    # 获取 API 密钥
    get_api_key

    # 生成配置文件
    generate_config

    # 验证安装
    echo
    if verify_installation; then
        # 在 Zed 中打开项目（如果用户选择）
        open_in_zed
        show_startup_guide
    else
        print_error "安装过程中出现错误，请检查日志"
        exit 1
    fi
}

# 执行主函数
main "$@"
