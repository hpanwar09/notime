import SwiftUI

struct TimeRemainingView: View {
    @State private var now = Date()
    @AppStorage("alwaysOnTop") private var alwaysOnTop = false

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let calc = TimeCalculator()

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("NOTIME")
                .font(.system(size: 10, weight: .heavy, design: .monospaced))
                .foregroundStyle(.white.opacity(0.35))
                .tracking(4)

            row(hourLabel, remaining: calc.hourRemaining(now), progress: calc.hourProgress(now))
            row(dayLabel, remaining: calc.dayRemaining(now), progress: calc.dayProgress(now))
            row(weekLabel, remaining: calc.weekRemaining(now), progress: calc.weekProgress(now))
            row(monthLabel, remaining: calc.monthRemaining(now), progress: calc.monthProgress(now))
            row(yearLabel, remaining: calc.yearRemaining(now), progress: calc.yearProgress(now))

            Spacer(minLength: 0)
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(.ultraThinMaterial)
                .environment(\.colorScheme, .dark)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .strokeBorder(.white.opacity(0.08), lineWidth: 1)
        )
        .overlay(alignment: .bottomTrailing) {
            ResizeHandle()
                .frame(width: 16, height: 16)
                .padding(.trailing, 4.5)
                .padding(.bottom, 15)
        }
        .onReceive(timer) { now = $0 }
        .onChange(of: alwaysOnTop) { _ in
            NotificationCenter.default.post(name: .init("notime.windowLevel"), object: nil)
        }
        .contextMenu { contextMenuContent }
    }

    private var hourLabel: String {
        let h = Calendar.current.component(.hour, from: now)
        let suffix = h >= 12 ? "PM" : "AM"
        let display = h == 0 ? 12 : (h > 12 ? h - 12 : h)
        return "\(display) \(suffix)"
    }

    private var dayLabel: String {
        let f = DateFormatter()
        f.dateFormat = "MMM d"
        return f.string(from: now).uppercased()
    }

    private var weekLabel: String {
        "WEEK \(Calendar.current.component(.weekOfYear, from: now))"
    }

    private var monthLabel: String {
        let f = DateFormatter()
        f.dateFormat = "MMMM"
        return f.string(from: now).uppercased()
    }

    private var yearLabel: String {
        "\(Calendar.current.component(.year, from: now))"
    }

    @ViewBuilder
    private var contextMenuContent: some View {
        Button {
            alwaysOnTop.toggle()
        } label: {
            if alwaysOnTop {
                Label("Always on Top", systemImage: "checkmark")
            } else {
                Text("Always on Top")
            }
        }
        Divider()
        Button("Reset Position") {
            NotificationCenter.default.post(name: .init("notime.resetFrame"), object: nil)
        }
        Button("Reset Size") {
            NotificationCenter.default.post(name: .init("notime.resetSize"), object: nil)
        }
        Divider()
        Button("Quit notime") { NSApplication.shared.terminate(nil) }
    }

    private func row(_ label: String, remaining: String, progress: Double) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .firstTextBaseline) {
                Text(label)
                    .font(.system(size: 10, weight: .semibold, design: .monospaced))
                    .foregroundStyle(.white.opacity(0.45))
                Spacer()
                Text(remaining)
                    .font(.system(size: 13, weight: .medium, design: .monospaced))
                    .foregroundStyle(.white.opacity(0.9))
            }

            HStack(spacing: 8) {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(.white.opacity(0.06))
                        RoundedRectangle(cornerRadius: 2)
                            .fill(barColor(progress))
                            .frame(width: max(geo.size.width * progress, 0))
                            .animation(.linear(duration: 1), value: progress)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 7)

                Text(pct(progress))
                    .font(.system(size: 9, weight: .medium, design: .monospaced))
                    .foregroundStyle(.white.opacity(0.3))
                    .frame(width: 40, alignment: .trailing)
            }
        }
    }

    private func barColor(_ progress: Double) -> Color {
        let hue = 0.48 * (1 - progress)
        let sat = 0.55 + progress * 0.25
        return Color(hue: max(hue, 0), saturation: sat, brightness: 0.85)
    }

    private func pct(_ p: Double) -> String {
        String(format: "%.1f%%", p * 100)
    }
}
