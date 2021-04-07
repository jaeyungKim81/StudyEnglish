//
//  ViewController.swift
//  StudyEnglish
//
//  Created by jaeyung kim on 2021/04/07.
//

import UIKit

class ViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {

        guard let wordGameViewController = getViewController(WordGameViewController.name)
//            let navigationController = self.navigationController
            else {
            return
        }
        
        self.present(wordGameViewController)
    }

}

