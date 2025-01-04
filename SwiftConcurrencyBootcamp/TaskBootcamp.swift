//
//  TaskBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Michael on 1/4/25.
//

import SwiftUI

class TaskBootcampViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var image2: UIImage? = nil
    
    func fetchImage() async {
        try? await Task.sleep(nanoseconds: 5_000_000_000)
        
// MARK: .task automation cancel doesn't mean that it's cancel if we still have some tasks to do
//        for x in array {
//            // some work
//            
//           try Task.checkCancellation() // if we have long raning tasks and we are going cancel them, we migth throw check for the task actually being canceled
//        }
        
        do {
            guard let url = URL(string: "https://picsum.photos/1000") else { return }
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            await MainActor.run {
                self.image = UIImage(data: data)
                print("Image returned successfully!")
            }
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    func fetchImage2() async {
        do {
            guard let url = URL(string: "https://picsum.photos/1000") else { return }
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            await MainActor.run {
                self.image = UIImage(data: data)
            }
        } catch  {
            print(error.localizedDescription)
        }
    }
    
}

struct TaskBootcampHomeView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                NavigationLink("Click me🦄") {
                    TaskBootcamp()
                }
            }
        }
    }
}

struct TaskBootcamp: View {
    
    @StateObject private var viewModel = TaskBootcampViewModel()
//    @State private var fetchImageTask: Task<(), Never>? = nil
    
    var body: some View {
        VStack(spacing: 40) {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            
            if let image = viewModel.image2 {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .task { // SwiftUI will automatically cancel the task at some point after the view disappears before the action completes.
            await viewModel.fetchImage()
        }
//        .onDisappear {
//            fetchImageTask?.cancel()
//        }
//        .onAppear {
//           fetchImageTask = Task {
//                await viewModel.fetchImage()
//            }
//            Task {
//                print(Thread.current)
//                print(Task.currentPriority)
//                await viewModel.fetchImage2()
//            }
            
            // high = 25
//            Task(priority: .high) {
////                try? await Task.sleep(nanoseconds: 2_000_000_000)
//                await Task.yield()
//                print("high : \(Thread.current) : \(Task.currentPriority)") // just a message
//            }
//            
//            Task(priority: .high) {
//                await MainActor.run { // run on main thread, Thread() without yellow warning second thread
//                    print("high :\(Task.currentPriority)")
//                }
//            }
//            
//            // userInitiated, high priority = 25
//            Task(priority: .userInitiated) {
//                print("userInitiated : \(Thread.current) : \(Task.currentPriority)")
//            }
//            
//            // medium = 21
//            Task(priority: .medium) {
//                print("medium : \(Thread.current) : \(Task.currentPriority)")
//            }
//            
//            // low = 17
//            Task(priority: .low) {
//                print("low : \(Thread()) : \(Task.currentPriority)")
//            }
//            
//            Task(priority: .low) {
//                print("low : \(Thread.current) : \(Task.currentPriority)")
//            }
//            
//            // utility, low priority = 17
//            Task(priority: .utility) {
//                print("utility : \(Thread.current) : \(Task.currentPriority)")
//            }
//            
//            // background = 9
//            Task(priority: .background) {
//                print("background : \(Thread.current) : \(Task.currentPriority)")
//            }

            
//            Task(priority: .userInitiated) {
//                print("userInitiated : \(Thread.current) : \(Task.currentPriority)")
//                
//                // child task have same priority from parent or we can detached for change that
//                // apple doc - try don't use if it possible
//                Task.detached {
//                    print("userInitiated2 : \(Thread.current) : \(Task.currentPriority)")
//                }
//            }
            

            
            
            
//        }
    }
}

#Preview {
    TaskBootcamp()
}
