import Foundation
import Combine

class Node<T> {
    var value: T
    var next: Node?
    init(value: T, next: Node? = nil) {
        self.value = value
        self.next = next
    }
}

class LinkedList<T: Comparable>: ObservableObject {
    @Published var head: Node<T>? = nil
    
    var isEmpty: Bool {
        head == nil
    }
    
    var allValues: [T] {
        var result = [T]()
        var node = head
        while let n = node {
            result.append(n.value)
            node = n.next
        }
        return result
    }
    func addFront(_ value: T) {
        objectWillChange.send()
        let newNode = Node(value: value)
        newNode.next = head
        head = newNode
    }
    
    // MARK: - Базові операції
    
    func addBack(_ value: T) {
        objectWillChange.send()
        let newNode = Node(value: value)
        if head == nil {
            head = newNode
            return
        }
        var current = head
        while current?.next != nil {
            current = current?.next
        }
        current?.next = newNode
    }
    
    func clearList() {
        head = nil
    }
    
    // MARK: - Операції за умовою задачі
    
    func countElements() -> Int {
        var count = 0
        var node = head
        while node != nil {
            count += 1
            node = node?.next
        }
        return count
    }
    
    func minValue() -> T? {
        guard var minVal = head?.value else { return nil }
        var node = head?.next
        while let current = node {
            if current.value < minVal {
                minVal = current.value
            }
            node = current.next
        }
        return minVal
    }
    
    func maxValue() -> T? {
        guard var maxVal = head?.value else { return nil }
        var node = head?.next
        while let current = node {
            if current.value > maxVal {
                maxVal = current.value
            }
            node = current.next
        }
        return maxVal
    }
    
    func thirdFromStart() -> T? {
        var node = head
        for _ in 0..<2 {
            node = node?.next
        }
        return node?.value
    }
    
    func secondFromEnd() -> T? {
        let values = allValues
        guard values.count >= 2 else { return nil }
        return values[values.count - 2]
    }
    
    func beforeMin() -> T? {
        guard let minVal = minValue() else { return nil }
        var node = head
        var prev: T?
        while let current = node {
            if current.value == minVal {
                return prev
            }
            prev = current.value
            node = current.next
        }
        return nil
    }
    
    func afterMax() -> T? {
        guard let maxVal = maxValue() else { return nil }
        var node = head
        while let current = node {
            if current.value == maxVal {
                return current.next?.value
            }
            node = current.next
        }
        return nil
    }
    
    func positionOf(_ value: T) -> Int? {
        var node = head
        var index = 0
        while let current = node {
            if current.value == value {
                return index
            }
            index += 1
            node = current.next
        }
        return nil
    }
    
    func merge(with other: LinkedList<T>) -> LinkedList<T> {
        let newList = LinkedList<T>()
        for v in self.allValues {
            newList.addBack(v)
        }
        for v in other.allValues {
            newList.addBack(v)
        }
        return newList
    }
    func insertAt(_ index: Int, _ value: T) {
        objectWillChange.send()
        let newNode = Node(value: value)
        
        // Якщо вставка на початок
        if index == 0 {
            newNode.next = head
            head = newNode
            return
        }
        
        var current = head
        var prev: Node<T>? = nil
        var currentIndex = 0
        
        // Перехід до потрібної позиції
        while current != nil && currentIndex < index {
            prev = current
            current = current?.next
            currentIndex += 1
        }
        
        // Якщо індекс більший за довжину — додаємо в кінець
        if current == nil {
            prev?.next = newNode
        } else {
            newNode.next = current
            prev?.next = newNode
        }
    }

    func delete(at index: Int) {
        objectWillChange.send()
        guard head != nil else { return }
        
        // Якщо видаляємо перший елемент
        if index == 0 {
            head = head?.next
            return
        }
        
        var current = head
        var prev: Node<T>? = nil
        var currentIndex = 0
        
        // Пошук потрібного елемента
        while current != nil && currentIndex < index {
            prev = current
            current = current?.next
            currentIndex += 1
        }
        
        // Якщо елемент знайдено — пропускаємо його
        if current != nil {
            prev?.next = current?.next
        }
    }
    func deleteFirst() {
        objectWillChange.send()
        guard head != nil else { return }
        head = head?.next
    }
    func deleteLast() {
            if head?.next == nil {
                head = nil // Змінює head, @Published спрацює
                return
            }
        objectWillChange.send()
            // Повідомляємо View про зміну
            
            
            var nextNode = head
            var previousNode: Node<T>?
            while(nextNode?.next != nil) {
                previousNode = nextNode
                nextNode = nextNode?.next
            }
            previousNode?.next = nil // Це "глибока" зміна
        }
}

