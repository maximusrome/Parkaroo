
//
//  NotificationsSheet.swift
//  Parkaroo
//
//  Created by max rome on 5/22/21.
//
import SwiftUI

struct NotificationsSheet : View {
    @State var show1 = false
    @State var show2 = false
    var body : some View {
        VStack(spacing: 20){
            Toggle(isOn: self.$show1) {
                Text("Basic Notifications")
                    .bold()
                    .font(.title2)
            }
            Text("Basic: Be alerted when someone reserves your spot or cancels their reservation *Essential*")
            Toggle(isOn: self.$show2) {
                Text("Advanced Notifications")
                    .bold()
                    .font(.title2)
            }
            Text("Advanced: Be alerted immediately when spots are made avaliable *Enable when looking for parking*")
        }.padding(.bottom, (UIApplication.shared.windows.last?.safeAreaInsets.bottom)! + 25)
        .padding(.horizontal)
        .padding(.top, 25)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(25)
        
    }
}
