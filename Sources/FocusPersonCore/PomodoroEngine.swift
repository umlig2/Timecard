import Foundation

public enum SessionType: String, Codable, Sendable {
    case focus
    case shortBreak
    case longBreak
}

public struct SessionConfiguration: Equatable, Sendable {
    public var focusDuration: TimeInterval
    public var shortBreakDuration: TimeInterval
    public var longBreakDuration: TimeInterval
    public var longBreakEvery: Int
    public var minimumReflectionWordCount: Int
    public var warmupDuration: TimeInterval

    public init(
        focusDuration: TimeInterval = 25 * 60,
        shortBreakDuration: TimeInterval = 5 * 60,
        longBreakDuration: TimeInterval = 15 * 60,
        longBreakEvery: Int = 4,
        minimumReflectionWordCount: Int = 3,
        warmupDuration: TimeInterval = 2 * 60
    ) {
        self.focusDuration = focusDuration
        self.shortBreakDuration = shortBreakDuration
        self.longBreakDuration = longBreakDuration
        self.longBreakEvery = longBreakEvery
        self.minimumReflectionWordCount = minimumReflectionWordCount
        self.warmupDuration = warmupDuration
    }

    public static let versionOne = SessionConfiguration()
}

public struct PromptStyle: Sendable {
    public enum Language: String, Sendable {
        case zhHans
        case english
    }

    public var language: Language
    public var mediumStrict: Bool

    public init(language: Language, mediumStrict: Bool = true) {
        self.language = language
        self.mediumStrict = mediumStrict
    }

    public func prompt(for session: SessionType) -> String {
        switch (language, session) {
        case (.zhHans, .focus):
            return mediumStrict ? "现在开始专注。你不是在等状态，你是在训练身份。" : "开始专注。"
        case (.zhHans, .shortBreak), (.zhHans, .longBreak):
            return mediumStrict ? "休息是任务的一部分。按时回来，继续下一轮。" : "休息一下。"
        case (.english, .focus):
            return mediumStrict ? "Start now. You do not wait for motivation; you train identity." : "Start focus now."
        case (.english, .shortBreak), (.english, .longBreak):
            return mediumStrict ? "Rest is part of the system. Return on time for the next round." : "Take a break."
        }
    }
}

public struct PomodoroState: Equatable, Sendable {
    public var activeSession: SessionType
    public var completedFocusCount: Int
    public var secondsRemaining: Int
    public var isWarmup: Bool

    public init(
        activeSession: SessionType = .focus,
        completedFocusCount: Int = 0,
        secondsRemaining: Int,
        isWarmup: Bool = false
    ) {
        self.activeSession = activeSession
        self.completedFocusCount = completedFocusCount
        self.secondsRemaining = secondsRemaining
        self.isWarmup = isWarmup
    }
}

public struct PomodoroTransition: Equatable, Sendable {
    public var nextSession: SessionType
    public var duration: Int
    public var requiresReflection: Bool
}

public enum ReflectionValidationError: Error, Equatable {
    case tooShort(requiredWords: Int)
}

public struct PomodoroEngine: Sendable {
    public let config: SessionConfiguration

    public init(config: SessionConfiguration = .versionOne) {
        self.config = config
    }

    public func initialState(useWarmup: Bool) -> PomodoroState {
        let seconds = useWarmup ? Int(config.warmupDuration) : Int(config.focusDuration)
        return PomodoroState(secondsRemaining: seconds, isWarmup: useWarmup)
    }

    public func nextTransition(from state: PomodoroState) -> PomodoroTransition {
        if state.isWarmup {
            return PomodoroTransition(
                nextSession: .focus,
                duration: Int(config.focusDuration),
                requiresReflection: false
            )
        }

        switch state.activeSession {
        case .focus:
            let nextCount = state.completedFocusCount + 1
            let useLongBreak = nextCount.isMultiple(of: config.longBreakEvery)
            return PomodoroTransition(
                nextSession: useLongBreak ? .longBreak : .shortBreak,
                duration: useLongBreak ? Int(config.longBreakDuration) : Int(config.shortBreakDuration),
                requiresReflection: true
            )
        case .shortBreak, .longBreak:
            return PomodoroTransition(
                nextSession: .focus,
                duration: Int(config.focusDuration),
                requiresReflection: false
            )
        }
    }

    public func apply(transition: PomodoroTransition, to state: PomodoroState) -> PomodoroState {
        let increment = state.activeSession == .focus && !state.isWarmup ? 1 : 0
        return PomodoroState(
            activeSession: transition.nextSession,
            completedFocusCount: state.completedFocusCount + increment,
            secondsRemaining: transition.duration,
            isWarmup: false
        )
    }

    public func validateReflection(_ text: String) throws {
        let words = text
            .split { $0.isWhitespace || $0.isNewline }
            .map(String.init)
            .filter { !$0.isEmpty }

        guard words.count >= config.minimumReflectionWordCount else {
            throw ReflectionValidationError.tooShort(requiredWords: config.minimumReflectionWordCount)
        }
    }
}
