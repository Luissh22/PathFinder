//
//  ToolBarView.swift
//  PathFinder
//
//  Created by Luis Abraham on 2020-12-24.
//

import SwiftUI

struct ButtonConfig {
    let label: String
    let action: () -> Void
}

struct ToolBarView: View {
    let buttons: [ButtonConfig]
    
    var body: some View {
        HStack {
            ForEach(buttons, id: \.label) { button in
                buttonFor(button.label, action: button.action)
            }
        }
    }
    
    private func buttonFor(_ label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
        }
    }
}
