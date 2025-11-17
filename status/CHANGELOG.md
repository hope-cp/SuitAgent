# 变更记录

> Last updated: 2025-11-14
> 所有对用户或其他协作者有影响的变更都会在此记录。使用 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.0.0/) 格式。

---

## [v0.3.0] - 2025-11-14

### 🚀 新增功能 (Added)
- **🆕 委托文件生成系统整合**
  - 成功整合独立的委托文件生成系统到SuitAgent工作流
  - 新增 `.claude/tools/placeholder_mapper.py` - 字段映射工具 (348行)
  - 新增 `.claude/tools/DocxProcessor.py` - Word文档处理引擎 (365行)
  - 新增 `.claude/tools/docx_tools.py` - 便捷调用接口 (304行)
  - 支持14个核心字段的自动映射
  - 支持公司和个人两种委托类型

- **🆕 委托确定工作流**
  - 新增完整"委托确定"场景工作流
  - 支持5个核心委托文件自动生成
  - 集成DocAnalyzer → Writer → Summarizer → Reporter自动化流程
  - 可通过自然语言触发："我需要制作委托材料"

- **🆕 模板资源库**
  - 新增 `.claude/templates/公司委托模板/` - 9个Word模板
  - 新增 `.claude/templates/个人委托模板/` - 8个Word模板
  - 支持自动模板选择和批量生成
  - 保持Word文档原始格式（字体、颜色、对齐等）

- **🆕 集成测试套件**
  - 新增 `tests/test_integration.py` - 完整测试套件 (452行)
  - 覆盖字段映射、YAML验证、模板发现、批量生成等场景
  - 提供颜色输出和详细测试报告

### 🔧 改进 (Changed)
- **Writer Agent扩展**
  - 更新 `.claude/agents/Writer.md`，添加委托文件生成功能
  - 新增15种文书类型（包含Word格式委托文件）
  - 集成自动工作流触发机制
  - 支持Markdown和Word双格式输出

- **目录结构优化**
  - 精简 `.claude/memory/` 目录，减少上下文污染60%
  - 将可引用文件移至 `.claude/tools/`、`.claude/templates/`、`docs/`、`output/`
  - memory目录仅保留必要文件：integration/、workflows/
  - 上下文大小从~500KB减少到~200KB

- **文档体系增强**
  - 新增 `docs/委托文件生成系统整合报告.md` - 完整整合报告 (11KB)
  - 新增 `.claude/memory/integration/字段对照表.md` - 字段映射规范
  - 新增 `.claude/memory/integration/工具使用指南.md` - API文档
  - 新增 `.claude/memory/integration/委托确定工作流.md` - 工作流说明
  - 新增 `.claude/memory/integration/目录结构优化.md` - 优化说明
  - 新增 `.claude/memory/integration/整合工作总结.md` - 工作总结

### 🔒 性能优化 (Optimized)
- **上下文优化**
  - memory目录文件减少60%（从~50个到~20个）
  - 上下文大小减少60%（从~500KB到~200KB）
  - 响应速度显著提升
  - 成本显著降低

- **文件组织优化**
  - 按功能分类存放文件：tools/（工具）、templates/（模板）、docs/（文档）
  - 通过路径引用使用，无需加载到上下文
  - 统一的模板管理 `.claude/templates/`
  - 清晰的目录层次结构

### 🐛 修复 (Fixed)
- 修复了工具文件相对导入问题，使用 `.claude/tools/` 内部导入
- 更新了所有文档中的路径引用，从 `.claude/memory/` 迁移到新位置
- 修复了批量生成函数的模板目录选择逻辑

### 📋 技术细节 (Technical)
- **核心技术**: 基于 `word_template_processor.py` 的字符级精确替换
- **算法优化**: Run级别操作保持Word格式，反向迭代避免索引偏移
- **字段映射**: 14个核心字段（委托人、律师、案件、日期信息）
- **模板类型**: 支持公司委托（9种文件）和个人委托（8种文件）
- **输出格式**: Word(.docx) + Markdown(.md) 双格式支持
- **工作流步骤**: 4步自动化（客户确认 → 委托文件 → 清单摘要 → 完整报告）

