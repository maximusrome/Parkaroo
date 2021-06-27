
//
//  NotificationsSheet.swift
//  Parkaroo
//
//  Created by max rome on 5/22/21.
//
import SwiftUI

struct NotificationsSheet : View {
    @EnvironmentObject var userInfo: UserInfo
    var body : some View {
        VStack {
            Toggle(isOn: self.$userInfo.user.basicNotifications, label: {
                Text("Notifications")
                    .bold()
                    .font(.title2)
            })
            .padding(.horizontal)
            .padding(.bottom)
            .onChange(of: self.userInfo.user.basicNotifications, perform: { value in
                FBFirestore.mergeFBUser([C_BASICNOTIFICATIONS:value], uid: self.userInfo.user.uid) { result in
                }
            })
            Text("Receive notifications when spots are made available. Helpful when looking for parking.\n")
            Text("Disclaimer: Make sure your notifications are enabled for Parkaroo in your Settings app.")
        }.padding(.bottom, (UIApplication.shared.windows.last?.safeAreaInsets.bottom)! + 100)
        .padding(.horizontal)
        .padding(.top, 25)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(25)
    }
}
struct NotificationsSheet_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsSheet()
            .environmentObject(UserInfo())
    }
}
