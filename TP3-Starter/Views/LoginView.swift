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
            
            Group {
                if signup {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                    TextField("Username", text: $username)
                }
                
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
                SecureField("Password", text: $password)
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
            .padding(.horizontal)

            Button(action: {
                Task {
                    if signup {
                        guard (await viewModel.signUp(email: email, password: password, firstname: firstName, lastname: lastName)) != nil else { return }
                    } else {
                        guard (await viewModel.login(email: email, password: password)) != nil else { return }
                    }
                }
            }) {
                Text(signup ? "Sign Up" : "Login")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }

            Button(action: {
                withAnimation {
                    signup.toggle()
                }
            }) {
                Text(signup ? "Already have an account? Log in" : "Don’t have an account? Sign up")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            .padding(.top)

            Spacer()
        }
        .padding()
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