### 📖 文档更新 (Documentation)
- `docs/委托文件生成系统整合报告.md` - v1.0，完整整合报告
- `status/CHANGELOG.md` - 记录 v0.3.0 所有变更
- `status/JOURNAL.md` - 添加整合工作日志
- `status/TASKS.md` - 更新任务完成状态
- `CLAUDE.md` - 更新场景7说明，新增Word格式委托文件特性

### ⚠️ 破坏性变更 (Breaking Changes)
- **工具路径变更**: 原 `tools/*.py` 移至 `.claude/tools/*.py`
- **模板路径变更**: 原 `.claude/memory/公司委托模板/` 移至 `.claude/templates/公司委托模板/`
- **导入路径变更**: 工具内部导入使用相对路径 `from .xxx import xxx`

### 📌 迁移指南 (Migration)
- 更新所有引用 `tools/*.py` 的代码为 `.claude/tools/*.py`
- 更新模板路径从 `.claude/memory/委托模板/` 到 `.claude/templates/委托模板/`
- 安装新依赖: `pip install python-docx pyyaml`

---

## [v0.2.0] - 2025-11-11

### 🚀 新增功能 (Added)
- **🆕 自动化安装脚本系统**
  - 新增 `install.sh` 交互式安装向导
  - 支持一键安装 Node.js、Claude Code CLI、Zed 编辑器
  - 完整支持 macOS、Linux、Windows (PowerShell/CMD/WSL)
  - 智能系统检测，自动选择最佳安装方式
  - 支持 4 大 AI 模型平台：智谱AI、月之暗面、MiniMax、DeepSeek
  - API 密钥安全输入（密码模式），自动生成配置文件
  - 安装后完整验证，确保所有组件正常工作

- **🆕 完整文档体系**
  - 新增 `INSTALL.md` - 详细安装指南 (11KB)
  - 新增 `QUICKSTART.md` - 一分钟快速开始 (1.2KB)
  - 更新 `README.md` - 集成自动化安装说明

### 🔧 改进 (Changed)
- **更新 ROADMAP.md 至 v2.3**
  - 新增"阶段1.5：安装体验优化"
  - 当前阶段调整为"核心功能增强"
  - 添加自动化安装系统完成状态记录

### 📋 技术细节 (Technical)
- **跨平台支持矩阵**：
  - macOS: Homebrew 自动安装
  - Linux: apt/yum 包管理器支持
  - Windows: PowerShell + Chocolatey + WSL 三种方式
  - WSL: 完整 Linux 体验支持

- **安装流程优化**：
  - 系统检测 → 依赖安装 → CLI 安装 → AI 配置 → Zed 安装 → 项目打开 → 验证完成
  - 全程交互式向导，用户只需按提示操作
  - 错误处理和重试机制，提升安装成功率

### 📖 文档更新 (Documentation)
- `docs/ROADMAP.md` - v2.3，添加安装体验优化阶段
- `status/CHANGELOG.md` - 记录 v0.2.0 所有变更
- `status/TASKS.md` - 已完成安装相关任务
- `README.md` - 新增自动化安装章节

---

## [未发布] - 待定

### 📝 文档优化 (Documentation Optimization)
- **精简CLAUDE.md"常见使用场景"部分**
  - **精简内容**：删除场景8-15（保全申请、上诉材料、法律意见书、律师函、强制执行、调解协议、异议申请等）
  - **保留核心**：只保留7个最常用场景（被告应诉、新证据质证、庭审后分析、诉前沟通、策略优化、原告起诉、制作委托材料）
  - **更新表格**：同步精简自动识别规则表格，移除不常用场景
  - **效果**：显著减少文档长度，提升可读性和维护性

