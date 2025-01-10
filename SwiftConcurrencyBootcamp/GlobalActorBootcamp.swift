//
//  GlobalActorBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Michael on 1/10/25.
//

import SwiftUI

@globalActor struct MyFirstGlobalActor { // struct or final class
    
    static var shared = MyNewDataManager()
    
}

actor MyNewDataManager {
    
    func getDataFromDataBase() -> [String] {
        return ["One", "Two", "Three", "Four", "Five"]
    }
    
}

//@MainActor
class GlobalActorBootcampViewModel: ObservableObject { // can mark entire class or struct as being on the @MainActor or any other globalActor
    
    @MainActor @Published var dataArray: [String] = []
//     @Published var dataArray1: [String] = []
//     @Published var dataArray2: [String] = []
//     @Published var dataArray3: [String] = []
    let manager = MyFirstGlobalActor.shared
    
//    nonisolated
    @MyFirstGlobalActor func getData()  {
        
        // HEAVY COMPLEX METHODS
        
        Task {
            let data = await manager.getDataFromDataBase()
            await MainActor.run {
                self.dataArray = data
            }
        }
    }
    
}

struct GlobalActorBootcamp: View {
    
    @StateObject private var viewModel = GlobalActorBootcampViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.dataArray, id: \.self) {
                    Text($0)
                        .font(.headline)
                }
            }
        }
        .task {
            await viewModel.getData()
        }
    }
}

#Preview {
    GlobalActorBootcamp()
}
