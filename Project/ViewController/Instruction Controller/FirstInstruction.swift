import UIKit

class FirstInstruction: UIViewController {
    
    let youScore = GameData.shared.youScore
    let aiScore = GameData.shared.aiScore
    let time = GameData.shared.time

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
        
        let arrow = UIImageView(image: UIImage(named: "arrow1"))
        arrow.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(arrow)
        
        let instruction = UILabel()
        let attributedText = NSMutableAttributedString(string: """
        The scoreboard
        shows your goals,
        your opponent's
        goals and the match
        time
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
            instruction.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 120),
            instruction.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            instruction.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            arrow.centerXAnchor.constraint(equalTo: view.centerXAnchor),
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
        
        
        let scoreBoardImage = UIImage(named: "scoreBoard")
        let scoreBoardImageView = UIImageView(image: scoreBoardImage)
        scoreBoardImageView.translatesAutoresizingMaskIntoConstraints = false
        scoreBoardImageView.contentMode = .scaleToFill
        view.addSubview(scoreBoardImageView)
        
        NSLayoutConstraint.activate([
            scoreBoardImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scoreBoardImageView.bottomAnchor.constraint(equalTo: arrow.topAnchor, constant: 13),
            scoreBoardImageView.widthAnchor.constraint(equalToConstant: screenWidth * 0.4),
            scoreBoardImageView.heightAnchor.constraint(equalToConstant: screenHeight * 0.155),
        ])
        
        let font2Name = "digitalicg"
        
        let label1 = createLabel(text: "YOU", fontName: font1Name, fontSize: 18)
        label1.frame = CGRect(x: screenWidth * 0.36, y: screenHeight * 0.925, width: 100, height: 30)
        view.addSubview(label1)
        
        let label2 = createLabel(text: "TIME", fontName: font1Name, fontSize: 18)
        label2.frame = CGRect(x: screenWidth * 0.5, y: screenHeight * 0.925, width: 100, height: 30)
        view.addSubview(label2)

        let label3 = createLabel(text: "AI", fontName: font1Name, fontSize: 18)
        label3.frame = CGRect(x: screenWidth * 0.63, y: screenHeight * 0.925, width: 100, height: 30)
        view.addSubview(label3)
        
        let label4 = createLabel(text: "0\(youScore)", fontName: font2Name, fontSize: 26)
        label4.frame = CGRect(x: screenWidth * 0.365, y: screenHeight * 0.865, width: 100, height: 30)
        view.addSubview(label4)
        
        let label5 = createLabel(text: String(format: "00:%02d", time), fontName: font2Name, fontSize: 20)
        label5.frame = CGRect(x: screenWidth * 0.5, y: screenHeight * 0.867, width: 100, height: 30)
        view.addSubview(label5)

        let label6 = createLabel(text: "0\(aiScore)", fontName: font2Name, fontSize: 26)
        label6.frame = CGRect(x: screenWidth * 0.635, y: screenHeight * 0.865, width: 100, height: 30)
        view.addSubview(label6)
        
        label4.text = "0\(youScore)"
        label5.text = String(format: "00:%02d", time)
        label6.text = "0\(aiScore)"
        
        NSLayoutConstraint.activate([

            label1.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -view.bounds.width * 0.13),
            label1.topAnchor.constraint(equalTo: scoreBoardImageView.topAnchor, constant: 7),
            
            label2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label2.topAnchor.constraint(equalTo: scoreBoardImageView.topAnchor, constant: 7),
            
            label3.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: view.bounds.width * 0.13),
            label3.topAnchor.constraint(equalTo: scoreBoardImageView.topAnchor, constant: 7),
            
            label4.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -view.bounds.width * 0.13),
            label4.topAnchor.constraint(equalTo: label1.bottomAnchor, constant: 12),
            
            label5.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label5.topAnchor.constraint(equalTo: label2.bottomAnchor, constant: 17),
            
            label6.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: view.bounds.width * 0.13),
            label6.topAnchor.constraint(equalTo: label3.bottomAnchor, constant: 12)
        ])
    }

        
        
    private func createLabel(text: String, fontName: String, fontSize: CGFloat) -> UILabel {
            let label = UILabel()
            label.text = text
            label.font = UIFont(name: fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
            label.textColor = .white
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
    }
    
    @objc func nextTapped() {
        self.dismiss(animated: true){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // Добавляем небольшую задержку
                    if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
                       let rootViewController = window.rootViewController {
                        let currentViewController = rootViewController.presentedViewController ?? rootViewController
                        let secondInstruction = SecondInstruction()
                        secondInstruction.modalPresentationStyle = .overFullScreen
                        currentViewController.present(secondInstruction, animated: true, completion: nil)
                    } else {
                        print("Ошибка: не найден rootViewController или окно")
                    }
                }
            }

        }
    }


