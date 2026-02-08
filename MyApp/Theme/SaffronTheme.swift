import SwiftUI

// MARK: - Saffron Color Palette

extension Color {
    // Light theme
    static let saffronPrimaryLight        = Color(hex: 0x9A5800)
    static let saffronOnPrimaryLight      = Color.white
    static let saffronContainerLight      = Color(hex: 0xE8BA70)
    static let saffronOnContainerLight    = Color(hex: 0x2A1800)
    static let saffronBackgroundLight     = Color(hex: 0xFFF8F0)
    static let saffronSurfaceLight        = Color(hex: 0xFFF8F0)
    static let saffronSurfaceVariantLight = Color(hex: 0xE4D0B8)
    static let saffronOnSurfaceLight      = Color(hex: 0x1F1B16)
    static let saffronOnSurfaceVarLight   = Color(hex: 0x453828)

    // Dark theme
    static let saffronPrimaryDark         = Color(hex: 0xE8A330)
    static let saffronOnPrimaryDark       = Color(hex: 0x3D2000)
    static let saffronContainerDark       = Color(hex: 0x583000)
    static let saffronOnContainerDark     = Color(hex: 0xD48020)
    static let saffronBackgroundDark      = Color(hex: 0x121212)
    static let saffronSurfaceDark         = Color(hex: 0x1A1710)
    static let saffronSurfaceVariantDark  = Color(hex: 0x43392D)
    static let saffronOnSurfaceDark       = Color(hex: 0xE0D3C2)
    static let saffronOnSurfaceVarDark    = Color(hex: 0xC8B8A4)

    init(hex: UInt, opacity: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: opacity
        )
    }
}

// MARK: - Adaptive Saffron Colors

struct SaffronColors {
    let colorScheme: ColorScheme

    var primary: Color {
        colorScheme == .dark ? .saffronPrimaryDark : .saffronPrimaryLight
    }
    var onPrimary: Color {
        colorScheme == .dark ? .saffronOnPrimaryDark : .saffronOnPrimaryLight
    }
    var primaryContainer: Color {
        colorScheme == .dark ? .saffronContainerDark : .saffronContainerLight
    }
    var onPrimaryContainer: Color {
        colorScheme == .dark ? .saffronOnContainerDark : .saffronOnContainerLight
    }
    var background: Color {
        colorScheme == .dark ? .saffronBackgroundDark : .saffronBackgroundLight
    }
    var surface: Color {
        colorScheme == .dark ? .saffronSurfaceDark : .saffronSurfaceLight
    }
    var surfaceVariant: Color {
        colorScheme == .dark ? .saffronSurfaceVariantDark : .saffronSurfaceVariantLight
    }
    var onSurface: Color {
        colorScheme == .dark ? .saffronOnSurfaceDark : .saffronOnSurfaceLight
    }
    var onSurfaceVariant: Color {
        colorScheme == .dark ? .saffronOnSurfaceVarDark : .saffronOnSurfaceVarLight
    }
}

// MARK: - Environment Key

private struct SaffronColorsKey: EnvironmentKey {
    static let defaultValue = SaffronColors(colorScheme: .light)
}

extension EnvironmentValues {
    var saffronColors: SaffronColors {
        get { self[SaffronColorsKey.self] }
        set { self[SaffronColorsKey.self] = newValue }
    }
}

// MARK: - Theme Modifier

struct SaffronThemeModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme

    func body(content: Content) -> some View {
        content
            .environment(\.saffronColors, SaffronColors(colorScheme: colorScheme))
    }
}

extension View {
    func saffronTheme() -> some View {
        modifier(SaffronThemeModifier())
    }
}

// MARK: - Card Style

struct SaffronCardStyle: ViewModifier {
    @Environment(\.saffronColors) private var colors

    func body(content: Content) -> some View {
        content
            .background(colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
    }
}

extension View {
    func saffronCard() -> some View {
        modifier(SaffronCardStyle())
    }
}

// MARK: - Top Bar Style

struct SaffronTopBar: View {
    let title: String
    @Environment(\.saffronColors) private var colors

    var body: some View {
        Text(title)
            .font(.headline)
            .foregroundColor(colors.onPrimaryContainer)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(colors.primaryContainer)
    }
}
