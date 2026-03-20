import SwiftUI

struct TimeRemainingView: View {
    @State private var now = Date()
    @AppStorage("alwaysOnTop") private var alwaysOnTop = false

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let calc = TimeCalculator()

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("notime")
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundStyle(.secondary)

            row(dayLabel,   remaining: calc.dayRemaining(now),   progress: calc.dayProgress(now),   tint: .blue)
            row(weekLabel,  remaining: calc.weekRemaining(now),  progress: calc.weekProgress(now),  tint: .cyan)
            row(monthLabel, remaining: calc.monthRemaining(now), progress: calc.monthProgress(now), tint: .orange)
            row(yearLabel,  remaining: calc.yearRemaining(now),  progress: calc.yearProgress(now),  tint: .purple)

            Spacer(minLength: 0)
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.regularMaterial)
                .environment(\.colorScheme, .dark)
        )
        .overlay(alignment: .trailing) {
            ResizeHandle()
                .frame(width: 12, height: 40)
                .padding(.trailing, 2)
        }
        .onReceive(timer) { now = $0 }
        .onChange(of: alwaysOnTop) { _ in
            NotificationCenter.default.post(name: .init("notime.windowLevel"), object: nil)
        }
        .contextMenu { contextMenuContent }
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
        Menu("Size") {
            Button("Compact") { setWidth(240) }
            Button("Normal")  { setWidth(320) }
            Button("Wide")    { setWidth(450) }
        }
        Divider()
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
        Divider()
        Button("Quit notime") { NSApplication.shared.terminate(nil) }
    }

    private func setWidth(_ w: CGFloat) {
        NotificationCenter.default.post(name: .init("notime.setWidth"), object: w)
    }

    private func row(_ label: String, remaining: String, progress: Double, tint: Color) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(alignment: .firstTextBaseline) {
                Text(label)
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundStyle(.secondary)
                Spacer()
                Text(remaining)
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundStyle(.primary)
            }

            HStack(spacing: 8) {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(tint.opacity(0.18))
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [tint, tint.opacity(0.7)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: max(geo.size.width * progress, 0))
                            .animation(.easeInOut(duration: 1), value: progress)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 6)

                Text(pct(progress))
                    .font(.system(size: 10, weight: .medium, design: .rounded))
                    .foregroundStyle(.tertiary)
                    .frame(width: 40, alignment: .trailing)
            }
        }
    }

    private func pct(_ p: Double) -> String {
        String(format: "%.1f%%", p * 100)
    }
}
