//
//  ElevensViewController.swift
//  LiftApexPowerVault
//
//  Created by LiftApexPowerVault on 2024/11/13.
//

import UIKit
import AVFoundation

class LiftElevensVC: UIViewController {
    
    //MARK: - Declare IBOutlets
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var soundButton: UIButton!
    
    //MARK: - Declare Variables
    var game = LiftElevensGame()
    var selectedCards = [LiftCard]()
    var player: AVAudioPlayer?
    var isSoundOn = true
    
    //MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBoard()
    }
    
    //MARK: - Functions
    func setupBoard() {
        for (index, button) in cardButtons.enumerated() {
            if index < game.board.count {
                let card = game.board[index]
                let cardImage = UIImage(named: card.imageName)
                button.setImage(cardImage, for: .normal)
                button.setTitle("", for: .normal) // Remove any text
                
                // Reset border for all buttons
                button.layer.borderWidth = 0
                button.layer.borderColor = UIColor.clear.cgColor
                
                // Play sound when a new card is shown
                //                if isSoundOn {
                //                    playSound(named: "cardFlip")
                //                }
            } else {
                button.setImage(nil, for: .normal)
                button.setTitle("", for: .normal)
                
                // Reset border for unused buttons
                button.layer.borderWidth = 0
                button.layer.borderColor = UIColor.clear.cgColor
            }
        }
    }
    
    // Sound Playing Function
    func playSound(named soundName: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("Error playing sound: \(error)")
        }
    }
    
    //MARK: - Declare IBActions
    @IBAction func cardTapped(_ sender: UIButton) {
        if isSoundOn {
            playSound(named: "tap")
        }
        guard let index = cardButtons.firstIndex(of: sender), index < game.board.count else { return }
        
        let selectedCard = game.board[index]
        
        if selectedCards.contains(selectedCard) {
            selectedCards.removeAll { $0 == selectedCard }
            sender.layer.borderWidth = 0
            sender.layer.borderColor = UIColor.clear.cgColor
        } else {
            selectedCards.append(selectedCard)
            sender.layer.borderWidth = 2
            sender.layer.borderColor = UIColor.yellow.cgColor
        }
        
        // Check if 2 cards selected and add to 11
        if selectedCards.count == 2 && game.isPairAddingToEleven(selectedCards[0], selectedCards[1]) {
            if isSoundOn {
                playSound(named: "cardFlip")
            }
            game.removeCards(selectedCards)
            selectedCards.removeAll()
            setupBoard()
            
        }
        
        // Check if 3 face cards (J, Q, K) selected
        if selectedCards.count == 3 && game.isFaceCardSet(selectedCards) {
            if isSoundOn {
                playSound(named: "cardFlip")
            }
            game.removeCards(selectedCards)
            selectedCards.removeAll()
            setupBoard()
        }
    }
    
    @IBAction func resetGameTapped(_ sender: UIButton) {
        game = LiftElevensGame() // Reset the game state
        selectedCards.removeAll()
        setupBoard()
        
        if isSoundOn {
            playSound(named: "reset")
        }
    }
    
    @IBAction func soundToggleTapped(_ sender: UIButton) {
        isSoundOn.toggle()
        let soundButtonTitle = isSoundOn ? "Sound: On" : "Sound: Off"
        soundButton.setTitle(soundButtonTitle, for: .normal)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
