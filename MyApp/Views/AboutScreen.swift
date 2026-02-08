import SwiftUI
import PhotosUI

struct AboutScreen: View {
    @Environment(\.saffronColors) private var colors
    @State private var profileImage: UIImage?
    @State private var selectedItem: PhotosPickerItem?

    var body: some View {
        VStack(spacing: 0) {
            SaffronTopBar(title: "About Me")

            ScrollView {
                VStack(spacing: 0) {
                    Spacer().frame(height: 24)

                    // Profile photo
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        ZStack(alignment: .bottomTrailing) {
                            if let profileImage {
                                Image(uiImage: profileImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                            } else {
                                Circle()
                                    .fill(colors.surfaceVariant)
                                    .frame(width: 120, height: 120)
                                    .overlay {
                                        Image(systemName: "person.fill")
                                            .font(.system(size: 50))
                                            .foregroundColor(colors.onSurfaceVariant)
                                    }
                            }

                            // Camera badge
                            Image(systemName: "camera.fill")
                                .font(.caption)
                                .foregroundColor(colors.onPrimaryContainer)
                                .frame(width: 28, height: 28)
                                .background(colors.primaryContainer)
                                .clipShape(Circle())
                        }
                    }

                    Spacer().frame(height: 16)

                    Text("Vikram D Puranik")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(colors.onSurface)

                    Text("Tech Entrepreneur")
                        .font(.title3)
                        .foregroundColor(colors.onSurfaceVariant)

                    Spacer().frame(height: 24)

                    VStack(spacing: 12) {
                        InfoCard(
                            title: "Bio",
                            content: "Passionate about building AIFirst Companies Apps that enhances Human conscious, knowledge and productivity."
                        )

                        InfoCard(
                            title: "Skills",
                            content: "C-Suite,Technocrat,Business Leader"
                        )

                        InfoCard(
                            title: "Education",
                            content: "Bachelor's in Electronics Engineering"
                        )

                        InfoCard(
                            title: "Contact",
                            content: "vikrampuranik@gmail.com"
                        )
                    }
                    .padding(.horizontal, 16)

                    Spacer().frame(height: 24)
                }
            }
            .background(colors.background)
        }
        .background(colors.background)
        .onChange(of: selectedItem) { newItem in
            guard let newItem else { return }
            Task {
                if let data = try? await newItem.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    profileImage = uiImage
                    PhotoStorage.saveProfilePhoto(uiImage)
                }
                selectedItem = nil
            }
        }
        .onAppear {
            profileImage = PhotoStorage.loadProfilePhoto()
        }
    }
}

// MARK: - Info Card

private struct InfoCard: View {
    let title: String
    let content: String
    @Environment(\.saffronColors) private var colors

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(colors.primary)

            Text(content)
                .font(.body)
                .foregroundColor(colors.onSurface)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.08), radius: 2, y: 1)
    }
}
