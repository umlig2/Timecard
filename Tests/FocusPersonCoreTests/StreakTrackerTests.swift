import XCTest
@testable import FocusPersonCore

final class StreakTrackerTests: XCTestCase {
    func testStreakIncrementsOnConsecutiveDaysAndResetsAfterGap() {
        let tracker = StreakTracker()
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!

        let day1 = Date(timeIntervalSince1970: 1_700_000_000)
        let day2 = calendar.date(byAdding: .day, value: 1, to: day1)!
        let day4 = calendar.date(byAdding: .day, value: 3, to: day1)!

        let first = tracker.registerCompletion(on: day1, snapshot: .init(), calendar: calendar)
        XCTAssertEqual(first.current, 1)
        XCTAssertEqual(first.best, 1)

        let second = tracker.registerCompletion(on: day2, snapshot: first, calendar: calendar)
        XCTAssertEqual(second.current, 2)
        XCTAssertEqual(second.best, 2)

        let reset = tracker.registerCompletion(on: day4, snapshot: second, calendar: calendar)
        XCTAssertEqual(reset.current, 1)
        XCTAssertEqual(reset.best, 2)
    }
}
