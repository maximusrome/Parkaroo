
//
//  NotificationsSheet.swift
//  Parkaroo
//
//  Created by max rome on 5/22/21.
//
import SwiftUI

struct NotificationsSheet : View {
    
    @EnvironmentObject var userInfo: UserInfo
    
    @State var show1 = false
    @State var show2 = false
    
    var body : some View {
        VStack(spacing: 20){
            Toggle(isOn: self.$userInfo.user.basicNotifications, label: {
                Text("Basic Notifications")
                    .bold()
                    .font(.title2)
            })
            .onChange(of: self.userInfo.user.basicNotifications, perform: { value in
                FBFirestore.mergeFBUser([C_BASICNOTIFICATIONS:value], uid: self.userInfo.user.uid) { result in
                    
                }
            })
            Text("Basic: Be alerted when someone reserves your spot or cancels their reservation *Essential*")
            
            Toggle(isOn: self.$userInfo.user.advancedNotifications, label: {
                Text("Advanced Notifications")
                    .bold()
                    .font(.title2)
            })
            .onChange(of: self.userInfo.user.advancedNotifications, perform: { value in
                FBFirestore.mergeFBUser([C_ADVANCEDNOTIFICATIONS:value], uid: self.userInfo.user.uid) { result in
                    
                }
            })
            Text("Advanced: Be alerted immediately when spots are made avaliable *Enable when looking for parking*")
        }.padding(.bottom, (UIApplication.shared.windows.last?.safeAreaInsets.bottom)! + 25)
        .padding(.horizontal)
        .padding(.top, 25)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(25)
        
    }
}
