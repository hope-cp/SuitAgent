# Tools 目录

## 用途说明

**⚠️ 注意**：此目录是**SuitAgent系统特有的设计**，不是Claude Code的官方结构。它仅用于存放工具函数代码的参考和示例。

这些工具函数本身**不被直接调用**，而是在以下场景中使用：
1. 作为参考代码，被复制到Agent prompt中
2. 作为独立脚本，通过Command执行
3. 作为文档说明，提供实现细节

## 工具函数的实际使用方式

### 方式1：复制到Agent Prompt
将工具函数代码直接写入Agent的配置或prompt中：

```python
# 在Agent的prompt中包含工具函数
def validate_required_fields(yaml_data):
    """验证YAML中的必填字段"""
    # 实现代码...

def yaml_to_placeholders(yaml_data):
    """将YAML转换为占位符"""
    # 实现代码...
```

### 方式2：作为独立脚本
将工具函数保存为独立脚本，在Command中调用：

```bash
# 在Command中使用
python3 .claude/tools/docx_processor.py --input file.docx --output output/
```

### 方式3：文档参考
将工具函数作为技术实现说明：
- 在Command文档中引用工具代码
- 提供函数实现参考
- 不直接执行，仅作为说明

## 目录结构

```
.claude/tools/
├── README.md                   # 本文件（说明性）
├── placeholder_mapper.py       # 字段映射函数（参考代码）
├── DocxProcessor.py           # Word处理函数（参考代码）
├── docx_tools.py              # 便捷接口（参考代码）
└── pdf_processor.py           # PDF处理函数（参考代码）
```

## 核心工具说明

### 1. placeholder_mapper.py
**用途**：字段映射工具（用于委托文件生成）
**使用方式**：复制函数实现到Agent prompt中
**功能**：
- YAML到占位符的转换
- 字段验证
- 映射规则管理

### 2. DocxProcessor.py
**用途**：Word文档处理
**使用方式**：
- 参考实现，在Agent中编写类似逻辑
- 或者保存为脚本调用
**功能**：
- Word文档内容替换
- 格式保持

### 3. docx_tools.py
**用途**：Word文档便捷接口
**使用方式**：作为高级API示例，或直接调用
**功能**：
- 批量生成委托文档
- 模板选择

### 4. pdf_processor.py
**用途**：PDF文档处理
**使用方式**：参考实现，在Agent中编写类似逻辑
**功能**：
- PDF文字提取
- OCR识别

## 为什么需要这个目录？

### 1. 代码复用
避免重复编写相同的函数代码
提供标准的实现参考

### 2. 技术文档
作为技术实现说明
提供详细的代码注释

### 3. 标准参考
确保工具函数的一致性
提供最佳实践示例

## 重要说明

### Claude Code中的工具使用
- **内置技能**：`skills/` 目录中的Claude Code技能可以直接调用
- **自定义工具**：需要在Agent prompt中实现
- **脚本调用**：可以通过Bash调用Python脚本

### Agent如何使用工具
```python
# 在Agent的指令中包含工具说明
"""
你可以使用以下工具函数：

def my_tool_function(data):
    '''工具功能说明'''
    # 实现代码
    return result

使用这个工具时，请...
"""
```

## 文件命名规范

- **Python文件**：`{功能名}.py`
- **说明文件**：`{功能名}_guide.md`

## 添加新工具

### Step 1: 编写工具函数
```bash
# 在tools目录中创建参考实现
touch .claude/tools/new_tool.py
```

### Step 2: 选择使用方式
- **复制到Agent prompt**：适用于需要Agent直接使用的函数
- **保存为脚本**：适用于批量处理的任务
- **文档参考**：适用于不需要执行，仅需说明的场景

### Step 3: 更新文档
如果工具被其他模块使用，在相关文档中引用

## 注意事项

- ❌ **不要**期望Claude Code直接调用此目录的Python文件
- ❌ **不要**将此目录视为"工具调用"的官方结构
- ✅ **应该**将这些工具视为"代码模板"或"参考实现"
- ✅ **应该**明确说明这些工具的使用方式

## 相关文档

- [Agent配置说明](../agents/)
- [Command系统说明](../commands/)
- [技能系统说明](../skills/)
- [系统架构文档](../../docs/ARCHITECTURE.md)
