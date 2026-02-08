import SwiftUI
import PhotosUI

private let tabTitles = [
    "Favourite Photos",
    "Favourite Photos Two",
    "My Documents 1",
    "My Documents 2"
]

private let slotsPerTab = 6

struct HomeScreen: View {
    @Environment(\.saffronColors) private var colors
    @State private var selectedTab = 0
    @State private var photos: [[UIImage?]] = Array(
        repeating: Array(repeating: nil, count: slotsPerTab),
        count: tabTitles.count
    )
    @State private var pendingSlot = 0
    @State private var showPicker = false
    @State private var selectedItem: PhotosPickerItem?
    @State private var fullscreenImage: UIImage?

    var body: some View {
        VStack(spacing: 0) {
            // Top bar
            SaffronTopBar(title: "MyApp: My Happiness, Productivity & Identity")

            // Scrollable tab row
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(tabTitles.indices, id: \.self) { index in
                        Button {
                            withAnimation { selectedTab = index }
                        } label: {
                            VStack(spacing: 6) {
                                Text(tabTitles[index])
                                    .font(.subheadline)
                                    .fontWeight(selectedTab == index ? .semibold : .regular)
                                    .foregroundColor(selectedTab == index ? colors.primary : colors.onSurfaceVariant)
                                    .padding(.horizontal, 16)
                                    .padding(.top, 12)

                                Rectangle()
                                    .fill(selectedTab == index ? colors.primary : .clear)
                                    .frame(height: 3)
                            }
                        }
                    }
                }
            }
            .background(colors.surface)

            // Photo grid
            ScrollView {
                LazyVGrid(columns: [gridColumn(), gridColumn()], spacing: 12) {
                    ForEach(0..<slotsPerTab, id: \.self) { slotIndex in
                        if let image = photos[selectedTab][slotIndex] {
                            FilledPhotoSlot(
                                image: image,
                                label: "Photo \(slotIndex + 1)",
                                onTap: { fullscreenImage = image },
                                onChange: {
                                    pendingSlot = slotIndex
                                    showPicker = true
                                },
                                onShare: { shareImage(image) }
                            )
                        } else {
                            EmptyPhotoSlot {
                                pendingSlot = slotIndex
                                showPicker = true
                            }
                        }
                    }
                }
                .padding(16)
            }
            .background(colors.background)
        }
        .background(colors.background)
        .photosPicker(isPresented: $showPicker, selection: $selectedItem, matching: .images)
        .onChange(of: selectedItem) { _, newItem in
            guard let newItem else { return }
            Task {
                if let data = try? await newItem.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    photos[selectedTab][pendingSlot] = uiImage
                    PhotoStorage.savePhoto(tab: selectedTab, slot: pendingSlot, image: uiImage)
                }
                selectedItem = nil
            }
        }
        .onAppear {
            photos = PhotoStorage.loadAllTabs()
        }
        .fullScreenCover(item: $fullscreenImage) { image in
            FullscreenPhotoView(image: image)
        }
    }

    private func shareImage(_ image: UIImage) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootVC = window.rootViewController else { return }
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = window
        activityVC.popoverPresentationController?.sourceRect = CGRect(
            x: window.bounds.midX, y: window.bounds.midY, width: 0, height: 0
        )
        rootVC.present(activityVC, animated: true)
    }

    private func gridColumn() -> GridItem {
        GridItem(.flexible(), spacing: 12)
    }
}

// MARK: - Empty Slot

private struct EmptyPhotoSlot: View {
    let onTap: () -> Void
    @Environment(\.saffronColors) private var colors

    var body: some View {
        Button(action: onTap) {
            RoundedRectangle(cornerRadius: 12)
                .fill(colors.surfaceVariant)
                .aspectRatio(1, contentMode: .fit)
                .overlay {
                    Image(systemName: "plus.circle")
                        .font(.system(size: 40))
                        .foregroundColor(colors.onSurfaceVariant)
                }
                .shadow(color: .black.opacity(0.08), radius: 2, y: 1)
        }
    }
}

// MARK: - Filled Slot

private struct FilledPhotoSlot: View {
    let image: UIImage
    let label: String
    let onTap: () -> Void
    let onChange: () -> Void
    let onShare: () -> Void
    @Environment(\.saffronColors) private var colors

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 0) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .aspectRatio(1, contentMode: .fill)
                    .clipped()
                    .clipShape(UnevenRoundedRectangle(topLeadingRadius: 12, topTrailingRadius: 12))

                Text(label)
                    .font(.subheadline)
                    .padding(8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(colors.onSurface)
            }
            .background(colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.12), radius: 4, y: 2)
            .onTapGesture(perform: onTap)

            // Edit button (top-right)
            Button(action: onChange) {
                Image(systemName: "pencil")
                    .font(.caption)
                    .foregroundColor(colors.onPrimaryContainer)
                    .frame(width: 28, height: 28)
                    .background(colors.primaryContainer.opacity(0.85))
                    .clipShape(Circle())
            }
            .padding(6)

            // Share button (bottom-right)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: onShare) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.caption)
                            .foregroundColor(colors.onPrimaryContainer)
                            .frame(width: 32, height: 32)
                            .background(colors.primaryContainer.opacity(0.85))
                            .clipShape(Circle())
                    }
                    .padding(8)
                }
            }
        }
    }
}

// MARK: - Fullscreen Photo

extension UIImage: @retroactive Identifiable {
    public var id: ObjectIdentifier { ObjectIdentifier(self) }
}

private struct FullscreenPhotoView: View {
    let image: UIImage
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.black.opacity(0.92)
                .ignoresSafeArea()
                .onTapGesture { dismiss() }

            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .padding(16)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack {
                HStack {
                    Spacer()
                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(.white.opacity(0.2))
                            .clipShape(Circle())
                    }
                    .padding(24)
                }
                Spacer()
            }
        }
    }
}
