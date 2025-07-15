import Foundation

struct Level {
    let levelNumber: Int
    let targetScore: Int // Цель (количество голов)
    let timeLimit: TimeInterval // Время в секундах
}

let levels: [Level] = [
    Level(levelNumber: 1, targetScore: 2, timeLimit: 45),
    Level(levelNumber: 2, targetScore: 3, timeLimit: 45),
    Level(levelNumber: 3, targetScore: 4, timeLimit: 45),
    Level(levelNumber: 4, targetScore: 5, timeLimit: 45),
    Level(levelNumber: 5, targetScore: 4, timeLimit: 40),
    Level(levelNumber: 6, targetScore: 3, timeLimit: 30),
    Level(levelNumber: 7, targetScore: 5, timeLimit: 40),
    Level(levelNumber: 8, targetScore: 2, timeLimit: 25),
    Level(levelNumber: 9, targetScore: 3, timeLimit: 25),
    Level(levelNumber: 10, targetScore: 5, timeLimit: 35),
    Level(levelNumber: 11, targetScore: 6, timeLimit: 35),
    Level(levelNumber: 12, targetScore: 10, timeLimit: 50)
]
