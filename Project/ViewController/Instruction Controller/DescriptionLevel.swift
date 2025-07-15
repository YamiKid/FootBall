import UIKit

class DescriptionLevel: UIViewController {
    
    var currentLevel: Level?
    var timeLeft: Int = 0
    var targetGoal: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadLevel(levelNumber: LevelManager.shared.getNowLevel())
        
        if let level = currentLevel {

            timeLeft = Int(level.timeLimit)
            targetGoal = level.targetScore
            
            print("Loaded Level \(level.levelNumber) with Target: \(targetGoal) and Time: \(timeLeft) seconds")
        }

        let font1Name = "Signika-Bold"
        
        let backgroundImage = UIImage(named: "BGBlack")
        let backgroundImageView = UIImageView(image: backgroundImage)
        backgroundImageView.frame = view.bounds
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.alpha = 0.7
        view.addSubview(backgroundImageView)
        
        // Настройка фона доски
        let backgroundBoardImage = UIImage(named: "BGBoard")
        let backgroundBoard = UIImageView(image: backgroundBoardImage)
        backgroundBoard.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundBoard)
        
        // Настройка уровня
        let backgroundLevelImage = UIImage(named: "DescriptionLevel")
        let backgroundLevel = UIImageView(image: backgroundLevelImage)
        backgroundLevel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundLevel)
        
        if LevelManager.shared.getNowLevel() == 1 {
            let instruction = UILabel()
            let attributedText = NSMutableAttributedString(string: """
            At the beginning of the game,
            the required number of goals
            is indicated
            """)
            attributedText.addAttributes([.font: UIFont(name: font1Name, size: 26) ?? UIFont.systemFont(ofSize: 26), .foregroundColor: UIColor.white], range: NSRange(location: 0, length: attributedText.length))
            
            instruction.attributedText = attributedText
            instruction.textAlignment = .center
            instruction.numberOfLines = 0
            instruction.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(instruction)
            
            NSLayoutConstraint.activate([
                instruction.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                instruction.bottomAnchor.constraint(equalTo: backgroundLevel.topAnchor, constant: -30),
                ])
        }

        
        // Настройка другого лейбла
        let label = UILabel()
        label.text = """
        To win you need to
        score \(targetGoal) goals
        """
        label.font = UIFont(name: "Signika-Bold", size: 32)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label) // Добавляем label в иерархию
        
        let labelLevel = UILabel()
        labelLevel.text = "LEVEL \(LevelManager.shared.getNowLevel())"
        labelLevel.font = UIFont(name: "Signika-Bold", size: 32)
        labelLevel.textColor = .white
        labelLevel.textAlignment = .center
        labelLevel.numberOfLines = 0
        labelLevel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(labelLevel) // Добавляем label в иерархию
        
        // Установка ограничений
        NSLayoutConstraint.activate([
            backgroundBoard.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            backgroundBoard.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            backgroundLevel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundLevel.bottomAnchor.constraint(equalTo: backgroundBoard.topAnchor, constant: -5),
            
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor), // Центрируем по горизонтали
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor), // Центрируем по вертикали
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            labelLevel.centerXAnchor.constraint(equalTo: backgroundLevel.centerXAnchor), // Центрируем по горизонтали
            labelLevel.centerYAnchor.constraint(equalTo: backgroundLevel.centerYAnchor), // Центрируем по вертикали
            labelLevel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            labelLevel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        // Настройка кнопки
        let nextButton = UIButton(type: .custom)
        nextButton.setImage(UIImage(named: "PlayButton"), for: .normal)
        nextButton.backgroundColor = .clear
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        view.addSubview(nextButton)

        // Ограничения для кнопки
        NSLayoutConstraint.activate([
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.topAnchor.constraint(equalTo: backgroundBoard.bottomAnchor, constant: 40), // Установите отступ от label
            nextButton.widthAnchor.constraint(equalToConstant: 120),
            nextButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    func loadLevel(levelNumber: Int) {
        if levelNumber > 0 && levelNumber <= levels.count {
            currentLevel = levels[levelNumber - 1]
        } else {
            print("Invalid level number")
        }
    }
    
    @objc func nextTapped() {
        self.dismiss(animated: true) {
            NotificationCenter.default.post(name: .didFinishInstruction, object: nil)
        }
    }
}
