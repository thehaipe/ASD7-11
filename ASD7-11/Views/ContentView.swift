import SwiftUI

struct ContentView: View {
    
    @State private var selectedStructure: DataStructureEnum? = .linkedList
    
    var body: some View {
        NavigationSplitView {
            List(DataStructureEnum.allCases, selection: $selectedStructure) { structure in
                NavigationLink(value: structure) {
                    Text(structure.title)
                }
            }
            .navigationTitle("Структури даних")
            
        } detail: {
            // --- ОБЛАСТЬ КОНТЕНТУ ---
            switch selectedStructure {
            case .linkedList:
                LinkedListView()
            case nil:
                Text("Оберіть структуру даних з бічної панелі")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
