//
//  SendableBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Michael on 1/10/25.
//

import SwiftUI

actor CurrentUserManager {
    
    func updateDatabase(userInfo: MyClassUserInfo) {
        
    }
    
}

struct MyUserInfo: Sendable {
    var name: String
}

final class MyClassUserInfo: @unchecked Sendable { // @unchecked is dangerous! Compiler not gonna to check that
    private var name: String
    let queue = DispatchQueue(label: "com.MyApp.MyClassUserInfo") // make class thread safe
    
    init(name: String) {
        self.name = name
    }
    
    func updateName(name: String) {
        queue.async {
             self.name = name
        }
    }
}

class SendableBootcampViewModel: ObservableObject {
    
    let manager = CurrentUserManager()
    
    func updateCurrentUserInfo() async {
        
        let info = MyClassUserInfo(name: "info")
        
        await manager.updateDatabase(userInfo: info)
    }
    
}

struct SendableBootcamp: View {
    
    @StateObject private var viewModel = SendableBootcampViewModel()
    
    var body: some View {
        Text("Hello, World!")
            .task {
                
            }
    }
}

#Preview {
    SendableBootcamp()
}
