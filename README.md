# 专注的人 / Focus Person

这是一个 iOS 17+ 番茄钟应用的**核心逻辑层**（不是完整 App 界面）。
你现在看到的是：计时规则、切换规则、反思校验、习惯 streak 的底层代码。

## 当前已实现的 V1 规则

- 专注 / 短休息：**25 / 5 分钟**
- 长休息：**每 4 次专注后 15 分钟**
- 反思：**必须填写，最少 3 个词**
- 启动热身：**2 分钟 warmup**
- 文案语气：**中等严格（中英双语）**
- 连续天数（streak）：支持 current/best

---

## 小白也能跑起来（一步一步）

> 前提：你的电脑需要安装 Swift（建议 Swift 5.9+）

### 1) 打开终端，进入项目目录

```bash
cd /workspace/Timecard
```

### 2) 运行测试（确认逻辑没坏）

```bash
swift test
```

如果看到 `0 failures`，说明核心逻辑正常。

### 3) 运行演示程序（你能看到规则怎么切换）

```bash
swift run FocusPersonDemo
```

它会在终端打印：
- 当前是专注/休息哪种状态
- 每次切换后的时长
- 何时需要反思
- 中文教练提示语

---

## 目录说明

- `Sources/FocusPersonCore/PomodoroEngine.swift`  
  番茄状态机：专注/休息切换、反思校验、提示语生成。
- `Sources/FocusPersonCore/StreakTracker.swift`  
  连续打卡（streak）逻辑。
- `Sources/FocusPersonDemo/main.swift`  
  给新手用的命令行演示入口。
- `Tests/FocusPersonCoreTests/*`  
  单元测试，验证规则是否符合产品决策。

---

## 你下一步怎么做（最实用）

如果你要做成 iPhone 上真正可用的 App：
1. 新建一个 Xcode iOS 项目（SwiftUI）。
2. 把 `FocusPersonCore` 作为本地 Swift Package 引入。
3. 在 UI 里调用 `PomodoroEngine` 和 `StreakTracker`。
4. 再接入通知、页面、StoreKit 买断。

如果你愿意，我下一步可以直接给你：
- 一份可以在 Xcode 打开的 iOS App 骨架（含首页计时界面）
- 已接好这个 Core 包，点一下就能跑。
