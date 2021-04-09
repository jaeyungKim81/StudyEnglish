//
//  WordGameViewController.swift
//  StudyEnglish
//
//  Created by jaeyung kim on 2021/04/07.
//

import UIKit

class WordGameViewController: BaseViewController {
    
    struct LabelObject {
        let word: String
        let engLabel: UILabel
//        let korLabel: UILabel?
    }
    
    @IBOutlet var baseView: UIView!
    @IBOutlet var toolbarView: UIView!
    @IBOutlet var textField: UITextField!
    
    var labelObjectArray: [LabelObject] = []
    
    var timer: Timer?
    var releaseWordCount = 0

    var screenWidth: CGFloat = 0.0
    var screenHeight: CGFloat = 0.0
    
    var words: [String] = ["test0", "test02", "test03",
                           "test1", "test12", "test13",
                           "test2", "test22", "test23",
                           "test3", "test32", "test33",
                           "test4", "test42", "test43",
                           "test5", "test52", "test53",
                           "test6", "test62", "test63"]
    var successWords: [String] = []
    var failWords: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        textField.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        screenWidth = baseView.frame.size.width
        screenHeight = baseView.frame.size.height
        
        textField.inputAccessoryView = toolbarView
    }
    
    func startGame() {
        
        timer = Timer.scheduledTimer(timeInterval: 0.01,
                                     target: self,
                                     selector: #selector(moveObject),
                                     userInfo: nil,
                                     repeats: true)
        
        releaseWord()
    }
    
    @objc func releaseWord () {
        
        if releaseWordCount < words.count {
            addWordLabel()
            
            arc4random()
            let timeInterval = TimeInterval(Double(arc4random_uniform(4))+0.3)
            timer = Timer.scheduledTimer(timeInterval: timeInterval,
                                         target: self,
                                         selector: #selector(releaseWord),
                                         userInfo: nil,
                                         repeats: false)
        }
    }
    
    @objc func moveObject() {
        let frameHeight = baseView.frame.size.height
        var failWord: String?
        let moveGap: CGFloat = 0.5
        
        labelObjectArray.forEach { object in
            var frame = object.engLabel.frame
            frame.origin.y = frame.origin.y + moveGap
            object.engLabel.frame = frame
            
            if (frameHeight - frame.origin.y) < 100 {
                if (frameHeight < frame.origin.y) {
                    failWord = object.word
                } else {
                    object.engLabel.textColor = .red
                }
            }
        }
        removeFailWord(failWord)
    }
    
    func removeFailWord(_ failWord: String?) {
        guard let failWord = failWord else { return }
        var index = 0
        labelObjectArray.forEach{ object in
            if object.word == failWord {
                failWords.append(failWord)
                object.engLabel.removeFromSuperview()
                labelObjectArray.remove(at: index)
                print("failWord : \(failWord)")
                
                endMission()
                return
            }
            index += 1
        }
    }
    
    @objc private func addWordLabel() {
        
        let word = words[releaseWordCount]
        
        let engLabel = UILabel()
        engLabel.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        engLabel.text = word
        engLabel.sizeToFit()
        engLabel.backgroundColor = .yellow
        let xPosition = CGFloat(arc4random_uniform(UInt32(screenWidth) - 50))
        baseView.addSubview(engLabel)
        
        engLabel.frame.origin.x = xPosition
        engLabel.frame.origin.y = 0

        let labelObject = LabelObject(word: word,
                                      engLabel: engLabel)
        
        labelObjectArray.append(labelObject)
        releaseWordCount += 1
    }
    
    func endMission() {
        
        if releaseWordCount == words.count,
           labelObjectArray.count == 0 {
//            if successWords.count == words.count {
//                missionComplete()
//            } else {
//                missionFail()
//            }
            
            print("successWord = \(successWords)")
            print("failWord = \(failWords)")
            
            stopTimer()
        }
    }

//    func missionComplete() {
//        print("complete")
//    }
//
//    func missionFail() {
//        print("fail")
//    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }


    @objc internal func keyboardWillShow(_ notification : Notification?) -> Void {
        
        if let userInfo = notification?.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey],
            let keyboardSize = (userInfo as? NSValue)?.cgRectValue {
            let keyboardHeight : Int = Int(keyboardSize.height)
            print("keyboardHeight",keyboardHeight)
            changeBaseViewHeight(gap: CGFloat(keyboardHeight))
        }
        
        startGame()
    }
    
    func changeBaseViewHeight(gap: CGFloat) {
        var frame = baseView.frame
        let height = gap - toolbarView.frame.size.height - view.safeAreaInsets.bottom
        frame.size.height = frame.size.height - height
        baseView.frame = frame
    }
    
    func removeSuccessWord(_ successWord: String?) {
        guard let successWord = successWord else { return }
        
        var index = 0
        labelObjectArray.forEach { object in
            if object.word == successWord {
                object.engLabel.removeFromSuperview()
                successWords.append(object.word)
                labelObjectArray.remove(at: index)
                print("success: \(successWord)")
                endMission()
                return
            }
            index += 1
        }
    }
}

extension WordGameViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//    if textField == emailTextField {
//          passwordTextField.becomeFirstResponder()
//        } else {
//          passwordTextField.resignFirstResponder()
//        }
        let word = textField.text
        var successWord: String?
        for object in labelObjectArray {
            if object.word == word {
                successWord = word
            }
        }
        textField.text = ""
        removeSuccessWord(successWord)
        return true
    }
}
