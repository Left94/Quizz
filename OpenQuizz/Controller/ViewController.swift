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


}


