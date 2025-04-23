import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    

    var body: some View {
        if viewModel.isAuthenticated {
            ApplicationView()
        }else{
            LoginView()
        }
    }
}

#Preview {
    ContentView()
}
