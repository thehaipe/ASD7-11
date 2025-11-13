import SwiftUI

struct LinkedListView: View {
    @StateObject private var list = LinkedList<Int>()
    @StateObject private var secondList = LinkedList<Int>()
    
    // Стейт для введення рядків
    @State private var listOneInput: String = ""
    @State private var listTwoInput: String = ""
    
    // Стейт для пошуку
    @State private var searchValue: String = ""
    @State private var positionMessage: String = ""
    

    var body: some View {
        ScrollView {
            
            // MARK: - Введення і кнопки
            Form {
                Section("Введення даних (числа через пробіл)") {
                    TextField("Список 1", text: $listOneInput)
                    StandardButton("Заповнити Список 1") {
                        parseAndFillList(listOneInput, into: list)
                    }
                    
                    TextField("Список 2 (для об'єднання)", text: $listTwoInput)
                    StandardButton("Заповнити Список 2") {
                        parseAndFillList(listTwoInput, into: secondList)
                    }
                }
                .padding(.trailing, 30)
                
                // MARK: - Об’єднання
                Section("Об’єднання списків") {
                    StandardButton("Об’єднати (Список 2 додається до Списку 1)") {
                        let merged = list.merge(with: secondList)
                        list.head = merged.head
                        
                        secondList.clearList()
                        listTwoInput = ""
                    }
                }
                .padding(.trailing, 30)
                
                // MARK: - Пошук
                Section("Пошук елемента у Списку 1") {
                    TextField("Введіть значення для пошуку", text: $searchValue)
                    StandardButton("Знайти позицію") { findPosition() }
                    
                    if !positionMessage.isEmpty {
                        Text(positionMessage)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.trailing, 30)
            }
            .frame(maxHeight: 400)
           
            
            // MARK: - Візуалізація
            VStack {
                Text("Список 1").font(.headline)
                VisualisationView(list: list)
                
                Text("Список 2").font(.headline.weight(.light))
                VisualisationView(list: secondList)
            }
            
            // MARK: - Аналітика
            VStack(alignment: .leading, spacing: 8) {
                Text("Аналіз Списку 1").font(.headline)
                
                Group {
                    Text("Кількість елементів: \(list.countElements())")
                    
                    if let min = list.minValue(), let max = list.maxValue() {
                        Text("Мінімальний елемент: \(min)")
                        Text("Максимальний елемент: \(max)")
                    }
                    
                    if let third = list.thirdFromStart() {
                        Text("3-й з початку: \(third)")
                    }
                    if let secondFromEnd = list.secondFromEnd() {
                        Text("2-й з кінця: \(secondFromEnd)")
                    }
                    if let beforeMin = list.beforeMin() {
                        Text("Перед мінімальним: \(beforeMin)")
                    }
                    if let afterMax = list.afterMax() {
                        Text("Після максимального: \(afterMax)")
                    }
                }
                .font(.subheadline)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            
            Spacer()
        }
        .navigationTitle("Однозв’язний список — аналітика")
        .padding()
    }
    
    // MARK: - Логіка
    
    /// Парсить рядок чисел, розділених пробілом, і заповнює список
    private func parseAndFillList(_ input: String, into list: LinkedList<Int>) {
        list.clearList() // Очищуємо список перед заповненням
        
        let numbers = input
            .split(separator: " ")
            .compactMap { Int($0) } // "1 2 3" -> [1, 2, 3]
        
        for number in numbers {
            list.addBack(number)
        }
    }
    
    private func findPosition() {
        guard let value = Int(searchValue) else {
            positionMessage = "Введіть коректне число"
            return
        }
        
        if let pos = list.positionOf(value) {
            positionMessage = "Елемент \(value) знаходиться на позиції \(pos)"
        } else {
            positionMessage = "Елемент \(value) не знайдено"
        }
        searchValue = ""
    }
}

// MARK: - Візуалізація
struct VisualisationView: View {
    @ObservedObject var list: LinkedList<Int>
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            HStack(spacing: 0) {
                Text("head").font(.caption).padding(8).foregroundStyle(.secondary)
                if !list.isEmpty { ArrowView() }
                
                ForEach(Array(list.allValues.enumerated()), id: \.offset) { index, value in
                    NodeView(value: value)
                    if index < list.allValues.count - 1 { ArrowView() }
                }
                
                // Якщо список не пустий, малюємо стрілку до nil
                if !list.isEmpty {
                    ArrowView()
                }
                
                NilView()
            }
            .padding(.horizontal)
        }
        .frame(height: 100)
    }
}
