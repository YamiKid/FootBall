import UIKit

class SecondInstruction: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenWidth = view.bounds.width
        let screenHeight = view.bounds.height
        
        let font1Name = "Signika-Bold"
        
        let backgroundImage = UIImage(named: "BGBlack")
        let backgroundImageView = UIImageView(image: backgroundImage)
        backgroundImageView.frame = view.bounds
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.alpha = 0.7
        view.addSubview(backgroundImageView)
        
        let arrow = UIImageView(image: UIImage(named: "arrow2"))
        arrow.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(arrow)
        
        let ice = UIImageView(image: UIImage(named: "freezeButton"))
        ice.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ice)
        
        NSLayoutConstraint.activate([
                    // Устанавливаем ширину и высоту кнопки
            ice.widthAnchor.constraint(equalToConstant: 45),
            ice.heightAnchor.constraint(equalToConstant: 45),
                    
                    // Устанавливаем отступы от верхнего и правого краев экрана
            ice.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -16), // Отступ от верхнего края
            ice.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16) // Отступ от правого края
                ])
        
        let instruction = UILabel()
        let attributedText = NSMutableAttributedString(string: """
        When you press the
        button, freezes the
        enemy for 1-2
        seconds, giving the
        player a chance to
        score a goal
        """)
        attributedText.addAttributes([.font: UIFont(name: font1Name, size: 34) ?? UIFont.systemFont(ofSize: 26), .foregroundColor: UIColor.white], range: NSRange(location: 0, length: attributedText.length))
        
        instruction.attributedText = attributedText
        instruction.textAlignment = .center
        instruction.numberOfLines = 0
        instruction.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(instruction)
        
        // Устанавливаем ограничения Auto Layout
        NSLayoutConstraint.activate([
            instruction.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            instruction.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 40),
            instruction.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            instruction.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            arrow.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 40),
            arrow.bottomAnchor.constraint(equalTo: instruction.topAnchor, constant: -10) // Расстояние между изображением и текстом
        ])
        
        // Кнопка Menu
        let nextButton = UIButton(type: .custom)
        nextButton.setImage(UIImage(named: "bigNextButton"), for: .normal)
        nextButton.backgroundColor = .clear
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        view.addSubview(nextButton)
        // Констрейнты для всех элементов
        NSLayoutConstraint.activate([
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.bottomAnchor.constraint(equalTo: instruction.bottomAnchor, constant: 55),
            nextButton.widthAnchor.constraint(equalToConstant: 120),
            nextButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        
    }
    
    @objc func nextTapped() {
        self.dismiss(animated: true){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // Добавляем небольшую задержку
                    if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
                       let rootViewController = window.rootViewController {
                        let currentViewController = rootViewController.presentedViewController ?? rootViewController
                        let secondInstruction = ThirdInstruction()
                        secondInstruction.modalPresentationStyle = .overFullScreen
                        currentViewController.present(secondInstruction, animated: true, completion: nil)
                    } else {
                        print("Ошибка: не найден rootViewController или окно")
                    }
                }
            }

        }
}

