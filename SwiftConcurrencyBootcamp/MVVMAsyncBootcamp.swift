//
//  MVVMAsyncBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Michael on 1/11/25.
//

import SwiftUI

final class MyManagerClass {
    
    func getData() async throws -> String {
        "Some Data!"
    }
    
}

actor MyManagerActor {
    
    func getData() async throws -> String {
        "Some Data!"
    }
    
}

@MainActor final class MVVMAsyncBootcampViewModel: ObservableObject {
    
    let managerClass = MyManagerClass()
    let managerActor = MyManagerActor()
    
    @Published private(set) var myData: String = "Starting text"
    private var tasks: [Task<Void, Never>] = []
    
    func cancelTasks() {
        tasks.forEach({ $0.cancel() })
        tasks = []
    }
    
    func onCallToActionButtonPress() {
        let task = Task {
           do {
//               myData = try await managerClass.getData()
               myData = try await managerActor.getData()

           } catch  {
               print(error)
           }
        }
        tasks.append(task)
    }
    
}

struct MVVMAsyncBootcamp: View {
    
    @StateObject private var viewModel = MVVMAsyncBootcampViewModel()
    
    var body: some View {
        VStack {
            Button(viewModel.myData) {
                viewModel.onCallToActionButtonPress()
            }
        }
        .onDisappear {
            
        }
    }
}

#Preview {
    MVVMAsyncBootcamp()
}
