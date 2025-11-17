#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
委托文件生成系统集成测试

版本: v1.0
更新: 2025-11-14
作者: SuitAgent整合系统

运行测试:
  python3 tests/test_integration.py
"""

import os
import sys
import tempfile
import yaml
from pathlib import Path

# 添加项目根目录到Python路径
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from tools.placeholder_mapper import PlaceholderMapper
from tools.DocxProcessor import DocxProcessor
from tools.docx_tools import (
    batch_generate_trust_documents,
    validate_yaml_file,
    create_case_yaml_template,
    get_template_list
)

# 测试颜色输出
GREEN = '\033[92m'
RED = '\033[91m'
YELLOW = '\033[93m'
BLUE = '\033[94m'
RESET = '\033[0m'

def print_test(name):
    print(f"\n{BLUE}={'=' * 60}{RESET}")
    print(f"{BLUE}测试: {name}{RESET}")
    print(f"{BLUE}{'=' * 60}{RESET}")


def print_success(message):
    print(f"{GREEN}✓ {message}{RESET}")


def print_error(message):
    print(f"{RED}✗ {message}{RESET}")


def print_info(message):
    print(f"{YELLOW}ℹ {message}{RESET}")


# 测试数据
TEST_YAML_DATA = {
    '案件基本信息': {
        '委托人信息': {
            'client_name': '张三有限公司',
            'client_type': '公司',
            'client_code': '912345678901234567',
            'client_address': '北京市朝阳区xxx街道123号',
            'legal_representative': '李四',
            'representative_position': '总经理'
        },
        '律师信息': {
            'lawyer_name': '王五',
            'lawyer_contact': '13800000000'
        },
        '案件信息': {
            'opposing_party': '北京某某公司',
            'case_cause': '买卖合同纠纷',
            'case_type': '民事案件',
            'client_vs_opponent': '张三有限公司诉北京某某公司'
        }
    },
    '日期信息': {
        'year': '2025',
        'month': '11',
        'day': '14'
    }
}

TEST_YAML_DATA_PERSON = {
    '案件基本信息': {
        '委托人信息': {
            'client_name': '张三',
            'client_type': '个人',
            'client_code': '110101199001011234',
            'client_address': '北京市朝阳区xxx街道123号',
            'legal_representative': '',
            'representative_position': ''
        },
        '律师信息': {
            'lawyer_name': '王五',
            'lawyer_contact': '13800000000'
        },
        '案件信息': {
            'opposing_party': '北京某某公司',
            'case_cause': '买卖合同纠纷',
            'case_type': '民事案件',
            'client_vs_opponent': '张三诉北京某某公司'
        }
    },
    '日期信息': {
        'year': '2025',
        'month': '11',
        'day': '14'
    }
}


def test_placeholder_mapping():
    """测试占位符映射功能"""
    print_test("占位符映射")

    # 测试公司委托
    placeholders = PlaceholderMapper.yaml_to_placeholders(TEST_YAML_DATA)

    # 验证关键字段
    expected = {
        'client': '张三有限公司',
        'type': '公司',
        'lawyer': '王五',
        'opposite': '北京某某公司',
        'year': '2025',
        'month': '11',
        'day': '14'
    }

    for key, expected_value in expected.items():
        if key in placeholders and placeholders[key] == expected_value:
            print_success(f"字段 {key}: {expected_value}")
        else:
            print_error(f"字段 {key} 映射失败")
            return False

    # 验证必填字段检查
    missing = PlaceholderMapper.validate_required_fields(placeholders)
    if not missing:
        print_success("所有必填字段完整")
    else:
        print_error(f"缺失必填字段: {missing}")
        return False

    # 测试个人委托
    placeholders_person = PlaceholderMapper.yaml_to_placeholders(TEST_YAML_DATA_PERSON)
    if 'client' in placeholders_person and placeholders_person['client'] == '张三':
        print_success("个人委托字段映射正确")
    else:
        print_error("个人委托字段映射失败")
        return False

    return True


def test_yaml_validation():
    """测试YAML验证功能"""
    print_test("YAML验证")

    with tempfile.TemporaryDirectory() as tmpdir:
        yaml_path = os.path.join(tmpdir, "test_case.yaml")

        # 写入测试数据
        with open(yaml_path, 'w', encoding='utf-8') as f:
            yaml.dump(TEST_YAML_DATA, f, allow_unicode=True)

        # 验证文件
        is_complete, missing = validate_yaml_file(yaml_path)

        if is_complete:
            print_success("YAML文件验证通过")
            return True
        else:
            print_error(f"YAML验证失败，缺失字段: {missing}")
            return False


def test_template_discovery():
    """测试模板发现功能"""
    print_test("模板发现")

    # 检查公司模板
    company_templates = get_template_list(".claude/memory/公司委托模板")
    if company_templates:
        print_success(f"找到 {len(company_templates)} 个公司模板")
        for template in company_templates[:3]:
            print_info(f"  - {template}")
        if len(company_templates) > 3:
            print_info(f"  ... 还有 {len(company_templates) - 3} 个")
    else:
        print_error("未找到公司模板")
        return False

    # 检查个人模板
    person_templates = get_template_list(".claude/memory/个人委托模板")
    if person_templates:
        print_success(f"找到 {len(person_templates)} 个个人模板")
        for template in person_templates[:3]:
            print_info(f"  - {template}")
        if len(person_templates) > 3:
            print_info(f"  ... 还有 {len(person_templates) - 3} 个")
    else:
        print_error("未找到个人模板")
        return False

    return True


def test_yaml_template_creation():
    """测试YAML模板创建功能"""
    print_test("YAML模板创建")

    with tempfile.TemporaryDirectory() as tmpdir:
        case_id = "[2025]京0105民初1234号"
        output_path = os.path.join(tmpdir, f"{case_id}.yaml")

        try:
            create_case_yaml_template(case_id, output_path)

            if os.path.exists(output_path):
                print_success(f"YAML模板创建成功: {output_path}")

                # 验证文件内容
                with open(output_path, 'r', encoding='utf-8') as f:
                    content = f.read()

                if '案件编号' in content and case_id in content:
                    print_success("YAML模板内容正确")
                    return True
                else:
                    print_error("YAML模板内容不正确")
                    return False
            else:
                print_error("YAML模板文件未创建")
                return False

        except Exception as e:
            print_error(f"YAML模板创建失败: {e}")
            return False


def test_field_mapping_table():
    """测试字段映射表"""
    print_test("字段映射表")

    print_info("字段映射表内容:")
    print("-" * 80)

    mapping_info = {
        # 委托人信息
        'client_name': '委托人名称',
        'client_type': '委托人类型',
        'client_code': '代码',
        'client_address': '地址',
        'legal_representative': '法定代表人',
        'representative_position': '职位',
        # 律师信息
        'lawyer_name': '律师姓名',
        'lawyer_contact': '联系电话',
        # 案件信息
        'opposing_party': '对方当事人',
        'case_cause': '案由',
        'case_type': '案件类型',
        'client_vs_opponent': '当事人关系',
        # 日期信息
        'year': '年份',
        'month': '月份',
        'day': '日期',
    }

    for yaml_field, placeholder in PlaceholderMapper.FIELD_MAPPING.items():
        chinese_name = mapping_info.get(yaml_field, '')
        print(f"  {yaml_field:<40} {{{placeholder}}} {chinese_name}")

    print("-" * 80)
    print_success("字段映射表展示完成")

    return True


def test_batch_generation():
    """测试批量生成功能（模拟）"""
    print_test("批量生成模拟测试")

    with tempfile.TemporaryDirectory() as tmpdir:
        # 创建测试YAML文件
        yaml_path = os.path.join(tmpdir, "test.yaml")
        with open(yaml_path, 'w', encoding='utf-8') as f:
            yaml.dump(TEST_YAML_DATA, f, allow_unicode=True)

        case_id = "[2025]京0105民初1234号"
        output_dir = os.path.join(tmpdir, "output")

        # 模拟批量生成（不实际生成文件）
        templates = [
            "002律师服务质量监督卡存根.docx",
            "003谈话笔录.docx",
        ]

        print_info(f"模拟生成模板: {', '.join(templates)}")

        # 检查模板是否存在
        template_dir = ".claude/memory/公司委托模板"
        for template in templates:
            template_path = os.path.join(template_dir, template)
            if os.path.exists(template_path):
                print_success(f"模板存在: {template}")
            else:
                print_error(f"模板不存在: {template}")

        print_success("批量生成模拟测试完成")
        return True


def run_all_tests():
    """运行所有测试"""
    print(f"\n{BLUE}")
    print("=" * 80)
    print("委托文件生成系统 - 集成测试")
    print("=" * 80)
    print(f"{RESET}")

    tests = [
        ("字段映射", test_placeholder_mapping),
        ("YAML验证", test_yaml_validation),
        ("模板发现", test_template_discovery),
        ("YAML模板创建", test_yaml_template_creation),
        ("字段映射表", test_field_mapping_table),
        ("批量生成模拟", test_batch_generation),
    ]

    results = []
    for test_name, test_func in tests:
        try:
            result = test_func()
            results.append((test_name, result))
        except Exception as e:
            print_error(f"测试 '{test_name}' 出现异常: {e}")
            results.append((test_name, False))

    # 总结
    print(f"\n{BLUE}{'=' * 80}{RESET}")
    print(f"{BLUE}测试总结{RESET}")
    print(f"{BLUE}{'=' * 80}{RESET}")

    passed = sum(1 for _, result in results if result)
    total = len(results)

    for test_name, result in results:
        status = f"{GREEN}通过{RESET}" if result else f"{RED}失败{RESET}"
        print(f"  {test_name:<30} {status}")

    print(f"\n{BLUE}总计: {passed}/{total} 个测试通过{RESET}")

    if passed == total:
        print(f"\n{GREEN}✓ 所有测试通过！{RESET}")
        return True
    else:
        print(f"\n{RED}✗ 有 {total - passed} 个测试失败{RESET}")
        return False


if __name__ == "__main__":
    try:
        success = run_all_tests()
        sys.exit(0 if success else 1)
    except KeyboardInterrupt:
        print(f"\n{YELLOW}测试被用户中断{RESET}")
        sys.exit(1)
    except Exception as e:
        print(f"\n{RED}测试运行出现致命错误: {e}{RESET}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
