import SwiftUI

@main
struct SellMateMerchantApp: App {
    @StateObject private var appViewModel = AppViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appViewModel)
                .task {
                    await appViewModel.bootstrap()
                }
        }
    }
}
