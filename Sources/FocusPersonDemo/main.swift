import Foundation
import FocusPersonCore

let engine = PomodoroEngine()
var state = engine.initialState(useWarmup: true)

print("=== 专注的人 FocusPerson Demo ===")
print("当前状态: \(state.activeSession.rawValue), 剩余秒数: \(state.secondsRemaining), warmup: \(state.isWarmup)")

for round in 1...6 {
    let transition = engine.nextTransition(from: state)
    print("第 \(round) 次切换 -> \(transition.nextSession.rawValue), 时长: \(transition.duration)s, 需要反思: \(transition.requiresReflection)")

    if transition.requiresReflection {
        let reflection = "I finished one focused session"
        do {
            try engine.validateReflection(reflection)
            print("反思通过: \(reflection)")
        } catch {
            print("反思失败: \(error)")
        }
    }

    state = engine.apply(transition: transition, to: state)
    let promptZH = PromptStyle(language: .zhHans, mediumStrict: true).prompt(for: state.activeSession)
    print("提示语(中): \(promptZH)")
}

print("Demo 完成。你已经可以把这个核心引擎接到 iOS SwiftUI 界面。")