### 🔧 架构修复 (Architecture Fixes)
- **修复PDF处理工作流程绕过DocAnalyzer的关键问题**
  - **问题描述**：用户上传PDF时系统直接使用PDF技能，绕过DocAnalyzer Agent，导致架构违规和错误处理
  - **解决方案**：
    - 修正DocAnalyzer配置，明确PDF处理职责和双格式输出要求
    - 创建文档处理强制工作流程规范 (`DOCUMENT_PROCESSING_ENFORCEMENT.md`)
    - 在CLAUDE.md中添加文档处理强制规范章节
    - 记录架构决策 #020
  - **工作流程**：
    - 错误：用户上传PDF → 直接使用PDF技能 ❌
    - 正确：用户上传PDF → DocAnalyzer Agent → 使用pdf技能 → 返回PDF+MD+JSON ✅
  - **核心要求**：所有PDF文档必须通过DocAnalyzer处理，必须返回带文字层的PDF和Markdown文件，OCR准确率需达95%+

### 重大更新 (Major Updates)
- **Agents架构重大升级 v2.0 - 符合Claude Code官方标准**
  - **新增双层架构设计**：
    - 使用层 (`.claude/agents/`)：标准subagent配置，符合Claude Code官方规范
    - 知识层 (`.claude/memory/workflows/`)：详细工作流程，便于开发优化
  - **标准化所有10个agents**：
    - 添加YAML frontmatter配置（name, description, tools, model, color）
    - 移除非标准tools配置（pdf, docx, xlsx等），避免"Unrecognized"警告
    - 优化模型选择和temperature参数
    - 配置8种颜色区分agents（2个agents共享颜色）
  - **保留完整设计文档**：
    - 10个详细工作流程文件完整迁移至workflows目录
    - 保留所有功能定位、JSON配置、性能指标、质量验证等
    - 创建COLOR-GUIDE.md说明颜色分配原则
  - **创建说明文档**：
    - AGENTS-CONVERSION-SUMMARY.md：转换总结
    - AGENTS-FINAL-COLOR-CONFIG.md：颜色配置完成文档
  - **优势**：完全符合官方标准，可直接使用/agents命令管理，保持专业设计完整性
- **ROADMAP.md重大版本更新 v2.2**
  - **新增目标5：专业化法律技能库建设**
    - 建立案件专业化分析模板库：医疗纠纷、知识产权、建筑工程、合同纠纷、劳动争议等专项模板
    - 构建证据需求清单库：各类案件的标准化证据清单，包括基础证据、关键证据、辅助证据
    - 完善法律要点知识库：核心法条库、争议焦点分析框架、典型案例参考库
  - **新增目标6：法律文书模板系统优化**
    - 建立答辩意见要点模板库：标准答辩框架、不同案件类型答辩策略、律师自定义添加机制
    - 开发委托文档自动生成系统：预设委托合同模板库、基于Skills的自动生成功能
    - 实现Markdown转Doc文档功能：基于docx skill的转换引擎、自动排版格式化、批量转换
  - **新增目标7：命令脚本系统**
    - 构建简单命令执行框架：案件管理、文档处理、工作流、Agent控制等常用命令集合
    - 集成Hooks机制：文件生成后自动转换、自定义脚本、插件式扩展、自动化质量检查
    - 实现脚本化工作流执行和批处理任务支持
  - **完善目标4：案件基础信息与工作记录模板持续优化**
    - 详细规划数据可视化支持：案件进度甘特图、工时统计图表、期限倒计时显示、风险等级可视化
    - **扩展跨案件数据汇总：新增统一数据看板🆕**
      - 自动扫描所有案件YAML文件，生成统一数据索引
      - 支持列表视图、卡片视图、甘特图视图
      - 多维度筛选：案件类型、负责人、状态、时间
      - 智能数据洞察：预测分析、资源优化、效率提升建议
    - 建立模板持续迭代机制：反馈收集、结构优化、新字段扩展、版本管理

### 新增 (Added)

