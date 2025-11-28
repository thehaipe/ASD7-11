
import SwiftUI

struct BinarySearchView: View {
    @StateObject private var searcher = BinarySearch()
    
    @State private var arraySizeStr: String = "20"
    @State private var kFibStr: String = "6"
    @State private var customSearchTarget: String = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // MARK: - Генерація
                Form {
                    Section("Налаштування масиву") {
                        TextField("Розмір масиву (напр. 10, 40, 100)", text: $arraySizeStr)
                            #if os(iOS)
                            .keyboardType(.numberPad)
                            #endif
                        
                        StandardButton("Згенерувати відсортований масив") {
                            if let size = Int(arraySizeStr) {
                                searcher.generateArray(size: size, range: 0..<(size*3))
                            }
                        }
                    }
                    .padding(.trailing, 30)
                    
                    // MARK: - Варіант 5
                    Section("Індивідуальне завдання") {
                        Text("Перевірити наявність k-го числа Фібоначчі")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        TextField("Введіть k (напр. 5, 6, 7)", text: $kFibStr)
                        
                        StandardButton("Виконати пошук") {
                            if let k = Int(kFibStr) {
                                searcher.checkFibonacciPresence(k: k)
                            }
                        }
                    }
                    .padding(.trailing, 30)
                    
                    // MARK: - Звичайний пошук (для тестування таблиці)
                    Section("Довільний пошук") {
                        TextField("Число для пошуку", text: $customSearchTarget)
                        
                        StandardButton("Знайти число") {
                            if let target = Int(customSearchTarget) {
                                if let idx = searcher.binarySearch(target: target) {
                                    searcher.searchResult = "Знайдено на позиції \(idx). Порівнянь: \(searcher.comparisonCount)"
                                } else {
                                    searcher.searchResult = "Не знайдено. Порівнянь: \(searcher.comparisonCount)"
                                }
                            }
                        }
                    }
                    .padding(.trailing, 30)
                }
                .frame(height: 450)
                
                // MARK: - Результати
                VStack(spacing: 10) {
                    Text(searcher.searchResult)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                    
                    // Візуалізація масиву
                    Text("Масив:")
                        .font(.subheadline)
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(Array(searcher.array.enumerated()), id: \.offset) { index, value in
                                Text("\(value)")
                                    .font(.system(.body, design: .monospaced))
                                    .padding(8)
                                    .background(Color.gray.opacity(0.2))
                                    .clipShape(Circle())
                            }
                        }
                        .padding(.horizontal)
                    }
                    .frame(height: 50)
                    
                    // Лог кроків
                    Text("Покрокове виконання:")
                        .font(.headline)
                        .padding(.top)
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 4) {
                            ForEach(searcher.steps, id: \.self) { step in
                                Text("• " + step)
                                    .font(.caption)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.vertical, 2)
                                Divider()
                            }
                        }
                        .padding()
                    }
                    .frame(height: 200)
                    .background(Color(NSColor.controlBackgroundColor))
                    .cornerRadius(8)
                    .border(Color.gray.opacity(0.3))
                    .padding(.horizontal)
                }
            }
            .padding()
        }
        .navigationTitle("Лабораторна №9: Бінарний пошук")
    }
}
