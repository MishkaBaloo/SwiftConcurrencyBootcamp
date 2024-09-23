//
//  DoCatchTryThrowsBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Michael on 9/23/24.
//

import SwiftUI

/*
 Themes of lesson:
 1. do-catch
 2. try
 3. throws
 */

class DoCatchTryThrowsBootcampDateManager {
    
    let isActive: Bool = true //false
    
    func getTitle() -> (title: String?, error: Error?) {
        if isActive {
            return ("NEW TEXT!", nil)
        } else {
            return (nil, URLError(.badURL))
        }
       
    }
    
    func  getTitle2() -> Result<String, Error> {
        if isActive {
            return.success("NEW TEXT!")
        } else {
            return .failure(URLError(.appTransportSecurityRequiresSecureConnection))
        }
    }
    
    func getTitle3() throws -> String { // throws using for error match, we just return string or an error
//        if isActive {
//            return "NEW TEXT!"
//        } else {
            throw URLError(.badServerResponse)
//        }
    }
    
    func getTitle4() throws -> String {
        if isActive {
            return "FINAL TEXT!"
        } else {
            throw URLError(.badServerResponse)
        }
    }
    
}

class DoCatchTryThrowsBootcampViewModel: ObservableObject {
    
    @Published var text: String = "Starting text."
    let manager = DoCatchTryThrowsBootcampDateManager()
    
    func fetchTitle() {
        /*
        let returnedValue = manager.getTitle()
        if let newTitle = returnedValue.title {
            self.text = newTitle
        } else if let error = returnedValue.error {
            self.text = error.localizedDescription
        }
         */
        /*
        let result  = manager.getTitle2()
        
        switch result {
        case .success(let newTitle):
            self.text = newTitle
        case .failure(let error):
            self.text = error.localizedDescription
        }
         */
        
//        let newTitle = try? manager.getTitle3() // use optional if we do not care about error
//        if let newTitle = newTitle {
//            self.text = newTitle
//        }
        
        do {
            let newTitle = try? manager.getTitle3() // marked with ? for keep going
            if let newTitle = newTitle {
                self.text = newTitle
            }
            
            let finalTitle = try manager.getTitle4() // if one of this try fails -> catch block
            self.text = finalTitle
            
        } catch {
            self.text = error.localizedDescription
        }
    }
    
}

struct DoCatchTryThrowsBootcamp: View {
    
    @StateObject private var viewModel = DoCatchTryThrowsBootcampViewModel()
    
    var body: some View {
        Text(viewModel.text)
            .frame(width: 300, height: 300)
            .background(Color.blue)
            .onTapGesture {
                viewModel.fetchTitle()
            }
    }
}

#Preview {
    DoCatchTryThrowsBootcamp()
}
