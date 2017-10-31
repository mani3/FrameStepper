//
//  MovieReaderViewController.swift
//  FrameStepper
//
//  Created by Kazuya Shida on 2017/10/31.
//  Copyright © 2017 mani3. All rights reserved.
//

import UIKit

class MovieReaderViewController: UIViewController {

    var url: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let url = self.url {
            
        } else {
            dismiss(animated: true) {}
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
