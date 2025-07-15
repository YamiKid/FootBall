import UIKit

class ThirdInstruction: UIViewController {
    
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
        
        let arrow = UIImageView(image: UIImage(named: "arrow3"))
        arrow.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(arrow)
        
        let player = UIImageView(image: UIImage(named: "playerImage1"))
        player.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(player)
        
        NSLayoutConstraint.activate([
                    // Устанавливаем ширину и высоту кнопки
            player.widthAnchor.constraint(equalToConstant: screenWidth * 0.145),
            player.heightAnchor.constraint(equalToConstant: screenHeight * 0.09),
                    
                    // Устанавливаем отступы от верхнего и правого краев экрана
            player.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            player.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: screenHeight * 0.3) // Смещение вверх от центра

                ])
        
        let instruction = UILabel()
        let attributedText = NSMutableAttributedString(string: """
        The character is
        controlled using
        touch gestures (that
        is, the finger will
        follow the player's
        finger on the screen)
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
            instruction.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -140),
            instruction.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            instruction.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
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
            nextButton.bottomAnchor.constraint(equalTo: instruction.bottomAnchor, constant: 100),
            nextButton.widthAnchor.constraint(equalToConstant: 120),
            nextButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        NSLayoutConstraint.activate([
            arrow.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 80),
            arrow.bottomAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 250)
        ])
        
    }
    
    @objc func nextTapped() {
        self.dismiss(animated: true){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // Добавляем небольшую задержку
                    if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
                       let rootViewController = window.rootViewController {
                        let currentViewController = rootViewController.presentedViewController ?? rootViewController
                        let secondInstruction = DescriptionLevel()
                        secondInstruction.modalPresentationStyle = .overFullScreen
                        currentViewController.present(secondInstruction, animated: true, completion: nil)
                    } else {
                        print("Ошибка: не найден rootViewController или окно")
                    }
                }
            }

        }
}

