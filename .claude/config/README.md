# 配置目录说明

## 目录用途

该目录存放SuitAgent系统的**配置文件**，提供项目的配置管理、路径映射、参数设置等。

## 文件结构

```
.claude/config/
├── README.md          # 本文件
└── paths.yaml         # 路径映射配置文件（单一真实源）
```

## 核心配置文件

### paths.yaml

**单一真实源（Single Source of Truth）** - 所有路径配置都从这个文件读取

**用途**：
- 定义案件目录的12层结构
- 维护旧命名到新命名的映射关系
- 管理核心模板文件位置和版本
- 提供配置变更历史和路线图

**为什么需要这个文件？**

1. **避免配置不一致**：所有脚本和工具都从此文件读取路径
2. **简化调整**：修改模板结构时，只需更新这一个文件
3. **支持高频变更**：可以灵活调整，不影响代码逻辑
4. **机器可读**：支持自动化工具解析和使用

**使用方式**：

```bash
# 1. 手动编辑
vim .claude/config/paths.yaml

# 2. 验证配置
.claude/scripts/verify-config.sh

# 3. 提交更改
git add .claude/config/paths.yaml
git commit -m "更新目录结构配置"
```

**关键字段**：

- `case_structure.directories` - 12层目录完整定义
- `path_mapping` - 旧命名到新命名的映射
- `core_case_files` - 核心案件模板文件列表
- `changelog` - 变更历史
- `roadmap` - 未来计划

## 与其他目录的关系

- **与 `templates/` 的关系**：
  - `config/paths.yaml` 是 "应该是什么"
  - `templates/case-templates/` 是 "实际是什么"
  - 两者应保持一致，通过验证脚本确保

- **与 `scripts/` 的关系**：
  - 脚本从 `config/paths.yaml` 读取配置
  - 不再硬编码路径信息

- **与 `agents/` 的关系**：
  - Agent配置可以引用此文件
  - 提供统一的上下文信息

## 最佳实践

1. **修改模板前**
   - 先更新 `config/paths.yaml`
   - 运行验证脚本检查
   - 再修改模板目录

2. **添加新目录时**
   - 在yaml中添加新项
   - 指定用途、负责Agent
   - 添加到映射表（如果有旧命名）

3. **版本管理**
   - 每次修改更新 `changelog`
   - 标注版本号和修改人
   - 保持向后兼容性

## 更新日志

| 版本 | 日期 | 更新内容 | 修改人 |
|------|------|----------|--------|
| v1.0 | 2025-11-19 | 创建paths.yaml作为单一真实源 | AI Agent |

## 相关文档

- [验证脚本使用说明](../scripts/README.md)
- [模板目录说明](../templates/README.md)
