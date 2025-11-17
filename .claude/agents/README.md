# Agents 配置目录

## 用途说明

该目录存放SuitAgent系统中**10个核心Agent**的配置文件。每个Agent负责特定的法律实务功能。

## 目录结构

```
.claude/agents/
├── README.md                   # 本文件
├── DocAnalyzer.md              # 文档分析器
├── EvidenceAnalyzer.md         # 证据分析器
├── IssueIdentifier.md          # 争议焦点识别器
├── Researcher.md               # 法律研究者
├── Strategist.md               # 策略制定器
├── Writer.md                   # 法律文书起草器
├── Summarizer.md               # 摘要生成器
├── Reporter.md                 # 报告整合器
├── Scheduler.md                # 日程规划者
└── Reviewer.md                 # 智能审查器
```

## 文件格式规范

### 命名规范
- **格式**：`{Agent名称}.md`
- **规则**：使用英文单词，首字母大写，无空格
- **示例**：`DocAnalyzer.md`, `Writer.md`

### 文件内容结构

每个Agent配置文件应包含以下部分：

```markdown
# {Agent名称} - {功能简述}

## 核心职责
[描述Agent的主要功能和责任]

## 输入
- [输入内容1]
- [输入内容2]

## 输出
- [输出内容1]
- [输出内容2]

## 工作流程
[详细描述Agent的工作步骤]

## 质量保证
[描述质量检查机制]

## 后续工作指引
[描述该Agent完成后应触发的工作]
```

## Agent列表

| # | Agent名称 | 文件 | 职责 |
|---|------------|------|------|
| 1 | DocAnalyzer | [DocAnalyzer.md](DocAnalyzer.md) | 解析文档，提取结构化信息 |
| 2 | EvidenceAnalyzer | [EvidenceAnalyzer.md](EvidenceAnalyzer.md) | 分析证据，评估证明力 |
| 3 | IssueIdentifier | [IssueIdentifier.md](IssueIdentifier.md) | 识别争议焦点 |
| 4 | Researcher | [Researcher.md](Researcher.md) | 法律检索和法条研究 |
| 5 | Strategist | [Strategist.md](Strategist.md) | 制定诉讼策略 |
| 6 | Writer | [Writer.md](Writer.md) | 起草法律文书 |
| 7 | Summarizer | [Summarizer.md](Summarizer.md) | 生成摘要和简报 |
| 8 | Reporter | [Reporter.md](Reporter.md) | 整合报告 |
| 9 | Scheduler | [Scheduler.md](Scheduler.md) | 期限管理和工时统计 |
| 10 | Reviewer | [Reviewer.md](Reviewer.md) | 质量审查 |

## 添加新Agent

如需添加新Agent：

1. **创建配置文件**：
   ```bash
   # 使用正确的命名规范
   touch .claude/agents/NewAgentName.md
   ```

2. **编写内容**：
   - 按照标准结构填写各部分
   - 确保职责清晰，与现有Agent不重复
   - 描述与其他Agent的协作关系

3. **更新列表**：
   - 在本README中添加新Agent的信息
   - 更新Agent计数（目前是10个）

## 最佳实践

1. **职责单一**：每个Agent应只负责一个核心功能
2. **协作明确**：清楚描述与其他Agent的协作关系
3. **质量保证**：每个Agent都应有质量检查机制
4. **文档完整**：确保输入输出描述详细准确
5. **遵循标准**：使用统一的格式和结构

## 注意事项

- ❌ **不要**创建子目录，所有Agent文件都在根目录
- ❌ **不要**使用中文文件名或包含空格的名称
- ✅ **必须**使用英文单词和标准命名规范
- ✅ **必须**保持文件内容的结构一致性
- ✅ **必须**描述清楚后续工作指引

## 相关文档

- [系统架构文档](../../docs/ARCHITECTURE.md)
- [项目路线图](../../docs/ROADMAP.md)
- [决策记录](../../docs/DECISIONS.md)
