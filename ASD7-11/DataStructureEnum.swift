enum DataStructureEnum: String, CaseIterable, Identifiable {
    case linkedList
    
    
    // id потрібен для Identifiable
    var id: String { self.rawValue }
    
    // Назва, яка буде відображатись у бічній панелі
    var title: String {
        switch self {
        case .linkedList:
            return "Linked List"
        }
    }
}
