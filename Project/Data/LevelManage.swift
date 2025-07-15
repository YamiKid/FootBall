import Foundation

class LevelManager {
    static let shared = LevelManager()

    private let defaults = UserDefaults.standard

    private enum Keys {
        static let currentLevel = "currentLevel"
        static let unlockedLevels = "unlockedLevels"
        static let levelResults = "levelResults"
        static let nowLevel = "nowLevel"
        static let lastLevel = "lastLevel"
    }

    private init() {}

    var currentLevel: Int {
        get {
            return defaults.integer(forKey: Keys.currentLevel)
        }
        set {
            defaults.set(newValue, forKey: Keys.currentLevel)
        }
    }

    var unlockedLevels: [Int] {
        get {
            return defaults.array(forKey: Keys.unlockedLevels) as? [Int] ?? [1] // Начальное состояние: первый уровень открыт
        }
        set {
            defaults.set(newValue, forKey: Keys.unlockedLevels)
        }
    }

    // Метод для сохранения результата уровня
    func saveResult(for level: Int, result: String) {
        var results = defaults.dictionary(forKey: Keys.levelResults) as? [String: String] ?? [:]
        results["\(level)"] = result
        defaults.set(results, forKey: Keys.levelResults)
    }

    // Метод для получения результата уровня
    func getResult(for level: Int) -> String? {
        let results = defaults.dictionary(forKey: Keys.levelResults) as? [String: String]
        return results?["\(level)"]
    }

    // Метод для разблокировки следующего уровня
    func unlockNextLevel() {
        let nextLevel = currentLevel + 1
        if nextLevel <= 12, !unlockedLevels.contains(nextLevel) {
            var updatedLevels = unlockedLevels
            updatedLevels.append(nextLevel)
            unlockedLevels = updatedLevels
        }
    }

    // Метод для обработки завершения уровня
    func levelCompleted(currentLevelCompleted: Int, result: String) {
        // Сохранение результата завершённого уровня
        saveResult(for: currentLevelCompleted, result: result)
        // Проверяем и разблокируем следующий уровень
        if currentLevelCompleted == currentLevel+1 {
            // Обновляем currentLevel на завершённом уровне
            
            currentLevel += 1
            unlockNextLevel()
        }
    }
    
    func setNowLevel(_ level: Int) {
        defaults.set(level, forKey: Keys.nowLevel)
    }
    
    func getNowLevel() -> Int {
        return defaults.integer(forKey: Keys.nowLevel)
    }
    
    func setLastLevel(_ level: Bool) {
        defaults.set(level, forKey: Keys.lastLevel)
    }
    
    func getLastLevel() -> Bool {
        return defaults.bool(forKey: Keys.lastLevel)
    }
}
