//
//  ActorsBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Michael on 1/10/25.
//

import SwiftUI

// 1. What is the problem that actor are solving?
// 2. How was this problem solved prior to actors?
// 3. Actors can solve the problem!

class MyDataManager {
    
    static let instance = MyDataManager()
    private init() { }
    
    var data: [String] = []
    private let queue = DispatchQueue(label: "com.MyApp.MyDataManager")
    
    func getRandomData(complitionHandler: @escaping (_ title: String?) -> ())  {
        queue.async {
            self.data.append(UUID().uuidString)
            print(Thread.current)
            complitionHandler(self.data.randomElement())
        }
    }
    
}

actor MyActorDataManager {
    
    static let instance = MyActorDataManager()
    private init() { }
    
    var data: [String] = []
    
    nonisolated let myRandomText: String = "Sometihng"
    
    func getRandomData() -> String? {
        self.data.append(UUID().uuidString)
        print(Thread.current)
        return self.data.randomElement()
    }
    
    nonisolated func getSavedData() -> String { // nonisolated, we don't have to await
        return "NEW DATA"
    }
    
}

struct HomeView: View {
    
    let manager = MyActorDataManager.instance
    @State private var text: String = ""
    let timer = Timer.publish(every: 0.1, tolerance: nil, on: .main, in: .common, options: nil).autoconnect()
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.8).ignoresSafeArea()
            
            Text(text)
                .font(.headline)
        }
        .onAppear {
            
            let newString = manager.myRandomText
            
            Task {
                let newString = await manager.getSavedData()
            }
        }
        .onReceive(timer) { _ in
            Task {
                if let data = await manager.getRandomData() {
                    await MainActor.run {
                        self.text = data
                    }
                }
            }
            
//            DispatchQueue.global(qos: .background).async(execute: {
//                manager.getRandomData { title in
//                    if let data = title {
//                        DispatchQueue.main.async {
//                            self.text = data
//                        }
//                    }
//                }
//            })
        }
    }
}

struct BrowseView: View {
    
    let manager = MyActorDataManager.instance
    @State private var text: String = ""
    let timer = Timer.publish(every: 0.01, tolerance: nil, on: .main, in: .common, options: nil).autoconnect()
    
    var body: some View {
        ZStack {
            Color.yellow.opacity(0.8).ignoresSafeArea()
            
            Text(text)
                .font(.headline)
        }
        .onReceive(timer) { _ in
            Task {
                if let data = await manager.getRandomData() {
                    await MainActor.run {
                        self.text = data
                    }
                }
            }
//            DispatchQueue.global(qos: .default).async(execute: {
//                manager.getRandomData { title in
//                    if let data = title {
//                        DispatchQueue.main.async {
//                            self.text = data
//                        }
//                    }
//                }
//            })
        }
    }
    
}


struct ActorsBootcamp: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house.fill") {
                HomeView()
            }
            
            Tab("Browse", systemImage: "magnifyingglass") {
                BrowseView()
            }
            
            
        }
    }
}

#Preview {
    ActorsBootcamp()
}
