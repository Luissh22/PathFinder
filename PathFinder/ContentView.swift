//
//  ContentView.swift
//  PathFinder
//
//  Created by Luis Abraham on 2020-12-24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GridView()
            .padding()
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .frame(idealWidth: 700, idealHeight: 500)
    }
}
