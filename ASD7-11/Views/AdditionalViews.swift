import SwiftUI
// MARK: - Допоміжні View

struct NodeView: View {
    let value: Int
    
    var body: some View {
        Text("\(value)")
            .font(.headline.monospacedDigit())
            .frame(width: 60, height: 60)
            .background(Color.blue.gradient)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.4), lineWidth: 1)
            )
            .shadow(color: .blue.opacity(0.3), radius: 4, x: 2, y: 3)
            .padding(.horizontal, 4)
    }
}

struct ArrowView: View {
    var body: some View {
        Image(systemName: "arrow.right.circle.fill")
            .font(.title2)
            .foregroundStyle(.blue.opacity(0.7))
            .padding(.horizontal, 6)
            .transition(.opacity)
    }
}

struct NilView: View {
    var body: some View {
        LabelView(text: "nil", color: .gray.opacity(0.3))
    }
}

struct LabelView: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text)
            .font(.caption.monospaced())
            .padding(5)
            .frame(width: 50)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(8)
    }
}
struct StandardButton: View {
    let title: String
    let action: () -> Void
    
    init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(Color.blue.gradient)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(color: .blue.opacity(0.2), radius: 2, x: 1, y: 2)
        }
        .buttonStyle(.plain)
    }
}
