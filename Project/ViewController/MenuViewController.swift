import UIKit

class MenuViewController: UIViewController {
    var backgroundImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let emptyBackButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.leftBarButtonItem = emptyBackButton
        
        backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        if let bgImage = UIImage(named: "LoadingBG") {
            backgroundImage.image = bgImage
        } else {
            print("Ошибка: изображение LoadingBG не найдено.")
        }
        backgroundImage.contentMode = .scaleAspectFill
        view.addSubview(backgroundImage)
        view.sendSubviewToBack(backgroundImage)
        // Фоновое изображение для уровней
        let levelsBG = UIImageView()
        if let levelsBgImage = UIImage(named: "LevelsBG") {
            levelsBG.image = levelsBgImage
        } else {
            print("Ошибка: изображение LevelsBG не найдено.")
        }
        levelsBG.contentMode = .scaleAspectFit
        levelsBG.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(levelsBG)

        NSLayoutConstraint.activate([
            levelsBG.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            levelsBG.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -15),
            levelsBG.widthAnchor.constraint(equalToConstant: 950),
            levelsBG.heightAnchor.constraint(equalToConstant: 375)
        ])

        // Добавление кнопок с выравниванием
        view.layoutIfNeeded()  // Для обновления размеров LevelsBG
        addLevelButtons()
    }

    func addLevelButtons() {
        // Удаление старых кнопок и стека
        view.subviews.forEach { subview in
            if subview is UIStackView {
                subview.removeFromSuperview()
            }
        }
        
        let buttonWidth: CGFloat = 60
        let buttonHeight: CGFloat = 55
        let buttonsPerRow = 4
        let totalLevels = 12 // Общее количество уровней
        let unlockedLevels = LevelManager.shared.unlockedLevels // Получаем разблокированные уровни
        let lastUnlockedLevel = unlockedLevels.max() ?? 0

        // Основной вертикальный стек
        let mainStack = UIStackView()
        mainStack.axis = .vertical
        mainStack.alignment = .center
        mainStack.distribution = .equalSpacing
        mainStack.spacing = 20
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainStack)

        // Распределение уровней по строкам
        for level in 1...totalLevels {
            if (level - 1) % buttonsPerRow == 0 {
                let rowStack = UIStackView()
                rowStack.axis = .horizontal
                rowStack.alignment = .center
                rowStack.distribution = .equalSpacing
                rowStack.spacing = 20
                rowStack.translatesAutoresizingMaskIntoConstraints = false
                mainStack.addArrangedSubview(rowStack)
            }
            
            let levelButton = UIButton(type: .custom)
            levelButton.addTarget(self, action: #selector(levelButtonTapped(_:)), for: .touchUpInside)
            
            // Если уровень разблокирован, ставим изображение доступного уровня, иначе замок
            if unlockedLevels.contains(level) {
                if let levelButtonImage = UIImage(named: "LevelButtonBG") {
                    levelButton.setImage(levelButtonImage, for: .normal)
                } else {
                    print("Ошибка: изображение LevelButtonBG не найдено.")
                }
                
                levelButton.isUserInteractionEnabled = true // Кнопка активна
                levelButton.alpha = 1.0 // Уровень полностью видим
                
                let levelLabel = UILabel()
                levelLabel.text = "\(level)"
                levelLabel.textColor = .white // Цвет текста (можно изменить по необходимости)
                levelLabel.font = UIFont(name: "Signika-Bold", size: 32) // Установите свой кастомный шрифт
                levelLabel.textAlignment = .center
                levelLabel.translatesAutoresizingMaskIntoConstraints = false
                levelLabel.alpha = 0.8
                
                levelButton.addSubview(levelLabel)
    
                NSLayoutConstraint.activate([
                    levelLabel.centerXAnchor.constraint(equalTo: levelButton.centerXAnchor),
                    levelLabel.centerYAnchor.constraint(equalTo: levelButton.centerYAnchor)
                ])
                
                let starsStack: UIStackView
                if LevelManager.shared.getLastLevel()  {
                    starsStack = createStarsForUnlockedLevels()
                     // Пустые звезды для последнего открытого уровня
                } else if level == lastUnlockedLevel{
                    starsStack = createStarsForLockedLevels()
                     // Заполненные звезды для других открытых уровней
                } else {
                    starsStack = createStarsForUnlockedLevels()
                }
                
                levelButton.addSubview(starsStack)
                // Центрируем звезды внутри кнопки
                NSLayoutConstraint.activate([
                    starsStack.centerXAnchor.constraint(equalTo: levelButton.centerXAnchor),
                    starsStack.topAnchor.constraint(equalTo: levelButton.bottomAnchor, constant: 2)
                ])
                
            } else {
                if let lockLevelImage = UIImage(named: "LockLevel") {
                    levelButton.setImage(lockLevelImage, for: .normal)
                } else {
                    print("Ошибка: изображение LockLevel не найдено.")
                }
                
                levelButton.isUserInteractionEnabled = false // Кнопка заблокирована
                
                let starsStack = createStarsForLockedLevels()
                levelButton.addSubview(starsStack)
                // Центрируем звезды внутри кнопки
                NSLayoutConstraint.activate([
                    starsStack.centerXAnchor.constraint(equalTo: levelButton.centerXAnchor),
                    starsStack.topAnchor.constraint(equalTo: levelButton.bottomAnchor, constant: 2)
                ])
            }

            levelButton.tag = level // Устанавливаем тег для идентификации уровня
            
            levelButton.translatesAutoresizingMaskIntoConstraints = false
            levelButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
            levelButton.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true

            // Добавляем кнопку в последнюю строку
            if let lastRowStack = mainStack.arrangedSubviews.last as? UIStackView {
                lastRowStack.addArrangedSubview(levelButton)
            }
        }

        // Устанавливаем констрейнты для основного стека
        NSLayoutConstraint.activate([
            mainStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainStack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }


    
    func createStarsForUnlockedLevels() -> UIStackView {
        let starsStack = UIStackView()
        starsStack.axis = .horizontal
        starsStack.alignment = .center
        starsStack.translatesAutoresizingMaskIntoConstraints = false
        let starImageView = UIImageView()
        let starImage = UIImage(named: "PaintedStar")
        starImageView.image = starImage
        starImageView.translatesAutoresizingMaskIntoConstraints = false
        starImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        starImageView.heightAnchor.constraint(equalToConstant: 15).isActive = true
        starsStack.addArrangedSubview(starImageView)
        
        return starsStack
    }

    func createStarsForLockedLevels() -> UIStackView {
        let starsStack = UIStackView()
        starsStack.axis = .horizontal
        starsStack.alignment = .center
        starsStack.translatesAutoresizingMaskIntoConstraints = false
        let starImageView = UIImageView()
        let starImage = UIImage(named: "UnPaintedStar")
        starImageView.image = starImage
        starImageView.translatesAutoresizingMaskIntoConstraints = false
        starImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        starImageView.heightAnchor.constraint(equalToConstant: 15).isActive = true
        starsStack.addArrangedSubview(starImageView)
        
        return starsStack
    }


    @objc func levelButtonTapped(_ sender: UIButton) {
        let level = sender.tag
        UserDefaults.standard.set(level, forKey: "nowLevel")
        
        let gameViewController = GameViewController()
        navigationController?.pushViewController(gameViewController, animated: true)
    }
    
    func loadUnlockedLevels() {
        let defaults = UserDefaults.standard
        if let savedLevels = defaults.array(forKey: "unlockedLevels") as? [Int] {
            LevelManager.shared.unlockedLevels = savedLevels
        } else {
            LevelManager.shared.unlockedLevels = [1]
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUnlockedLevels()
        addLevelButtons()
    }
}
