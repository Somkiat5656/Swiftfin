//
// Swiftfin is subject to the terms of the Mozilla Public
// License, v2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at https://mozilla.org/MPL/2.0/.
//
// Copyright (c) 2024 Jellyfin & Jellyfin Contributors
//

import Defaults
import Factory
import JellyfinAPI
import SwiftUI

extension DevicesView {

    struct DeviceRow: View {

        @Default(.accentColor)
        private var accentColor

        // MARK: - Environment Variables

        @Environment(\.colorScheme)
        private var colorScheme
        @Environment(\.isEditing)
        private var isEditing
        @Environment(\.isSelected)
        private var isSelected

        @CurrentDate
        private var currentDate: Date

        // MARK: - Observed Objects

        let device: DeviceInfo
        let onSelect: () -> Void
        let onDelete: () -> Void

        // MARK: - Label Styling

        private var labelForegroundStyle: some ShapeStyle {
            guard isEditing else { return .primary }

            return isSelected ? .primary : .secondary
        }

        // MARK: - Device Image View

        @ViewBuilder
        private var deviceImage: some View {
            ZStack {
                device.type.clientColor

                Image(device.type.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40)

                if isEditing {
                    Color.black
                        .opacity(isSelected ? 0 : 0.5)
                }
            }
            .squarePosterStyle()
            .posterShadow()
            .frame(width: 60, height: 60)
        }

        // MARK: - Row Content

        @ViewBuilder
        private var rowContent: some View {
            HStack {
                VStack(alignment: .leading) {

                    Text(device.name ?? L10n.unknown)
                        .font(.headline)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)

                    TextPairView(
                        leading: L10n.user,
                        trailing: device.lastUserName ?? L10n.unknown
                    )

                    TextPairView(
                        leading: L10n.client,
                        trailing: device.appName ?? L10n.unknown
                    )

                    TextPairView(
                        L10n.lastSeen,
                        value: Text(device.dateLastActivity, format: .lastSeen)
                    )
                    .id(currentDate)
                    .monospacedDigit()
                }
                .font(.subheadline)
                .foregroundStyle(labelForegroundStyle, .secondary)

                Spacer()

                if isEditing, isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .backport
                        .fontWeight(.bold)
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(accentColor.overlayColor, accentColor)

                } else if isEditing {
                    Image(systemName: "circle")
                        .resizable()
                        .backport
                        .fontWeight(.bold)
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.secondary)
                }
            }
        }

        // MARK: - Body

        var body: some View {
            ListRow(insets: .init(horizontal: EdgeInsets.edgePadding)) {
                deviceImage
            } content: {
                rowContent
                    .padding(.vertical, 8)
            }
            .onSelect(perform: onSelect)
            .swipeActions {
                Button(
                    L10n.delete,
                    systemImage: "trash",
                    action: onDelete
                )
                .tint(.red)
            }
        }
    }
}
