# SuitAgent 命令系统 (Commands)

## 概述

### 什么是Command？

Command 是 SuitAgent 提供的**预设工作流程**，将复杂的多Agent协作封装成简单的一键启动命令，让用户无需了解内部实现即可使用。

### 使用方式

在对话中直接输入：
```
/命令名 参数
```

系统会自动：
1. 解析您的参数
2. 启动相应的工作流
3. 触发多个Agent协作
4. 输出标准化的结果

## 设计原则

1. **单文件设计**：每个Command是一个独立的`.md`文件，自包含完整信息
2. **功能导向**：每个Command对应一个具体的法律实务场景
3. **工作流自动化**：自动触发多个Agent协作，无需手动组合
4. **用户友好**：参数简洁明了，输出标准化

## 文件格式规范

### 命名规范
- **格式**：`{command-name}.md`
- **规则**：使用英文单词，小写字母，用连字符分隔
- **示例**：`new-case.md`, `generate-trust-docs.md`

### 重要说明
- ❌ **不要**创建子目录或文件夹结构
- ❌ **不要**创建`command.md`和`implementation.md`两个文件
- ❌ **不要**在文件开头添加YAML元数据
- ✅ **必须**是一个`.md`文件包含所有信息
- ✅ **必须**以`# /command-name`作为主标题

## 已实现的命令列表

| 命令 | 文件 | 功能 |
|------|------|------|
| `/new-case` | [new-case.md](new-case.md) | 创建新案件 |
| `/generate-trust-docs` | [generate-trust-docs.md](generate-trust-docs.md) | 生成委托材料 |
| `/evidence-review` | [evidence-review.md](evidence-review.md) | 证据质证 |
| `/2word` | [2word.md](2word.md) | Markdown转Word工具 |

## 命令使用示例

### 1. /new-case
**用途**：为新案件创建标准化工作目录

**用法**：
```bash
/new-case --case-id "[案件编号]" --client-name "客户名"
```

**示例**：
```bash
/new-case --case-id "[2025]京0105民初1234号" --client-name "张三"
```

**效果**：创建完整的6层目录结构 + YAML管理文件 + MD工作记录

**工作流**：DocAnalyzer → Scheduler → Reporter

---

### 2. /generate-trust-docs
**用途**：生成委托材料包

**用法**：
```bash
/generate-trust-docs --client-name "客户" --client-type company --lawyer-name "律师"
```

**示例**：
```bash
/generate-trust-docs --client-name "北京科技公司" --client-type company --lawyer-name "李律师"
```

**效果**：生成5个Word文档 + 委托材料清单

**工作流**：DocAnalyzer → Writer → Summarizer → Reporter

---

### 3. /evidence-review
**用途**：对证据进行质证分析

**用法**：
```bash
/evidence-review --evidence-path "文件路径" --case-id "案件编号"
```

**示例**：
```bash
/evidence-review --evidence-path "合同书.pdf" --case-id "[2025]京0105民初1234号"
```

**效果**：生成质证意见书 + 补充证据建议

**工作流**：DocAnalyzer → EvidenceAnalyzer → Researcher → Writer → Summarizer → Reporter

---

### 4. /2word
**用途**：Markdown转Word工具

**用法**：
```bash
/2word input.md output.docx
```

**示例**：
```bash
/2word --format=legal-standard input.md output.docx
```

**效果**：将Markdown文档转换为Word格式，支持自定义格式

---

## 如何选择命令？

| 需求 | 推荐命令 | 工作流 |
|------|----------|--------|
| 刚接收新案件 | `/new-case` | 3个Agent，15秒 |
| 确定委托关系 | `/generate-trust-docs` | 4个Agent，30秒 |
| 收到新证据 | `/evidence-review` | 6个Agent，45秒 |
| 文档格式转换 | `/2word` | 直接转换，即时 |

## 命令特性

### ✨ 自动化工作流
每个Command自动触发多个SubAgent协作，用户无需手动组合Agent。

### 📝 智能参数解析
- **必需参数**：明确标记，不可省略
- **可选参数**：有默认值，可根据需要调整
- **YAML支持**：支持从YAML文件批量读取参数

### 🔄 上下文保持
- 所有Command自动维护案件上下文
- 输出自动保存到标准化目录
- 支持增量更新，避免重复工作

### 🛡️ 质量保证
- **输入验证**：自动检查参数完整性
- **过程监控**：实时跟踪执行进度
- **输出检查**：验证生成文档质量
- **错误处理**：详细的错误提示和解决建议

## 添加新Command

### Step 1: 创建文件
```bash
# 使用正确的命名规范
touch .claude/commands/my-new-command.md
```

### Step 2: 编写内容
1. 复制现有Command作为模板
2. 修改命令名称和功能说明
3. 更新参数列表和使用示例
4. 描述触发的Agent工作流
5. 说明输出内容

### Step 3: 更新文档
1. 在本README的命令列表中添加新命令
2. 更新命令计数
3. 验证文件格式正确性

## 最佳实践

1. **命令名称简洁**：使用易记的英文名称，避免过长
2. **参数设计合理**：
   - 必需参数尽可能少（1-3个）
   - 可选参数提供默认值
   - 参数名使用kebab-case格式
3. **示例实用**：提供2-3个典型使用场景的示例
4. **工作流清晰**：明确列出触发的Agent和执行顺序
5. **输出标准**：遵循统一的目录结构和命名规范

## 工作流说明

Command系统的工作流程：

```
用户输入 → 系统解析参数 → 构建工作流 → 触发Agent → 生成输出
```

每个Command都会：
1. 自动解析用户参数
2. 验证输入完整性
3. 按顺序触发多个Agent
4. 维护案件上下文
5. 输出标准化结果

## 技术架构

```
┌─────────────────────────────────────┐
│            用户输入 Command             │
│   /generate-trust-docs [参数]        │
└─────────────┬───────────────────────┘
              ▼
┌─────────────────────────────────────┐
│        Command 解析器 (Parser)        │
│   - 解析参数                         │
│   - 验证输入                         │
│   - 构建工作流                       │
└─────────────┬───────────────────────┘
              ▼
┌─────────────────────────────────────┐
│        SubAgent 工作流引擎           │
│                                      │
│  ┌──────────┐    ┌──────────┐      │
│  │DocAnalyzer│ -> │ Writer   │      │
│  └──────────┘    └──────────┘      │
│       │              │             │
│       ▼              ▼             │
│  ┌──────────┐    ┌──────────┐      │
│  │Summarizer│ -> │ Reporter │      │
│  └──────────┘    └──────────┘      │
└─────────────┬───────────────────────┘
              ▼
┌─────────────────────────────────────┐
│          输出处理器                   │
│   - 保存文档                         │
│   - 更新上下文                       │
│   - 生成报告                         │
└─────────────────────────────────────┘
```

## 注意事项

- ❌ **不允许**创建文件夹或子目录结构
- ❌ **不允许**使用中文文件名
- ❌ **不允许**在文件开头添加YAML配置
- ❌ **不允许**将内容分散在多个文件中
- ✅ **必须**使用标准Markdown格式
- ✅ **必须**遵循命名规范
- ✅ **必须**提供清晰的使用示例

## 相关文档

- [系统架构文档](../../docs/ARCHITECTURE.md)
- [Agent配置文档](../agents/)
- [工具系统说明](../tools/)
