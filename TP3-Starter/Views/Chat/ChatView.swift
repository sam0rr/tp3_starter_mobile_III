import SwiftUI
import FirebaseAuth

struct ChatView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var chatViewModel: ChatViewModel
    let chatpartnerId: String
    
    var userId: String? {
        Auth.auth().currentUser?.uid
    }
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack {
                        ForEach(chatViewModel.messages) { message in
                            HStack {
                                Text(message.text)
                                    .padding(0)
                                    .cornerRadius(5)
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                
                .onChange(of: chatViewModel.messages.count) {
                    if let last = chatViewModel.messages.last {
                        proxy.scrollTo(last, anchor: .bottom)
                    }
                }
                .onAppear {
                    if let last = chatViewModel.messages.last {
                        proxy.scrollTo(last, anchor: .bottom)
                    }
                }
                
            }
        }
        
        HStack {
            TextField("Message", text: $chatViewModel.newMessage)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            Button {
                Task {
                    await chatViewModel.sendMessage(to: chatpartnerId)
                }
            } label: {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.blue)
            }
            .padding(.trailing)
        }
        .padding(.vertical)
        
        
        .onAppear {
            chatViewModel.listenForMessage()
        }
        
    }
}
