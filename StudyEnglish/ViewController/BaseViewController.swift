//
//  BaseViewController.swift
//  StudyEnglish
//
//  Created by jaeyung kim on 2021/04/07.
//

import UIKit

class BaseViewController: UIViewController {
        
    static var name: String? {
        return NSStringFromClass(self).components(separatedBy: ".").last
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    public func present(_ viewControllerToPresent: UIViewController,
                        modalPresentationStyle: UIModalPresentationStyle = .fullScreen,
                        animated flag: Bool = true,
                        completion: (() -> Void)? = nil) {
        
        viewControllerToPresent.modalPresentationStyle = modalPresentationStyle
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    public func getViewController(_ viewName: String?) -> UIViewController? {

        guard let viewName = viewName else { return nil }
        return UIStoryboard(name: viewName, bundle: nil).instantiateViewController(identifier: viewName)
    }

}
