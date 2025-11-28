import Foundation
import Combine

class BinarySearch: ObservableObject {
    
    @Published var array: [Int] = []
    @Published var steps: [String] = [] // Для покрокового відображення
    @Published var comparisonCount: Int = 0
    @Published var searchResult: String = ""
    
    func generateArray(size: Int, range: Range<Int> = 0..<100) {
        var newArray = (0..<size).map { _ in Int.random(in: range) }
        newArray.sort()
        self.array = newArray
        self.steps = []
        self.searchResult = "Масив згенеровано (розм: \(size))"
    }
    
    //повертає індекс або nil
    func binarySearch(target: Int) -> Int? {
        steps = []
        comparisonCount = 0
        
        var left = 0ц
        var right = array.count - 1
        
        steps.append("Пошук числа \(target) в діапазоні індексів [0...\(right)]")
        
        while left <= right {
            let mid = left + (right - left) / 2
            let midValue = array[mid]
            
            comparisonCount += 1 // Порівняння midValue == target
            steps.append("Крок: перевіряємо індекс \(mid) (значення \(midValue)). Діапазон [\(left)...\(right)]")
            
            if midValue == target {
                steps.append("Елемент \(target) під індексом \(mid).")
                return mid
            }
            
            comparisonCount += 1 // Порівняння midValue < target
            if midValue < target {
                steps.append("Значення \(midValue) < \(target). Шукаємо у правій половині.")
                left = mid + 1
            } else {
                steps.append("Значення \(midValue) > \(target). Шукаємо у лівій половині.")
                right = mid - 1
            }
        }
        
        steps.append("Елемент не знайдено.")
        return nil
    }
    
    // Перевірка чи є серед елементів масиву k-те число Фібоначчі
    
    func checkFibonacciPresence(k: Int) {
        //Щоб знайти к-те, потрібно додати попереднє, і перед ним
        let fibValue = getFibonacci(n: k)
        steps.append("--- Завдання Варіант 5 ---")
        steps.append("k-те число Фібоначчі (k=\(k)) дорівнює \(fibValue)")
        
        if let index = binarySearch(target: fibValue) {
            searchResult = "Число Фібоначчі \(fibValue) (k=\(k)) ЗНАЙДЕНО на позиції \(index).\nКількість порівнянь: \(comparisonCount)"
        } else {
            searchResult = "Число Фібоначчі \(fibValue) (k=\(k)) НЕ знайдено в масиві.\nКількість порівнянь: \(comparisonCount)"
        }
    }
    
    // Допоміжна функція для пошуку N-го числа Фібоначчі
    // F(1)=1, F(2)=1, F(3)=2, F(4)=3, F(5)=5...
    //(F(n)=F(n-1)+F(n-2)).
    private func getFibonacci(n: Int) -> Int {
        if n <= 0 { return 0 }
        if n == 1 || n == 2 { return 1 }
        
        var a = 1
        var b = 1
        
        for _ in 3...n {
            let temp = a + b
            a = b
            b = temp
        }
        return b
    }
}
