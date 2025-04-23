import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewModel: AuthViewModel

    @State private var email = ""
    @State private var password = ""
    @State private var signup = false
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var username = ""

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Text(signup ? "Create Account" : "Log In")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 20)

            if signup {
                TextField("First Name", text: $firstName)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                
                TextField("Last Name", text: $lastName)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                
                TextField("Username", text: $username)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
            }

            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)

            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)

            Button(action: handleAuthentication) {
                Text(signup ? "Sign Up" : "Login")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }

            Button(action: toggleSignup) {
                Text(signup ? "Already have an account? Log in" : "Don't have an account? Sign up")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            .padding(.top)

            Spacer()
        }
        .padding()
    }
    
    private func handleAuthentication() {
        Task {
            if signup {
                await viewModel.signUp(
                    email: email,
                    password: password,
                    firstname: firstName,
                    lastname: lastName
                )
            } else {
                await viewModel.login(email: email, password: password)
            }
        }
    }
    
    private func toggleSignup() {
        withAnimation {
            signup.toggle()
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
