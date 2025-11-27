//
//  TreeView.swift
//  ASD7-11
//
//  Created by Valentyn on 20.11.2025.
//

import SwiftUI

struct TreeView: View {
    @StateObject private var tree = BinarySearchTree()
    
    @State private var inputString: String = "10 5 15 2 7 12 20"
    @State private var targetNodeValue: String = ""
    @State private var analysisResult: String = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // MARK: - Введення
                Form {
                    Section("Побудова дерева") {
                        TextField("Числа через пробіл", text: $inputString)
                        //.keyboardType(.numbersAndPunctuation)
                        
                        StandardButton("Побудувати дерево") {
                            tree.clear()
                            let numbers = inputString.split(separator: " ").compactMap { Int($0) }
                            for num in numbers { tree.insert(num) }
                            analysisResult = "Дерево побудовано"
                        }
                    }
                    .padding(.trailing, 30)
                    
                    Section("Операції (Варіант 4)") {
                        StandardButton("1. Висхідний обхід (Post-order)") {
                            let res = tree.postOrderTraversal()
                            analysisResult = "Post-order: \(res)"
                        }
                        
                        StandardButton("4. Знайти другу парну вершину") {
                            if let val = tree.findSecondEven() {
                                analysisResult = "Друга парна вершина: \(val)"
                            } else {
                                analysisResult = "Другої парної вершини не знайдено"
                            }
                        }
                    }
                    .padding(.trailing, 30)
                    
                    Section("Інформація про вершину") {
                        TextField("Значення вершини", text: $targetNodeValue)
                            //.keyboardType(.numberPad)
                        
                        StandardButton("Отримати дані (Батько/Діти)") {
                            guard let val = Int(targetNodeValue) else { return }
                            if !tree.search(val) {
                                analysisResult = "Вершина \(val) відсутня в дереві"
                                return
                            }
                            
                            if let info = tree.getNodeInfo(val) {
                                let p = info.parent.map(String.init) ?? "немає"
                                let l = info.left.map(String.init) ?? "немає"
                                let r = info.right.map(String.init) ?? "немає"
                                analysisResult = "Вершина: \(val)\nБатько: \(p)\nЛівий: \(l), Правий: \(r)"
                            }
                        }
                    }
                    .padding(.trailing, 30)
                }
                .frame(height: 450)
                
                // MARK: - Результати
                Text(analysisResult)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)

                // MARK: - Візуалізація
                Text("Візуалізація Дерева")
                    .font(.title2)
                    .padding(.top)
                
                ScrollView([.horizontal, .vertical]) {
                    if let root = tree.root {
                        VisualNodeView(node: root)
                            .padding()
                    } else {
                        Text("Дерево порожнє")
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(height: 300)
                .border(Color.gray.opacity(0.2))
            }
            .padding(.bottom, 50)
        }
        .navigationTitle("Бінарне дерево пошуку")
    }
}

// Рекурсивна вьюшка для малювання дерева
struct VisualNodeView: View {
    let node: TreeNode
    
    var body: some View {
        VStack(spacing: 20) {
            // Сама нода
            NodeView(value: node.value) // Використовуємо ваш існуючий стиль
            
            // Діти
            HStack(alignment: .top, spacing: 20) {
                if let left = node.left {
                    VisualNodeView(node: left)
                } else {
                    // Невидимий плейсхолдер для балансу
                    if node.right != nil {
                        Spacer().frame(width: 30)
                    }
                }
                
                if let right = node.right {
                    VisualNodeView(node: right)
                } else {
                    // Невидимий плейсхолдер для балансу
                    if node.left != nil {
                         Spacer().frame(width: 30)
                    }
                }
            }
        }
    }
}
