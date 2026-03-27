import Foundation

public struct StreakSnapshot: Equatable, Sendable {
    public var current: Int
    public var best: Int
    public var lastCompletionDate: Date?

    public init(current: Int = 0, best: Int = 0, lastCompletionDate: Date? = nil) {
        self.current = current
        self.best = best
        self.lastCompletionDate = lastCompletionDate
    }
}

public struct StreakTracker: Sendable {
    public init() {}

    public func registerCompletion(
        on completionDate: Date,
        snapshot: StreakSnapshot,
        calendar: Calendar = .current
    ) -> StreakSnapshot {
        let day = calendar.startOfDay(for: completionDate)
        guard let last = snapshot.lastCompletionDate else {
            return StreakSnapshot(current: 1, best: max(snapshot.best, 1), lastCompletionDate: day)
        }

        let lastDay = calendar.startOfDay(for: last)
        if day == lastDay {
            return snapshot
        }

        let previousDay = calendar.date(byAdding: .day, value: 1, to: lastDay)
        if previousDay == day {
            let current = snapshot.current + 1
            return StreakSnapshot(current: current, best: max(snapshot.best, current), lastCompletionDate: day)
        }

        return StreakSnapshot(current: 1, best: max(snapshot.best, 1), lastCompletionDate: day)
    }
}