- **案件PDF扫描OCR处理能力**
  - 实现PDF扫描件OCR文字提取，使用tesseract + ImageMagick技术
  - 成功提取起诉状全文内容，生成带文字层的PDF和Markdown文件
  - 建立OCR质量优化流程：图像预处理、拼写检查、格式校正

- **日程管理目录精简优化**
  - 删除不必要的文件：客户沟通记录、费用跟踪、庭审安排、风险预警、README等
  - 保留3个核心文件：工时记录.md、期限管理.md、重要任务清单.md
  - 将[案件编号].yaml移回06_日程管理/目录
  - [案件编号].md保留在案件根目录
  - 贯彻"Less is more"理念，精简高效

- **案件看板位置优化与日程管理内容扩展**
  - 将案件看板（[案件编号].yaml和[案件编号].md）移动到案件根目录，便于查看和使用
  - 从案件看板抽取重要任务清单为独立文档：重要任务清单.md
  - 从案件看板抽取期限管理为独立文档：期限管理.md
  - 新增客户沟通记录.md，记录与客户的日常沟通情况
  - 新增费用跟踪.md，跟踪案件相关费用开支
  - 新增庭审安排.md，记录庭审安排和准备清单
  - 新增风险预警.md，记录和管理案件风险点
  - 扩展日程管理内容从2个文件到9个文件，形成完整的案件管理工具集

- **Agent输出路径标准化实施完成**
  - 完成标准目录结构创建：output/cases/[案件编号]/01-06完整目录
  - 创建Writer 12个法律文书子目录：起诉状、答辩状、代理词等
  - 建立YAML和MD模板文件：案件数据总表、工作记录模板
  - 创建实施指南文档：OUTPUT_PATH_STANDARDIZATION.md
  - 生成示例文档：案件分析报告、法律文书样例、操作日志
  - 建立路径分配工具函数和YAML自动更新机制

- **全面更新项目规划文档**
  - 创建新版roadmap (ROADMAP_NEW.md)，反映9个Agent已完成、当前处于文档管理优化阶段
  - 创建新版task清单 (TASKS_NEW.md)，定义阶段0-3的完整规划，聚焦文档管理优化
  - 重新定位项目现状：9个AI代理已完成，核心功能完整，当前阶段为文档管理优化

- **Agent输出文档管理规范**
  - 创建完整输出路径规范 (AGENT_OUTPUT_MANAGEMENT.md)
  - 定义9个Agent的输出路径映射：01-06目录分配、12种文书分类
  - 建立文档命名规范：[日期]_[类型]_[版本]格式
  - 设计智能路径分配机制：案号识别、案件匹配、冲突处理
  - 实现数据同步机制：YAML自动更新、MD工作记录同步

- **YAML数据总表模板优化**
  - 创建统一数据总表模板 (YAML_DATA_TEMPLATE.md)
  - 整合16个部分：基础信息、当事人、律师、费用、进展、时间线、期限、工时、工作记录、风险、文档、数据分析、项目管理、扩展字段、系统信息
  - 支持双版本设计：YAML用于看板数据，MD用于工作记录
  - 实现数据可视化支持：进度看板、工时统计图表、期限预警
  - 提供完整使用指南和最佳实践

- **智能案件识别系统**
  - 设计智能识别系统 (INTELLIGENT_CASE_RECOGNITION.md)
  - 实现案号识别算法：支持标准/简化/无括号格式，提取年份、地区、类型、序号
  - 建立文件类型识别规则：15种文档类型的关键词和特征匹配
  - 设计案件匹配算法：完全匹配/部分匹配/模糊匹配三级匹配
  - 实现新案件自动创建：目录结构、yaml模板、工作记录模板
  - 建立冲突处理机制：重复案件检测、文件冲突解决
  - 提供完整工作流程图和代码实现

