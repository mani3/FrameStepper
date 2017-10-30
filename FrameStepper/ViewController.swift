//
//  ViewController.swift
//  FrameStepper
//
//  Created by Kazuya Shida on 2017/10/23.
//  Copyright © 2017 mani3. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        av_register_all()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        performSegue(withIdentifier: "MovieListSegue", sender: nil)
    }
}
