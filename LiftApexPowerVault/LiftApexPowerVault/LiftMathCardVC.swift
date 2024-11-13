//
//  MathCardVC.swift
//  LiftApexPowerVault
//
//  Created by LiftApexPowerVault on 2024/11/13.
//

import UIKit

class LiftMathCardVC: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var imgCardOne: UIImageView!
    @IBOutlet weak var imgMathSign: UIImageView!
    @IBOutlet weak var imgCardTwo: UIImageView!
    @IBOutlet weak var txtAnswer: UITextField!
    
    //MARK: - Variables
    private var numberOne = 0
    private var numberTwo = 0
    private var correctAnswer = 0
    private var mathOperator = ""
    private let suits = ["♠️", "♥️", "♦️", "♣️"]
    private let values = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]
    
    //MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        generateRandomEquation()
    }
    
    //MARK: - Functions
    func generateRandomEquation() {
        // Clear text field
        txtAnswer.text = ""
        
        // Randomly select values and suits for the cards
        let valueOne = values.randomElement() ?? "A"
        let valueTwo = values.randomElement() ?? "A"
        let suitOne = suits.randomElement() ?? "♠️"
        let suitTwo = suits.randomElement() ?? "♠️"
        
        // Get numbers for calculating the answer based on card values
        numberOne = getNumberFromCardValue(valueOne)
        numberTwo = getNumberFromCardValue(valueTwo)
        
        // Set the images for the two cards
        imgCardOne.image = UIImage(named: "\(valueOne)\(suitOne)") // Assumes images named "2♠️", "K♥️", etc.
        imgCardTwo.image = UIImage(named: "\(valueTwo)\(suitTwo)")
        
        // Randomly select a math operator
        let operators = ["+", "-", "x", "÷"]
        mathOperator = operators.randomElement() ?? "+"
        
        // Set the math sign image based on the selected operator
        imgMathSign.image = UIImage(named: mathOperator) // Assumes images named "+", "-", "x", "/"
        
        // Calculate the correct answer based on the operator
        switch mathOperator {
        case "+":
            correctAnswer = numberOne + numberTwo
        case "-":
            correctAnswer = numberOne - numberTwo
        case "x":
            correctAnswer = numberOne * numberTwo
        case "÷":
            correctAnswer = numberTwo != 0 ? numberOne / numberTwo : 0
        default:
            break
        }
    }
    
    func getNumberFromCardValue(_ value: String) -> Int {
        // Convert card value to corresponding number for calculation
        switch value {
        case "A": return 1
        case "2": return 2
        case "3": return 3
        case "4": return 4
        case "5": return 5
        case "6": return 6
        case "7": return 7
        case "8": return 8
        case "9": return 9
        case "10": return 10
        case "J": return 11
        case "Q": return 12
        case "K": return 13
        default: return 0
        }
    }
    
    func checkAnswer() {
        guard let userAnswer = Int(txtAnswer.text ?? "") else {
            showAlert(message: "Please enter a valid number.")
            return
        }
        
        if userAnswer == correctAnswer {
            showAlert(message: "Correct! 🎉") {
                self.generateRandomEquation() // Generate a new equation after dismissing alert
            }
        } else {
            showAlert(message: "Wrong. The correct answer is \(correctAnswer).")
        }
    }
    
    func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Result", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?() // Call the completion handler, if provided
        })
        present(alert, animated: true)
    }
    
    //MARK: - IBActions
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCheckAnswer(_ sender: Any) {
        checkAnswer()
    }
}
