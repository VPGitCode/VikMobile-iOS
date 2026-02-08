import SwiftUI

// MARK: - Data

private struct Project {
    let name: String
    let description: String
    let techStack: [String]
    let icon: String // SF Symbol name
}

private let chipLinks: [String: String] = [
    "Photos": "photos",
    "Bio": "https://www.linkedin.com/in/vikrampuranik/",
    "AIReady": "https://buildermethods.com/",
    "Yoga": "https://divyayoga.com/",
    "Meditation": "https://sivananda.org.in/",
    "HinduWayOfLife": "https://hinduwebsite.com/",
    "AIFirstLeader": "https://www.anthropic.com/",
    "NewInHorizon": "https://www.moltbook.com/",
    "AiFirst Business": "https://www.birlasoft.com/"
]

private let projects = [
    Project(
        name: "MyApp",
        description: "Everyday productivity App that makes me happy, productive and AIReady.",
        techStack: ["Photos", "Bio", "AIReady"],
        icon: "iphone"
    ),
    Project(
        name: "Consciousness",
        description: "The Hindu way of life and building a positive consciousness in society.",
        techStack: ["Yoga", "Meditation", "HinduWayOfLife"],
        icon: "sparkles"
    ),
    Project(
        name: "AiFirst Initiatives",
        description: "My AIFirstInitiatives across spectrum of my company,new business and research in AI.",
        techStack: ["AIFirstLeader", "NewInHorizon", "AiFirst Business"],
        icon: "globe"
    )
]

// MARK: - Screen

struct ProjectsScreen: View {
    @Environment(\.saffronColors) private var colors

    var body: some View {
        VStack(spacing: 0) {
            SaffronTopBar(title: "Projects")

            ScrollView {
                VStack(spacing: 12) {
                    ForEach(projects, id: \.name) { project in
                        ProjectCard(project: project)
                    }
                }
                .padding(16)
            }
            .background(colors.background)
        }
        .background(colors.background)
    }
}

// MARK: - Card

private struct ProjectCard: View {
    let project: Project
    @Environment(\.saffronColors) private var colors
    @Environment(\.openURL) private var openURL

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                Image(systemName: project.icon)
                    .font(.title2)
                    .foregroundColor(colors.primary)
                    .frame(width: 32, height: 32)

                Text(project.name)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(colors.onSurface)
            }

            Text(project.description)
                .font(.body)
                .foregroundColor(colors.onSurfaceVariant)

            Spacer().frame(height: 4)

            HStack(spacing: 8) {
                ForEach(project.techStack, id: \.self) { tech in
                    ChipButton(label: tech) {
                        handleChipTap(tech)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.12), radius: 4, y: 2)
    }

    private func handleChipTap(_ tech: String) {
        guard let link = chipLinks[tech] else { return }
        if link == "photos" {
            // Open system Photos app
            if let photosURL = URL(string: "photos-redirect://") {
                openURL(photosURL)
            }
        } else if let url = URL(string: link) {
            openURL(url)
        }
    }
}

// MARK: - Chip

private struct ChipButton: View {
    let label: String
    let action: () -> Void
    @Environment(\.saffronColors) private var colors

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.caption)
                .foregroundColor(colors.onSurface)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .strokeBorder(colors.onSurfaceVariant.opacity(0.5), lineWidth: 1)
                )
        }
    }
}
