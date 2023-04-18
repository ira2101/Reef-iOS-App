//
//  ConfirmEmailViewController.swift
//  Reef
//
//  Created by Ira Einbinder on 2/2/23.
//

import UIKit

class ConfirmEmailViewController: UIViewController {
    
    struct Props {
        var email: String
    }
    
    var props: Props!
    
    convenience init(email: String) {
        self.init()
        props = Props(email: email)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let confirmEmailLabel = UILabel()
        confirmEmailLabel.text = "Go to the email '\(props.email) to confirm your email address"
        confirmEmailLabel.textAlignment = .center
        
        self.view.addSubview(confirmEmailLabel)
        confirmEmailLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
