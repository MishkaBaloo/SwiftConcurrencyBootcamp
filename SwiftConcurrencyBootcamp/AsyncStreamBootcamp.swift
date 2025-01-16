//
//  AsyncStreamBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Michael on 1/16/25.
//

import SwiftUI

class AsyncStreamDataManager {
    
    func getAsyncStream() -> AsyncThrowingStream<Int, Error> {
        AsyncThrowingStream(Int.self) { [weak self] continuation in
            self?.getFakeData(newValue: { value in
                continuation.yield(value)
            }, onFinish: { error in
                    continuation.finish(throwing: error)
            })
        }
    }
    
    func getFakeData(newValue: @escaping (_ value: Int) -> (), onFinish: @escaping (_ error: Error?) -> ()) {
        let items: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        
        for item in items {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(item), execute: {
                newValue(item)
                print("New Data: \(item)")
                
                if item == items.last {
                    onFinish(nil)
                }
            })
        }
    }
    
}

@MainActor final class AsyncStreamViewModel: ObservableObject {
    
    @Published private(set) var currentNumber: Int = 0
    let manager = AsyncStreamDataManager()
    
    func onViewAppear() {
//        manager.getFakeData { [weak self] value in
//            self?.currentNumber = value
//        }
        
       let task = Task {
            do {
                for try await value in manager.getAsyncStream().{
                    currentNumber = value
                }
            } catch {
                print(error)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
            task.cancel()
            print("Task cancelled!")
        })
    }
}

struct AsyncStreamBootcamp: View {
    
    @StateObject private var viewModel = AsyncStreamViewModel()
    
    var body: some View {
        Text("\(viewModel.currentNumber)")
            .onAppear {
                viewModel.onViewAppear()
            }
    }
}

#Preview {
    AsyncStreamBootcamp()
}
