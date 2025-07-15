//
//  LoadViewController.swift
//  soccer
//
//  Created by серёжка . on 19.09.24.
//

import UIKit

class LoadViewController: UIViewController {
    
    var backgroundImage: UIImageView!
    var footballMenImageView: UIImageView!
    var loadingImageView: UIImageView!
    var ballImageView: UIImageView!  // Добавляем для изображения мяча
    var levelButtons: [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Установка фона
        backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "LoadingBG")
        backgroundImage.contentMode = .scaleAspectFill
        view.addSubview(backgroundImage)
        view.sendSubviewToBack(backgroundImage)
        
        // Попытка загрузки изображения footballmen
        if let footballMenImage = UIImage(named: "Footbolmen") {
            footballMenImageView = UIImageView(image: footballMenImage)
            footballMenImageView.contentMode = .scaleAspectFit
            footballMenImageView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(footballMenImageView)
            
            // Настройка Auto Layout для расположения footballmen
            NSLayoutConstraint.activate([
                footballMenImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                footballMenImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor), // Привязка к нижней границе экрана
                footballMenImageView.widthAnchor.constraint(equalToConstant: 350),
                footballMenImageView.heightAnchor.constraint(equalToConstant: 350)
            ])
        } else {
            // Вывод сообщения об ошибке в консоль
            print("Ошибка: Изображение 'footballmen' не найдено.")
        }
        
        // Попытка загрузки изображения loading
        if let loadingImage = UIImage(named: "Loading 1") {
            loadingImageView = UIImageView(image: loadingImage)
            loadingImageView.contentMode = .scaleAspectFit
            loadingImageView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(loadingImageView)
            
            // Настройка Auto Layout для изображения "loading" с увеличенным размером и смещением выше
            NSLayoutConstraint.activate([
                loadingImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                loadingImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200), // Смещение выше
                loadingImageView.widthAnchor.constraint(equalToConstant: 200), // Увеличенный размер
                loadingImageView.heightAnchor.constraint(equalToConstant: 200)  // Увеличенный размер
            ])
        } else {
            // Вывод сообщения об ошибке в консоль
            print("Ошибка: Изображение 'Loading 1' не найдено.")
        }
        
        // Попытка загрузки изображения мяча
        if let ballImage = UIImage(named: "ball") {
            ballImageView = UIImageView(image: ballImage)
            ballImageView.contentMode = .scaleAspectFit
            ballImageView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(ballImageView)
            
            // Настройка Auto Layout для изображения мяча по центру экрана
            NSLayoutConstraint.activate([
                ballImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                ballImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor), // По центру экрана
                ballImageView.widthAnchor.constraint(equalToConstant: 100), // Размер мяча
                ballImageView.heightAnchor.constraint(equalToConstant: 100)  // Размер мяча
            ])
            
            // Запуск анимации прыжка
            startBallJumping()
            
            // Переход на следующий экран через 2-3 секунды
            perform(#selector(goToLoadingViewController), with: nil, afterDelay: 2.5) // Переход через 2.5 секунды
        } else {
            // Вывод сообщения об ошибке в консоль
            print("Ошибка: Изображение 'Ball' не найдено.")
        }
    }
    
    // Функция для анимации прыжка мяча
    func startBallJumping() {
        let jumpHeight: CGFloat = 50  // Высота прыжка
        let jumpDuration: TimeInterval = 0.5  // Продолжительность одного прыжка
        
        // Анимация прыжка вверх и вниз
        UIView.animate(withDuration: jumpDuration,
                       delay: 0,
                       options: [.repeat, .autoreverse, .curveEaseInOut],
                       animations: {
                           // Смещаем мяч вверх на высоту прыжка
                           self.ballImageView.transform = CGAffineTransform(translationX: 0, y: -jumpHeight)
                       },
                       completion: nil)
    }
    
    // Метод перехода на другой экран
    @objc func goToLoadingViewController() {
        let loadingViewController = LoadingViewController()
        navigationController?.pushViewController(loadingViewController, animated: true)
    }
}
