//
//  GGRegisterConfirm.swift
//  Parkaroo
//
//  Created by max rome on 1/1/21.
//

import Foundation

class GGRequestConfirm: ObservableObject {
    @Published var showBox1 = false
    @Published var showBox2 = false
    @Published var showBox3 = false
    @Published var showBox4 = false
    @Published var moveBox = false
    @Published var moveBox1 = false
    @Published var showingYouGotCreditAlert = false
}