- **Agent输出路径配置指南**
  - 创建Agent输出配置指南 (AGENT_OUTPUT_PATHS_CONFIG.md)
  - 为9个Agent提供具体输出实现：DocAnalyzer、EvidenceAnalyzer、IssueIdentifier、Researcher、Strategist、Writer、Summarizer、Reporter、Scheduler
  - 定义输出内容：每种Agent的文档类型、文件名格式、扩展名
  - 实现完整工具函数：路径生成、文件名创建、YAML更新、日志记录
  - 提供使用示例：每种Agent的调用方式和返回结果
  - 支持Writer 12种子类型：起诉状、答辩状、代理词等分类存储

- **创建长期优化规划文档**
  - 创建长期优化规划 (LONG_TERM_OPTIMIZATION_PLAN.md)
  - 定义四大优化方向：Claude Code高级功能、技能库完善、插件生态扩展、MCP工具集成
  - 详细规划Memories系统：案件上下文记忆、律师个人偏好学习、知识库记忆与智能推荐
  - 设计MCP工具集成方案：法院系统MCP、律所系统MCP、法律知识库MCP、云存储MCP
  - 制定插件生态扩展计划：法律专用插件、可视化插件、数据导入插件、第三方集成插件
  - 建立实施路线图：分阶段实施、技术架构设计、风险评估与应对、预算估算

- **Claude Code高级功能深度研究**
  - 创建高级功能研究报告 (CLAUDE_CODE_ADVANCED_FEATURES_RESEARCH.md)
  - 深度研究Memories上下文记忆系统：记忆存储架构、记忆分类标记、案件记忆空间设计
  - 全面分析MCP工具集成方案：法院系统MCP服务器实现、律所管理MCP集成、法律知识库MCP设计
  - 详细设计高级指令模板系统：完整案件分析模板、模板执行引擎、模板使用示例
  - 探索多模态处理能力：文本OCR增强、图像证据分析、音频庭审处理、视频庭审分析
  - 提供完整代码实现：MCP服务器开发、客户端集成模式、错误处理与重试机制
  - 制定实施建议与总结：优先级建议、技术路线图、风险控制、成功指标

- **项目路线图整合与优化**
  - 将长期优化规划全面整合到新版roadmap中，包含Claude Code高级功能、Skills知识库、插件生态、MCP工具四大方向
  - 按照用户指示调整MCP工具集成描述，留空作为未来展望展示，不涉及具体实现方案
  - 删除老版本ROADMAP.md文件，重命名ROADMAP_NEW.md为ROADMAP.md
  - 完善长期规划内容：Memories上下文记忆、高级指令模板、多模态处理、API集成等

- **记忆分层系统架构设计**
  - 在ARCHITECTURE.md中添加"记忆分层系统"章节，详细描述基于Claude Code架构的三层记忆设计
  - 定义案件级记忆、个人级记忆、系统级记忆的位置、内容、访问方式和更新机制
  - 在ROADMAP.md中新增"优化方向0：记忆分层系统建设（基础架构）"，将记忆分层系统列入长期规划
  - 建立记忆分层系统的理论基础，为后续Agent智能化协作提供基础支持

- **文档结构优化与整合**
  - 删除已整合的LONG_TERM_OPTIMIZATION_PLAN.md文档
  - 合并AGENT_OUTPUT_PATHS_CONFIG.md到AGENT_OUTPUT_MANAGEMENT.md，添加技术实现详解章节
  - 合并YAML_DATA_TEMPLATE.md到INTELLIGENT_CASE_RECOGNITION.md，添加YAML数据模板章节
  - 创建docs/research/文件夹，将CLAUDE_CODE_ADVANCED_FEATURES_RESEARCH.md移动到专门的研究文档夹
  - docs文件夹文档数量从10个减少到6个，大大简化文档结构
  - 保持文档层次结构：核心文档在根目录，详细研究在research子目录

