//
//  ContentView.swift
//  Messenger
//
//  Created by Амир Кайдаров on 1/9/23.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        LoginView()
            .fullScreenCover(isPresented: $authViewModel.isUserLoggedIn) {
                MainMessagesView()
            }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
