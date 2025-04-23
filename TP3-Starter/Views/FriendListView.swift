import SwiftUI

struct FriendListView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var viewModel = FriendViewModel()
    @State private var search = ""
    @State private var showingFriendsList = false

    var body: some View {
        VStack(spacing: 16) {
            TextField("Search by username", text: $search)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Button(action: {
                Task {
                    await viewModel.searchFriends(search: search)
                }
            }) {
                Text("Search")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }

            Picker("Mode", selection: $showingFriendsList) {
                Text("Search").tag(false)
                Text("My Friends").tag(true)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            if showingFriendsList {
                List {
                    ForEach(viewModel.friend, id: \.uid) { friend in
                        NavigationLink(destination: ChatView(chatViewModel: ChatViewModel(), chatpartnerId: friend.uid)) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("\(friend.firstname) \(friend.lastname)")
                                        .font(.headline)
                                    Text("@\(friend.username)")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .listStyle(PlainListStyle())
                .onAppear {
                    Task {
                        await viewModel.fetchFriends()
                    }
                }
            } else {
                if viewModel.searchResult.isEmpty {
                    Text("No results yet")
                        .foregroundColor(.gray)
                        .padding(.top, 40)
                } else {
                    List(viewModel.searchResult, id: \.uid) { friend in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(friend.firstname) \(friend.lastname)")
                                    .font(.headline)
                                Text("@\(friend.username)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Button {
                                Task {
                                    await viewModel.addFriend(uid: friend.uid)
                                }
                            } label: {
                                Text("Add")
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            
            Spacer()
        }
        .navigationTitle("Friends")
    }
}

#Preview {
    NavigationView {
        FriendListView()
            .environmentObject(AuthViewModel())
    }
}