- **优化案件文档管理结构（目录整合+双版本设计+简洁命名）**
  - 重新整合目录结构：9个目录精简为6个，按工作流相关性合并
    - 争议焦点+法律研究 → "02_法律研究"
    - 案件分析+策略规划 → "01_案件分析"
    - 报告摘要+综合报告 → "05_综合报告"
    - 期限工时管理 → "06_日程管理"
  - 创建日程管理双版本设计（Scheduler输出增强）
    - YAML版本：[案件编号].yaml 支持案件管理看板和数据分析
    - MD版本：[案件编号].md 支持工作记录和日常查看
    - 工作记录模板.md 提供标准化记录格式
  - 添加新材料自动分类指引（DocAnalyzer增强功能）
    - 材料归属识别（案号提取、案件匹配、新案件创建）
    - 材料类型分析（6种材料类型的识别特征和放置位置）
    - 自动放置流程（input → DocAnalyzer → 自动分类 → 放置）
    - 批量处理支持（ZIP、多文件、OCR识别）
    - 命名规范应用（自动重命名、版本管理、冲突处理）
    - 上下文更新（yaml/md文件更新、进度标记）
    - 完整示例操作流程演示
  - 添加PDF扫描处理指引（DocAnalyzer OCR增强）
    - PDF扫描与OCR识别（文字层提取、OCR识别、准确率95%+、多语言支持）
    - 双格式输出设计（带文字层的PDF + Markdown文件）
    - 质量优化机制（预处理、后处理、人工校对、质量报告）
    - 支持法律文档场景（扫描合同、法院传票、证据材料、判决书）
    - 完整示例操作流程演示
  - 编写完整的目录使用说明（README.md）
  - 更新所有相关文档反映新的目录结构
- **规范化案件文档管理结构**
  - 创建output/cases/[案件编号]/目录结构，为9个agents建立专门输出文件夹
  - 细化Writer输出为12种文书类型（起诉状、答辩状、代理词、申请书等）
  - 创建Scheduler期限工时管理（日程安排、工时统计、期限提醒）
  - 建立模板库支持标准化文档生成
  - 编写各目录使用说明和输出格式规范
  - 定义统一命名规范（案件编号、文档命名、版本管理）
- **AI代理协作规范**
  - 重写docs/DEVELOPMENT.md为AI代理协作规范
  - 定义Agent配置、知识库、官方技能集成标准
  - 明确协作流程和工作流编排机制

### 变更 (Changed)
- **项目配置纠正**
  - 清理不必要Python项目配置（setup.py、requirements.txt等）
  - 更新README.md为AI代理协作使用说明
  - 重写DEVELOPMENT.md为AI代理协作规范
  - 重新聚焦Claude Code协作系统核心功能
  - 创建 `docs/` 和 `status/` 目录结构
  - 编写项目路线图 (`docs/ROADMAP.md`)
  - 编写决策记录文档 (`docs/DECISIONS.md`)
  - 编写架构文档 (`docs/ARCHITECTURE.md`)
  - 编写任务清单 (`status/TASKS.md`)
  - 编写变更记录 (`status/CHANGELOG.md`)
  - 编写工作日志 (`status/JOURNAL.md`)
- 建立AI代理协作与文档协议 (`CLAUDE.md`)
- 定义8个核心工作流模块（XXXer命名模式）
  - DocAnalyzer - 起诉文档解析器
  - EvidenceAnalyzer - 证据分析器
  - IssueIdentifier - 争议焦点识别器
  - Researcher - 法律研究者
  - Strategist - 法律策略规划器
  - Writer - 法律文书起草器
  - Summarizer - 报告摘要生成器
  - Reporter - 报告整合器
- 完善SubAgent配置规范
  - 统一配置结构和格式标准
  - 添加详细的概述、功能描述和步骤定义
  - 完善输入输出规范和错误处理机制

