import UIKit

class WinViewController: UIViewController {
    
    let youScore = GameData.shared.youScore
    let aiScore = GameData.shared.aiScore
    let time = GameData.shared.time
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if LevelManager.shared.getNowLevel() == 12 {
            UserDefaults.standard.set(true, forKey: "lastLevel")
        }

        LevelManager.shared.levelCompleted(currentLevelCompleted: LevelManager.shared.getNowLevel(), result: "star")

   
        let font1Name = "Signika-Bold"
        
        let backgroundImage = UIImage(named: "BGGreen")
        let backgroundImageView = UIImageView(image: backgroundImage)
        backgroundImageView.frame = view.bounds
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.alpha = 0.5
        view.addSubview(backgroundImageView)
        
        let backgroundWinImage = UIImage(named: "BGWin")
        let backgroundWin = UIImageView(image: backgroundWinImage)
        backgroundWin.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundWin)
        
        let backgroundBoardImage = UIImage(named: "BGBoard")
        let backgroundBoard = UIImageView(image: backgroundBoardImage)
        backgroundBoard.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundBoard)
        
        let winLabel = UILabel()
        winLabel.text = "WIN"
        winLabel.font = UIFont(name: font1Name, size: 32)
        winLabel.textColor = .white
        winLabel.textAlignment = .center
        winLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(winLabel)
        
        // Добавление звезд
        let stars = UIImageView(image: UIImage(named: "threeStars"))
        stars.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stars)
        
        let scoreViewImage = UIImage(named: "board")
        let scoreView = UIImageView(image: scoreViewImage)
        scoreView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scoreView)
        
        let yourScoreLabel = UILabel()
        yourScoreLabel.text = "YOU"
        yourScoreLabel.font = UIFont(name: font1Name, size: 14)
        yourScoreLabel.textColor = .white
        yourScoreLabel.textAlignment = .center
        yourScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let aiScoreLabel = UILabel()
        aiScoreLabel.text = "AI"
        aiScoreLabel.font = UIFont(name: font1Name, size: 14)
        aiScoreLabel.textColor = .white
        aiScoreLabel.textAlignment = .center
        aiScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let timeLabel = UILabel()
        timeLabel.text = "TIME"
        timeLabel.font = UIFont(name: font1Name, size: 14)
        timeLabel.textColor = .white
        timeLabel.textAlignment = .center
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let font2Name = "digitalicg"
        
        let yourScoreValue = UILabel()
        yourScoreValue.text = "0\(youScore)"
        yourScoreValue.font = UIFont(name:font2Name, size: 26)
        yourScoreValue.textColor = .white
        yourScoreValue.textAlignment = .center
        yourScoreValue.translatesAutoresizingMaskIntoConstraints = false
        
        let aiScoreValue = UILabel()
        aiScoreValue.text = "0\(aiScore)"
        aiScoreValue.font = UIFont(name:font2Name, size: 26)
        aiScoreValue.textColor = .white
        aiScoreValue.textAlignment = .center
        aiScoreValue.translatesAutoresizingMaskIntoConstraints = false
        
        let timeValue = UILabel()
        timeValue.text = String(format: "00:%02d", time)
        timeValue.font = UIFont(name:font2Name, size: 16)
        timeValue.textColor = .white
        timeValue.textAlignment = .center
        timeValue.translatesAutoresizingMaskIntoConstraints = false
        
        scoreView.addSubview(yourScoreLabel)
        scoreView.addSubview(timeLabel)
        scoreView.addSubview(aiScoreLabel)
        scoreView.addSubview(yourScoreValue)
        scoreView.addSubview(timeValue)
        scoreView.addSubview(aiScoreValue)
        
        // Кнопка Menu
        let menuButton = UIButton()
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        menuButton.setImage(UIImage(named: "menuButtonLevel"), for: .normal)
        menuButton.addTarget(self, action: #selector(menuTapped), for: .touchUpInside)
        view.addSubview(menuButton)
        
        // Кнопка Next
        let nextButton = UIButton()
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setImage(UIImage(named: "nextButton"), for: .normal)
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        view.addSubview(nextButton)
        
        // Констрейнты для всех элементов
        NSLayoutConstraint.activate([

            backgroundWin.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -250),
            backgroundWin.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            winLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -250),
            winLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            backgroundBoard.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -90),
            backgroundBoard.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            scoreView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -70),
            scoreView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stars.topAnchor.constraint(equalTo: winLabel.bottomAnchor, constant: 15),
            stars.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            yourScoreLabel.leadingAnchor.constraint(equalTo: scoreView.leadingAnchor, constant: 10),
            yourScoreLabel.topAnchor.constraint(equalTo: scoreView.topAnchor, constant: 1),
            
            aiScoreLabel.trailingAnchor.constraint(equalTo: scoreView.trailingAnchor, constant: -15),
            aiScoreLabel.topAnchor.constraint(equalTo: scoreView.topAnchor, constant: 1),
            
            timeLabel.centerXAnchor.constraint(equalTo: scoreView.centerXAnchor),
            timeLabel.topAnchor.constraint(equalTo: scoreView.topAnchor, constant: 1),
            
            yourScoreValue.leadingAnchor.constraint(equalTo: yourScoreLabel.leadingAnchor,constant: -2),
            yourScoreValue.topAnchor.constraint(equalTo: yourScoreLabel.bottomAnchor, constant: 10),
            
            aiScoreValue.trailingAnchor.constraint(equalTo: aiScoreLabel.trailingAnchor,constant: 7),
            aiScoreValue.topAnchor.constraint(equalTo: aiScoreLabel.bottomAnchor, constant: 10),
            
            timeValue.centerXAnchor.constraint(equalTo: scoreView.centerXAnchor),
            timeValue.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 15),
            
            // Констрейнты для кнопок
            menuButton.centerXAnchor.constraint(equalTo: backgroundBoard.centerXAnchor,constant: -100),
            menuButton.topAnchor.constraint(equalTo: backgroundBoard.bottomAnchor, constant: 5),
            menuButton.widthAnchor.constraint(equalToConstant: 120),
            menuButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Constraints for nextButton
            nextButton.centerXAnchor.constraint(equalTo: backgroundBoard.centerXAnchor,constant: 100),
            nextButton.topAnchor.constraint(equalTo: backgroundBoard.bottomAnchor, constant: 5),
            nextButton.widthAnchor.constraint(equalToConstant: 120),
            nextButton.heightAnchor.constraint(equalToConstant: 50),
            
        ])

    }
    
    @objc func menuTapped() {
        self.dismiss(animated: true){
            if let gameVC = self.findGameViewController() {
                gameVC.backMenu()
            }
        }
    }
    
    private func findGameViewController() -> GameViewController? {
        // Предположим, что GameViewController был представлен через UINavigationController
        if let navigationController = UIApplication.shared.windows.first?.rootViewController as? UINavigationController {
            return navigationController.viewControllers.first(where: { $0 is GameViewController }) as? GameViewController
        }
        return nil
    }
    
    @objc func nextTapped() {
        self.dismiss(animated: true){
            if let gameVC = self.findGameViewController() {
                if LevelManager.shared.getNowLevel()<12 {
                    UserDefaults.standard.set(LevelManager.shared.getNowLevel()+1, forKey: "nowLevel")
                }
                gameVC.restartGameScene()
            }
        }
    }
}
