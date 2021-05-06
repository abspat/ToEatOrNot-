//
//  TextViewController.swift
//  ToEatOrNot
//
// Created by Abhay Patel on 5/3/21
//

import UIKit
import NaturalLanguage

class TextViewController: UIViewController {

    @IBOutlet weak var predictionLabel: UILabel!
    @IBOutlet weak var lunchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lunchTextField.delegate = self
    }
    
    @IBAction func checkLunchText(_ sender: Any) {
        predictLunch()
    }
    
    private func predictLunch() {
        predictionLabel.textColor = .lightGray
        guard let text = lunchTextField.text, !text.isEmpty else {
            predictionLabel.text = "Text can not be empty 🤨"
            return
        }
        do {
            let model = try NLModel(mlModel: FoodTextClassifier_1().model)
            guard let classLabel = model.predictedLabel(for: text),
                let prediction = Prediction(classLabel: classLabel) else {
                    predictionLabel.text = Prediction.empty.description
                    return
            }
            predictionLabel.text = prediction.description
            predictionLabel.textColor = prediction.color
        } catch {
            fatalError("Failed to load Text Classifier ML model: \(error)")
        }
    }
}

extension TextViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        lunchTextField.resignFirstResponder()
        predictLunch()
        return true
    }
}
