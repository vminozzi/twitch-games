//
//  HomeViewController.swift
//  Games
//
//  Created by Vinicius on 23/01/18.
//  Copyright © 2018 Vinicius Minozzi. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        AccessTokenRequest().request { token, error in
            print(token?.access_token ?? "")
            print(error?.message ?? "")
        }
    }
}