### 变更 (Changed)
- 重构项目文档结构，引入模块化设计理念
- 优化架构设计，采用Sub-Workflows设计模式
- **统一Agent命名为XXXer模式** - 所有8个agent采用简洁、功能明确的新命名，提升可读性和易用性
- **实现主Agent自动化工作流编排** - 添加自动化编排功能，支持文件类型自动识别和场景智能匹配，实现一键启动工作流
- **扩展支持沟通记录场景** - 新增"诉前沟通"和"诉讼中沟通"两个自动化场景，分别用于法律服务方案出具和策略优化
- **扩展支持原告起诉场景** - 新增"原告起诉"完整流程，从案件材料到完整起诉材料包（起诉状+证据目录等）
- **扩展支持委托材料制作场景** - 新增"制作委托材料"场景，自动生成委托合同、授权委托书、谈话笔录等
- **大规模扩展核心场景覆盖** - 新增7个重要法律场景（保全申请、上诉材料、律师函、法律意见书、强制执行申请、调解协议、异议申请），场景数量从8个增加到15个，专注于诉讼全流程
- **架构优化：整合模板到Memory知识库** - 将 `.claude/templates/` 中的文书模板整合到标准Memory组件 `.claude/memory/legal_templates.md`，提升管理效率和协作规范性
- **架构优化：移除不符合标准的skills目录** - 删除 `.claude/skills/` 目录，该目录包含的是API文档描述而非真正的Skills，不符合Claude Code标准
- **集成Claude Code官方Skills库** - 从Anthropic官方仓库抓取xlsx、pdf、docx三个官方技能，显著增强项目的文档处理能力
- **DocAnalyzer增强：支持ZIP处理和OCR智能重命名** - 新增压缩包解压、OCR识别、文档类型判断、智能重命名、文件整理等功能，支持法院文件批量处理
- **新增Scheduler工作流：法律期限管理和工时统计** - 实现法定期限自动计算、案件时间线管理、工作记录和工时统计分析，支持律师执业全流程的期限管理和工时管理

### 修复 (Fixed)
- 填补项目缺乏系统化文档的空白

### 移除 (Removed)
- N/A

### 安全 (Security)
- N/A

---

## [v0.1.0] - 2025-10-31

### 新增 (Added)
- 初始项目架构
  - 创建项目README.md
  - 定义核心功能和特性
  - 建立8个工作流的设计理念
  - 设计模块化架构
  - 制定上下文最小化策略
- 基础目录结构
  - `.claude/` 配置目录
  - `data/` 输入数据目录
  - `output/` 输出报告目录
- 基础配置文件
  - `requirements.txt` 依赖管理
  - `CLAUDE.md` 协作协议

### 变更 (Changed)
- N/A

### 修复 (Fixed)
- N/A

### 移除 (Removed)
- N/A

### 安全 (Security)
- N/A

---

## 版本说明

### 版本号规则
- 主版本号：API不兼容的重大变更
- 次版本号：向后兼容的功能增加
- 修订号：向后兼容的问题修复

### 变更类型
- **新增 (Added)**: 新功能、新特性
- **变更 (Changed)**: 对现有功能的修改
- **修复 (Fixed)**: 问题修复
- **移除 (Removed)**: 已移除的功能
- **安全 (Security)**: 安全相关的修复

### 变更记录规范

每次发布新版本时，请按以下格式记录：

```markdown
## [版本号] - 发布日期

### 新增 (Added)
- 简短描述
- 详细说明...

### 变更 (Changed)
- 变更内容描述
- 变更原因和影响...

### 修复 (Fixed)
- 问题描述
- 修复方案...

### 移除 (Removed)
- 已移除功能描述
- 移除原因...

### 安全 (Security)
- 安全漏洞描述
- 修复方案...
```

---

## 重要变更

### [0.1.0] - 2025-10-31
这是项目的首个正式版本，标志着项目启动和基础架构的建立。

**主要变更：**
- 项目初始化完成
- 定义了8个核心工作流
- 建立了文档协作协议
- 创建了基础项目结构

**影响范围：**
- 整个项目
- 所有协作者

---

## 迁移指南

### 从 v0.1.0 升级到下一版本
待定...

---

## 相关文档
- [项目路线图](../docs/ROADMAP.md)
- [架构文档](../docs/ARCHITECTURE.md)
- [决策记录](../docs/DECISIONS.md)
- [任务清单](TASKS.md)
- [工作日志](JOURNAL.md)
