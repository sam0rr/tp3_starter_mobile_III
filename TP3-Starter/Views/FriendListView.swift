import SwiftUI

struct FriendListView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var viewModel = FriendViewModel()
    @State private var search = ""

    var body: some View {
        NavigationView {
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
                            Button(action: {
                                // Action pour ajouter un ami
                            }) {
                                Text("Add")
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .listStyle(PlainListStyle())
                }
                
                Spacer()
            }
            .navigationTitle("Find Friends")
        }
    }
}

#Preview {
    FriendListView()
        .environmentObject(AuthViewModel())
}
