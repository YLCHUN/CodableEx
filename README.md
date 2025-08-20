## CodableEx

一个更友好的 Codable 辅助库：
- 一行把任意 `Codable` 模型与 `Dictionary<String, Any>` / `[[String: Any]]` / JSON 字符串互转
- 解码容错：字符串/数字/布尔/浮点之间自动转换，越界保护
- 动态 JSON 支持：在 `Codable` 模型里安全携带不确定结构的字典/数组
- 编解码完成回调：在模型完成编解码后触发自定义收尾逻辑


## 特性
- 强类型与字典/数组的互转：
  - `Encodable.encode() -> [String: Any]`
  - `[Encodable].encode() -> [[String: Any]]`
  - `[String: Any].decode<T: Decodable>() -> T`
  - `[[String: Any]].decode<T: Decodable>() -> [T]`
- JSON 字符串互转：`CodableEx().encode(model) -> String`、`CodableEx().decode(json) -> T`
- 解码容错：`KeyedDecodingContainer.decodeIfPresent(...)` 的多重重载自动完成基础类型间的安全转换
- 动态 JSON：`CodableExBox<[String: Any]>`、`CodableExBox<[Any]>` 支持在模型里装载不定结构
- 编解码完成回调：实现 `CodableExFinish` 即可在完成后收到回调

## 快速开始

定义你的模型（标准 `Codable` 写法即可，可自定义 `CodingKeys`）：
```swift
import Foundation
import CodableEx

public enum ModelType: Int, Codable {
    case TA
    case TB
}

public class SubModel: Codable {
    var num: Int?
    var flag: String?
}

public class DemoModel: Codable {
    var nums: String?
    var numi: CGFloat?
    var flag: String?
    var dict: CodableExBox<[String: Any]>?
    var arr: CodableExBox<[Any]>?
    var models: [SubModel]?
    var model: SubModel?
    var mt: ModelType?

    enum CodingKeys: String, CodingKey {
        case dict, arr, nums, numi, models, model, mt
        case flag = "flag_f" // 支持字段别名
    }
}
```

解码：字典/数组/JSON 字符串 → 模型
```swift
let dict: [String: Any] = [
    "nums": 1,                 // String ⇄ Int 自动转换
    "numi": "1.1",            // CGFloat ⇄ String 自动转换
    "flag_f": "A",            // 字段别名映射
    "mt": 1,
    "models": [["num": 11, "flag": "A"]],
    "dict": ["1": 1, "arr": [1, 2, 3]],
    "arr": [["num": 11, "flag": "A"]],
    "model": ["num": 11, "flag": "A"]
]

let array: [[String: Any]] = [
    ["nums": "1", "numi": "1", "flag_f": "A", "mt": 0 , "models": [["num": "11", "flag": "A"]], "dict": ["1": 1]],
    ["nums": "2", "numi": "1", "flag_f": "A", "mt": 1 , "models": [["num": "21", "flag": "B"]], "dict": ["1": 1]]
]

let model: DemoModel = try dict.decode()
let models: [DemoModel] = try array.decode()

// JSON 字符串 → 模型/数组
let jsonModel: DemoModel = try CodableEx().decode("{\"nums\":\"1\"}")
let jsonModels: [DemoModel] = try CodableEx().decode("[{\"nums\":\"1\"}]")
```

编码：模型 → 字典/数组/JSON 字符串
```swift
let json: [String: Any] = try model.encode()
let jsons: [[String: Any]] = try models.encode()

let jsonString: String = try CodableEx().encode(model)
let jsonStrings: String = try CodableEx().encode(models)
```

动态 JSON：在模型中携带不定结构
```swift
if let dictBox = model.dict {
    let count = dictBox.count
    let anyVal = dictBox["someKey"]
}

if let arrBox = model.arr {
    let first = arrBox[0]
}
```

可选：在编解码完成后做收尾处理
```swift
import CodableEx

extension SubModel: CodableExFinish {
    public func finishEncode() {
        print("finishEncode: \(self)")
    }
    public func finishDecode() {
        print("finishDecode: \(self)")
    }
}
```

## 原理说明
- 字典/数组 → 模型：`JSONSerialization.data(withJSONObject:)` → `JSONDecoder().decode(...)`
- 模型 → 字典/数组：`JSONEncoder().encode(...)` → `JSONSerialization.jsonObject(...)`
- 解码容错：为 `KeyedDecodingContainer` 提供了多个 `decodeIfPresent(...)` 重载，
  当目标类型解码失败时，按顺序尝试从备选基础类型（`String`/`Int`/`Float`/`Double` 等）读取并进行安全转换（含越界保护和 NaN/Inf 兜底）。
- 动态 JSON：`CodableExBox<T>` 通过自定义 `CodingKey` 与容器遍历，递归解/编码基础类型与嵌套结构，实现 `[String: Any]`、`[Any]` 的 Codable 化。
- 完成回调：当使用容错的 `decodeIfPresent` 或对应的 `encodeIfPresent` 时，会在成功后调用 `finishDecode()`/`finishEncode()`，方便做模型校验、日志或派生计算。

## API 速查表
- 字典/数组与模型：
  - `[String: Any].decode<T: Decodable>() -> T`
  - `[[String: Any]].decode<T: Decodable>() -> [T]`
  - `Encodable.encode() -> [String: Any]`
  - `[Encodable].encode() -> [[String: Any]]`
- JSON 字符串：
  - `CodableEx().decode<T: Decodable>(_ json: String) -> T / [T]`
  - `CodableEx().encode<T: Encodable>(_ model: T / [T]) -> String`
- 动态 JSON：
  - `CodableExBox<[String: Any]>`、`CodableExBox<[Any]>`，提供 `count`、下标等便捷访问
- 编解码完成回调：
  - `protocol CodableExFinish = DecodableExFinish & EncodableExFinish`
  - 为模型实现 `finishDecode()` / `finishEncode()`

## 注意事项与最佳实践
- 解码容错仅作用于 `decodeIfPresent(...)`，若字段为必填请继续使用标准 `decode(...)` 并显式处理异常
- `CodableExBox` 仅支持 JSON 常见原始类型、字典与数组的递归嵌套
- 建议在模型层进行必要的业务校验，避免将容错行为当作数据清洗
- 错误均以 `NSError` 抛出，包含清晰的失败原因描述

## 示例工程
请参考 `Example/` 目录中的使用示例（如 `ViewController.swift`、`CodableExModels.swift`）。

## 作者
- Author: YLCHUN / Cityu

