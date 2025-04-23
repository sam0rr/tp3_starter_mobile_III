import SwiftUI

struct ApplicationView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {

        Text("bienvenu Habibi ;) ")
        
        Button("disconnect"){
            
            viewModel.signOut()

        }

    }
}

#Preview {
    ApplicationView()
}
