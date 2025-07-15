import UIKit

class LoadingViewController: UIViewController {
    
    var backgroundImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let emptyBackButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.leftBarButtonItem = emptyBackButton
        
        // Установка фона
        setupBackgroundImage()
        
        // Установка изображения с человеком
        let humanImage = setupHumanImage()
        
        // Установка текста-приветствия
        let welcomeTextImage = setupWelcomeTextImage()
        
        // Кнопка "Играть"
        let playButton = setupPlayButton()
        
        // Установка констрейнтов для всех элементов
        NSLayoutConstraint.activate([
            welcomeTextImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeTextImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            welcomeTextImage.widthAnchor.constraint(equalToConstant: 300),
            welcomeTextImage.heightAnchor.constraint(equalToConstant: 100),
            
            humanImage.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -30),
            humanImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            humanImage.widthAnchor.constraint(equalToConstant: 350),
            humanImage.heightAnchor.constraint(equalToConstant: 400),
            
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playButton.topAnchor.constraint(equalTo: humanImage.bottomAnchor, constant: 20),
            playButton.widthAnchor.constraint(equalToConstant: 150),
            playButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // Метод для настройки фонового изображения
    func setupBackgroundImage() {
        backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        if let bgImage = UIImage(named: "LoadingBG") {
            backgroundImage.image = bgImage
        } else {
            print("Ошибка: изображение LoadingBG не найдено.")
        }
        backgroundImage.contentMode = .scaleAspectFill
        view.addSubview(backgroundImage)
        view.sendSubviewToBack(backgroundImage)
    }
    
    // Метод для настройки изображения с человеком
    func setupHumanImage() -> UIImageView {
        let humanImage = UIImageView()
        if let humanImg = UIImage(named: "HumanImage") {
            humanImage.image = humanImg
        } else {
            print("Ошибка: изображение HumanImage не найдено.")
        }
        humanImage.contentMode = .scaleAspectFit
        humanImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(humanImage)
        return humanImage
    }
    
    // Метод для настройки текста-приветствия
    func setupWelcomeTextImage() -> UIImageView {
        let welcomeTextImage = UIImageView()
        if let welcomeTextImg = UIImage(named: "WelcomeText") {
            welcomeTextImage.image = welcomeTextImg
        } else {
            print("Ошибка: изображение WelcomeText не найдено.")
        }
        welcomeTextImage.contentMode = .scaleAspectFit
        welcomeTextImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(welcomeTextImage)
        return welcomeTextImage
    }
    
    // Метод для настройки кнопки "Играть"
    func setupPlayButton() -> UIButton {
        let playButton = UIButton(type: .custom)
        if let playButtonImage = UIImage(named: "PlayButton") {
            playButton.setImage(playButtonImage, for: .normal)
        } else {
            print("Ошибка: изображение PlayButton не найдено.")
        }
        playButton.backgroundColor = .clear
        playButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playButton)
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        return playButton
    }
    
    @objc func playButtonTapped() {
        print("Play button pressed")
        
        let menuViewController = MenuViewController()
        navigationController?.pushViewController(menuViewController, animated: true)
    }
}
