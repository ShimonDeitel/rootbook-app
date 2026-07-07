import SwiftUI

/// mossy propagation green on soil brown-black
enum Theme {
    static let accent = Color(red: 0.3608, green: 0.4784, blue: 0.2353)
    static let accentSecondary = Color(red: 0.1647, green: 0.2000, blue: 0.1059)
    static let background = Color(red: 0.0863, green: 0.1020, blue: 0.0627)
    static let cardBackground = background.opacity(0.6)

    static let titleFont = Font.system(.title2, design: .rounded).weight(.bold)
    static let headlineFont = Font.system(.headline, design: .rounded)
    static let bodyFont = Font.system(.body, design: .rounded)
    static let captionFont = Font.system(.caption, design: .rounded)

    static let cornerRadius: CGFloat = 16
}
