//
//  ViewController.swift
//  OpenQuizz
//
//  Created by vincent  on 17/01/2018.
//  Copyright © 2018 Loret Vincent. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var questionView: QuestionView!
    
    var game = Game()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let name = Notification.Name(rawValue: "QuestionsLoaded")
        NotificationCenter.default.addObserver(self, selector: #selector(questionsLoaded), name: name, object: nil)
        startNewGame()
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragQuestionView(_:)))
        questionView.addGestureRecognizer(panGestureRecognizer)
        
    }
    
    @objc func questionsLoaded() {
        newGameButton.isHidden = false
        activityIndicator.isHidden = true
        questionView.title = game.currentQuestion.title
    }

   

    @IBAction func didTapNewGameButton() {
        startNewGame()
    }
    
    private func startNewGame() {
        
        activityIndicator.isHidden = false
        newGameButton.isHidden = true
        
        questionView.title = "Loading..."
        questionView.style = .standard
        
        scoreLabel.text = "O / 10"
        
        game.refresh()
    
    }
    
    @objc func dragQuestionView(_ sender: UIPanGestureRecognizer) {
        
        if game.state == .ongoing{
            switch sender.state {
            case .began, .changed:
                transformQuestionViewWith(gesture: sender)
            case .cancelled, .ended:
                answerQuestion()
            default:
                break
            }
        }
    }
    
    private func transformQuestionViewWith(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: questionView)
        let translationTransform = CGAffineTransform(translationX: translation.x, y: translation.y)
        
        let screenWidht = UIScreen.main.bounds.width
        let translationPerCent = translation.x/(screenWidht/2)
        let rotationAngle = (CGFloat.pi / 6) * translationPerCent
        
        let rotationTransform = CGAffineTransform(rotationAngle: rotationAngle)
        
        let transform = translationTransform.concatenating(rotationTransform)
        questionView.transform = transform
        
        if translation.x > 0 {
            questionView.style = .correct
        } else {
            questionView.style = .incorrect
        }
    
    }
    
    private func answerQuestion() {
        switch questionView.style {
        case .correct:
            game.answerCurrentQuestion(with: true)
        case .incorrect:
            game.answerCurrentQuestion(with: false)
        case .standard:
            break
        case .over:
            break
        }
        scoreLabel.text = "\(game.score) / 10"
        
        
        let screenWidht = UIScreen.main.bounds.width
        var translationTransform: CGAffineTransform
        
        if questionView.style == .correct {
            translationTransform = CGAffineTransform(translationX:  screenWidht, y: 0 )
        }else {
            translationTransform = CGAffineTransform(translationX: -screenWidht, y: 0)
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.questionView.transform = translationTransform
        }) { (succes) in
            if succes {
                self.showQuestionView()
            }
        }
    }
    
    private func showQuestionView() {
        questionView.transform = .identity
        questionView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        questionView.style = .standard
        
        switch game.state {
        case .ongoing:
            questionView.title = game.currentQuestion.title
        case .over:
            questionView.style = .over
            questionView.title = "Game Over"
        }
        if game.state == .over {
            questionView.transform = CGAffineTransform(rotationAngle: 4)
            UIView.animate(withDuration: 1, animations: {
                self.questionView.transform = .identity
            })
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options:  [], animations: {
            self.questionView.transform = .identity
        }, completion: nil)
        
    }
}


