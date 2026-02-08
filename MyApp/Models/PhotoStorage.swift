import UIKit

/// Persists photos as JPEG files in the app's Documents directory.
struct PhotoStorage {
    private static var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    // MARK: - Tab Photos

    private static func photoURL(tab: Int, slot: Int) -> URL {
        documentsDirectory.appendingPathComponent("tab_\(tab)_slot_\(slot).jpg")
    }

    static func savePhoto(tab: Int, slot: Int, image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 0.85) else { return }
        try? data.write(to: photoURL(tab: tab, slot: slot))
    }

    static func loadPhoto(tab: Int, slot: Int) -> UIImage? {
        let url = photoURL(tab: tab, slot: slot)
        guard let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }

    static func deletePhoto(tab: Int, slot: Int) {
        try? FileManager.default.removeItem(at: photoURL(tab: tab, slot: slot))
    }

    // MARK: - Profile Photo

    private static var profilePhotoURL: URL {
        documentsDirectory.appendingPathComponent("profile_photo.jpg")
    }

    static func saveProfilePhoto(_ image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 0.85) else { return }
        try? data.write(to: profilePhotoURL)
    }

    static func loadProfilePhoto() -> UIImage? {
        guard let data = try? Data(contentsOf: profilePhotoURL) else { return nil }
        return UIImage(data: data)
    }

    // MARK: - Load All Tabs

    static func loadAllTabs(tabCount: Int = 4, slotsPerTab: Int = 6) -> [[UIImage?]] {
        (0..<tabCount).map { tab in
            (0..<slotsPerTab).map { slot in
                loadPhoto(tab: tab, slot: slot)
            }
        }
    }
}
