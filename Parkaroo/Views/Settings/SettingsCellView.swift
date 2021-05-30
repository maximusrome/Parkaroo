//
//  SettingsCellView.swift
//  Parkaroo
//
//  Created by max rome on 5/15/21.
//
import SwiftUI

struct SettingsCell: View {
    var title : String
    var imgName : String
    var body: some View {
        HStack {
            Image(systemName: imgName)
                .font(.headline)
                .foregroundColor(Color("black1"))
            Text(title)
                .font(.headline)
                .foregroundColor(Color("black1"))
                .padding(.leading, 10)
            Spacer()
        }
    }
}
struct SettingsCell_Previews: PreviewProvider {
    static var previews: some View {
        SettingsCell(title: "Features", imgName: "sparks")
    }
}
