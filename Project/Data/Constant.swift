class GameData {

    static let shared = GameData()
    
    var timeLeft = 45
    var time = 45
    var youScore = 0
    var aiScore = 0
    var moveSpeed = 175.0
    
    
    // Приватный инициализатор запрещает создание других экземпляров
    private init() {}
}
