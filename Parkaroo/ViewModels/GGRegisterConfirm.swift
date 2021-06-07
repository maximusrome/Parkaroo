//
//  GGRegisterConfirm.swift
//  Parkaroo
//
//  Created by max rome on 1/1/21.
//

import Foundation

class GGRequestConfirm: ObservableObject {
    @Published var showGiveRequestView = false
    @Published var showGiveConfirmView = false
    @Published var showBuyerRatingView = false
    @Published var showGetRequestView = false
    @Published var showGetConfirmView = false
    @Published var showSellerRatingView = false
}
