import Foundation

struct TimeCalculator {
    private let cal = Calendar.current

    func hourProgress(_ now: Date) -> Double {
        let start = cal.date(from: cal.dateComponents([.year, .month, .day, .hour], from: now))!
        let end = cal.date(byAdding: .hour, value: 1, to: start)!
        return elapsed(start: start, end: end, now: now)
    }

    func hourRemaining(_ now: Date) -> String {
        let start = cal.date(from: cal.dateComponents([.year, .month, .day, .hour], from: now))!
        let end = cal.date(byAdding: .hour, value: 1, to: start)!
        return formatShort(end.timeIntervalSince(now))
    }

    func dayProgress(_ now: Date) -> Double {
        let start = cal.startOfDay(for: now)
        let end = cal.date(byAdding: .day, value: 1, to: start)!
        return elapsed(start: start, end: end, now: now)
    }

    func dayRemaining(_ now: Date) -> String {
        let end = cal.date(byAdding: .day, value: 1, to: cal.startOfDay(for: now))!
        return format(end.timeIntervalSince(now))
    }

    func weekProgress(_ now: Date) -> Double {
        let start = cal.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: now).date!
        let end = cal.date(byAdding: .weekOfYear, value: 1, to: start)!
        return elapsed(start: start, end: end, now: now)
    }

    func weekRemaining(_ now: Date) -> String {
        let start = cal.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: now).date!
        let end = cal.date(byAdding: .weekOfYear, value: 1, to: start)!
        return format(end.timeIntervalSince(now))
    }

    func monthProgress(_ now: Date) -> Double {
        let start = cal.date(from: cal.dateComponents([.year, .month], from: now))!
        let end = cal.date(byAdding: .month, value: 1, to: start)!
        return elapsed(start: start, end: end, now: now)
    }

    func monthRemaining(_ now: Date) -> String {
        let start = cal.date(from: cal.dateComponents([.year, .month], from: now))!
        let end = cal.date(byAdding: .month, value: 1, to: start)!
        return format(end.timeIntervalSince(now))
    }

    func yearProgress(_ now: Date) -> Double {
        let start = cal.date(from: cal.dateComponents([.year], from: now))!
        let end = cal.date(byAdding: .year, value: 1, to: start)!
        return elapsed(start: start, end: end, now: now)
    }

    func yearRemaining(_ now: Date) -> String {
        let start = cal.date(from: cal.dateComponents([.year], from: now))!
        let end = cal.date(byAdding: .year, value: 1, to: start)!
        return format(end.timeIntervalSince(now))
    }

    private func elapsed(start: Date, end: Date, now: Date) -> Double {
        let total = end.timeIntervalSince(start)
        guard total > 0 else { return 0 }
        return min(max(now.timeIntervalSince(start) / total, 0), 1)
    }

    private func format(_ interval: TimeInterval) -> String {
        let secs = Int(max(interval, 0))
        let d = secs / 86_400
        let h = (secs % 86_400) / 3_600
        let m = (secs % 3_600) / 60
        let s = secs % 60

        if d > 30 { return "\(d)d" }
        if d > 0  { return "\(d)d \(h)h" }
        return "\(h)h \(m)m \(s)s"
    }

    private func formatShort(_ interval: TimeInterval) -> String {
        let secs = Int(max(interval, 0))
        let m = secs / 60
        let s = secs % 60
        return "\(m)m \(s)s"
    }
}
