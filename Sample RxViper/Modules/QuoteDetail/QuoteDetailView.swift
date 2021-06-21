// 
//  Copyright (c) 2021 Digital DevOps - New Octo Mobile. All rights reserved.
//
//  This project and associated documentation files are limited to be used,
//  reproduced, distributed, copied, modified, merged, published, sublicensed,
//  and/or sold to only authorized staff. Should you find yourself is unauthorized,
//  please do not use this project and its associated documentation files in any
//  kind of intentions and conditions.
//
//  In order to obtain access to use and involve in this project, you may proceed
//  to inform the authorized staff. By using and involving in this project, you agree
//  to follow our regulations, terms and conditions.
//
//  This project and source code may use libraries or frameworks that are released
//  under various Open-Source license. Use of those libraries and frameworks are
//  governed by their own individual licenses.
//
//  The use of this project and source code follows the guideline as described and
//  explained on confluence.cimbniaga.co.id under OCTO Mobile New Platform project.
//  Please always refer to the project space to follow the guideline.
//
//  QuoteDetailView.swift
//  Sample RxViper
//
//  Created by Faruuq on 18/06/21
// 

import UIKit
import RxSwift
import Kingfisher

class QuoteDetailView: UIViewController {
    
    @IBOutlet weak var simpsonImage: UIImageView!
    @IBOutlet weak var simpsonQuote: UILabel!
    
    private var presenter: QuoteDetailPresenter?
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
    }

    static func instance(withPresenter presenter: QuoteDetailPresenter) -> QuoteDetailView {
        let storyboardId = "QuoteDetailView"
        let storyboard = UIStoryboard(name: storyboardId, bundle: nil)
        guard let anyView = storyboard.instantiateViewController(withIdentifier: storyboardId) as? QuoteDetailView else {
            fatalError("Error loading Storyboard")
        }
        anyView.presenter = presenter
        return anyView
    }

}

extension QuoteDetailView {
    
    fileprivate func loadData() {
        presenter?.quoteSubject
            .subscribe(onNext: { item in
                self.simpsonQuote.text = item.quote
                self.simpsonImage.kf.indicatorType = .activity
                self.simpsonImage.kf.setImage(
                    with: URL(string: item.image),
                    placeholder: nil,
                    options: [
                        .transition(.fade(0.5)),
                        .cacheOriginalImage
                    ],
                    completionHandler: nil)
            }) .disposed(by: bag)
    }
}

