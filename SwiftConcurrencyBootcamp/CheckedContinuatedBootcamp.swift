//
//  CheckedContinuatedBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Michael on 1/8/25.
//

import SwiftUI

class CheckedContinuatedBootcampNetworkManager {
    
    func getData(url: URL) async throws -> Data {
        do {
          let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            return data
        } catch  {
            throw error
        }
    }
    
    func getData2(url: URL) async throws -> Data {
        
        return try await withCheckedThrowingContinuation { continuation in // You must invoke the continuation’s resume method exactly once.
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    continuation.resume(returning: data)
                } else if let error  = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: URLError(.badURL))
                }
            }
            .resume()

        }
    }
    
    func getHeartImageFromDataBase(completionHandler: @escaping (_ image: UIImage) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            completionHandler(UIImage(systemName: "heart.fill")!)
        })
    }
    
    func getHeartImageFromDataBase() async -> UIImage {
         await withCheckedContinuation { continuation in
            getHeartImageFromDataBase { image in
                continuation.resume(returning: image)
            }
        }
    }
    
}

class CheckedContinuatedBootcampViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    let networkManager = CheckedContinuatedBootcampNetworkManager()
    
    func getImage() async {
        guard let url = URL(string: "https://picsum.photos/300") else { return }
        
        do {
          let data = try await networkManager.getData2(url: url)
            
            if let image = UIImage(data: data) {
                await MainActor.run {
                    self.image = image
                }
            }
            
        } catch  {
            print(error)
        }
    }
    
    func getHeartImage() async {
        self.image = await networkManager.getHeartImageFromDataBase()
    }
}

struct CheckedContinuatedBootcamp: View { // we use cheakedContinuation to convert non async code in to async
    
    @StateObject var viewModel = CheckedContinuatedBootcampViewModel()
    
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .task {
            await viewModel.getHeartImage()
        }
    }
}

#Preview {
    CheckedContinuatedBootcamp()
}
