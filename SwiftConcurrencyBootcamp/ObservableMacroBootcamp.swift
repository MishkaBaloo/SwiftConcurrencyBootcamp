//
//  ObservableMacroBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Michael on 1/16/25.
//

import SwiftUI

actor TitleDatabase {
    
    func getNewTitle() -> String {
        "Some new title!"
    }
    
}
// @MainActor // we already can mark entire class with @MainActor in Swift 6
@Observable class ObservableMacroBootcampViewModel {
    
    @MainActor var title: String = "Starting title"
    @ObservationIgnored let database = TitleDatabase()
    
    
    /*@MainActor*/ func updateTitle() async  {
        let title = await database.getNewTitle()
        await MainActor.run {
            self.title = title
            print(Thread.current)
        }
    }
    
}

struct ObservableMacroBootcamp: View {
    
    @State  private var viewModel = ObservableMacroBootcampViewModel()
    
    var body: some View {
        Text(viewModel.title)
            .task {
                await viewModel.updateTitle()
            }
    }
}

#Preview {
    ObservableMacroBootcamp()
}
