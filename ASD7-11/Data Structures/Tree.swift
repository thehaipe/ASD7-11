import Foundation
import Combine

class TreeNode: Identifiable {
    let id = UUID()
    var value: Int
    var left: TreeNode?
    var right: TreeNode?
    
    init(_ value: Int) {
        self.value = value
    }
}

class BinarySearchTree: ObservableObject {
    @Published var root: TreeNode? = nil
    
    // Очищення для нового вводу
    func clear() {
        root = nil
    }
    
    // MARK: - Побудова дерева
    func insert(_ value: Int) {
        objectWillChange.send()
        if let rootNode = root {
            insertNode(rootNode, value)
        } else {
            root = TreeNode(value)
        }
    }
    
    private func insertNode(_ node: TreeNode, _ value: Int) {
        if value < node.value {
            if let left = node.left {
                insertNode(left, value) //вузол не пустий
            } else {
                node.left = TreeNode(value) //пустий - ідеальне місце
            }
        } else {
            // Вставляємо вправо (включаючи рівні значення, або ігноруємо дублікати за умовою БДП)
            // Тут припускаємо, що дублікати йдуть вправо або ігноруються.
            // Для чистоти БДП зазвичай значення унікальні.
            if value > node.value {
                if let right = node.right {
                    insertNode(right, value)
                } else {
                    node.right = TreeNode(value)
                }
            }
        }
    }
    
    // MARK: - 1. Висхідний обхід (Post-order: Left, Right, Root)
    func postOrderTraversal() -> [Int] {
        var result = [Int]()
        postOrder(node: root, result: &result)
        return result
    }
    
    private func postOrder(node: TreeNode?, result: inout [Int]) {
        guard let node = node else { return }
        postOrder(node: node.left, result: &result)
        postOrder(node: node.right, result: &result)
        result.append(node.value)
    }
    
    // MARK: - 2. Наявність значення
    func search(_ value: Int) -> Bool {
        return searchNode(root, value)
    }
    
    private func searchNode(_ node: TreeNode?, _ value: Int) -> Bool {
        guard let node = node else { return false }
        if value == node.value { return true }
        return value < node.value ? searchNode(node.left, value) : searchNode(node.right, value)
    }
    
    // MARK: - 3. Батьківський елемент та нащадки
    // Повертає (Parent, LeftChild, RightChild)
    func getNodeInfo(_ value: Int) -> (parent: Int?, left: Int?, right: Int?)? {
        // Якщо шукаємо корінь
        if root?.value == value {
            return (nil, root?.left?.value, root?.right?.value)
        }
        return findInfo(node: root, parent: nil, target: value)
    }
    
    private func findInfo(node: TreeNode?, parent: TreeNode?, target: Int) -> (Int?, Int?, Int?)? {
        guard let node = node else { return nil }
        
        if node.value == target {
            return (parent?.value, node.left?.value, node.right?.value)
        }
        
        if target < node.value {
            return findInfo(node: node.left, parent: node, target: target)
        } else {
            return findInfo(node: node.right, parent: node, target: target)
        }
    }
    
    // MARK: - 4. Друга парна вершина (Варіант 4)
    // Шукаємо другу парну, обходячи дерево
    func findSecondEven() -> Int? {
        var count = 0
        var result: Int? = nil
        
        // Використовуємо In-order, щоб знайти другу парну по зростанню
        inOrderEvenSearch(node: root, count: &count, result: &result)
        return result
    }
    
    private func inOrderEvenSearch(node: TreeNode?, count: inout Int, result: inout Int?) {
        guard let node = node, result == nil else { return }
        
        inOrderEvenSearch(node: node.left, count: &count, result: &result)
        
        if result != nil { return } // Вже знайшли
        
        if node.value % 2 == 0 {
            count += 1
            if count == 2 {
                result = node.value
                return
            }
        }
        
        inOrderEvenSearch(node: node.right, count: &count, result: &result)
    }
}
