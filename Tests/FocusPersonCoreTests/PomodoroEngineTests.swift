import XCTest
@testable import FocusPersonCore

final class PomodoroEngineTests: XCTestCase {
    func testVersionOneDefaultsMatchProductDecisions() {
        let config = SessionConfiguration.versionOne

        XCTAssertEqual(config.focusDuration, 25 * 60)
        XCTAssertEqual(config.shortBreakDuration, 5 * 60)
        XCTAssertEqual(config.longBreakDuration, 15 * 60)
        XCTAssertEqual(config.longBreakEvery, 4)
        XCTAssertEqual(config.minimumReflectionWordCount, 3)
        XCTAssertEqual(config.warmupDuration, 2 * 60)
    }

    func testWarmupTransitionMovesIntoFocusWithoutReflection() {
        let engine = PomodoroEngine()
        let state = engine.initialState(useWarmup: true)

        let transition = engine.nextTransition(from: state)

        XCTAssertEqual(transition.nextSession, .focus)
        XCTAssertEqual(transition.duration, 25 * 60)
        XCTAssertFalse(transition.requiresReflection)
    }

    func testFocusAfterFourthRoundTransitionsToLongBreak() {
        let engine = PomodoroEngine()
        let state = PomodoroState(
            activeSession: .focus,
            completedFocusCount: 3,
            secondsRemaining: 0,
            isWarmup: false
        )

        let transition = engine.nextTransition(from: state)

        XCTAssertEqual(transition.nextSession, .longBreak)
        XCTAssertEqual(transition.duration, 15 * 60)
        XCTAssertTrue(transition.requiresReflection)
    }

    func testReflectionRequiresMinimumThreeWords() {
        let engine = PomodoroEngine()

        XCTAssertThrowsError(try engine.validateReflection("too short")) { error in
            XCTAssertEqual(error as? ReflectionValidationError, .tooShort(requiredWords: 3))
        }

        XCTAssertNoThrow(try engine.validateReflection("keep building daily"))
    }

    func testCoachPromptUsesMediumStrictToneInChineseAndEnglish() {
        let zh = PromptStyle(language: .zhHans, mediumStrict: true)
        let en = PromptStyle(language: .english, mediumStrict: true)

        XCTAssertTrue(zh.prompt(for: .focus).contains("训练身份"))
        XCTAssertTrue(en.prompt(for: .shortBreak).contains("part of the system"))
    }
}
