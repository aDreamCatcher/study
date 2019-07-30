//
//  ProfileEditor.swift
//  Landmarks
//
//  Created by Guiyang Li on 2019/7/30.
//  Copyright © 2019 Xin. All rights reserved.
//

import SwiftUI

struct ProfileEditor: View {
    @Binding var profile: Profile

    var dateRange: ClosedRange<Date> {
        let min = Calendar.current.date(byAdding: .year, value: -1, to: profile.goalDate)!
        let max = Calendar.current.date(byAdding: .year, value: 1, to: profile.goalDate)!
        return min...max
    }

    var body: some View {
        List {
            HStack {
                Text("Username").bold()
                Divider()
                TextField("Username", text: $profile.username)
            }

            Toggle(isOn: $profile.prefersNotifications) {
                Text("Enable Notifications")
            }

            VStack(alignment: .leading, spacing: 20) {
                Text("Seasonal Photo").bold()

                SegmentedControl(selection: $profile.seasonalPhoto) {
                    ForEach(Profile.Season.allCases, id: \.self) { season in
                        Text(season.rawValue).tag(season)
                    }
                }
            }
            .padding(.top)

            VStack(alignment: .leading, spacing: 20) {
                Text("Global Date").bold()
                DatePicker(
                    selection: $profile.goalDate,
                    in: dateRange,
                    displayedComponents: .date) { () -> EmptyView in
                }
            }
        }
    }
}

#if DEBUG
struct ProfileEditor_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditor(profile: .constant(.default))
    }
}
#endif
