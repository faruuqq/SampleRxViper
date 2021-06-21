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
//  QuoteListView.swift
//  Sample RxViper
//
//  Created by Faruuq on 18/06/21
// 

import UIKit
import RxSwift
import RxCocoa

class QuoteListView: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var presenter: QuoteListPresenter?
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Simpson Quotes"
        bindToTableView()
        handleSelectedRow()
        presenter?.loadMetrics()
    }

    static func instance(withPresenter presenter: QuoteListPresenter) -> QuoteListView {
        let storyboardId = "QuoteListView"
        let storyboard = UIStoryboard(name: storyboardId, bundle: nil)
        guard let anyView = storyboard.instantiateViewController(withIdentifier: storyboardId) as? QuoteListView else {
            fatalError("Error loading Storyboard")
        }
        anyView.presenter = presenter
        return anyView
    }

}

extension QuoteListView {
    
    fileprivate func bindToTableView() {
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        presenter?.loadQuoteList()
        presenter?.quoteListSubject
            .bind(
            to: tableView.rx.items(
                cellIdentifier: "cell",
                cellType: UITableViewCell.self)) {
                row, item, cell in
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = item.quote
        }.disposed(by: bag)
    }
    
    fileprivate func handleSelectedRow() {
        self.tableView.rx.modelSelected(QuoteListEntity.self).bind { [weak self] item in
            guard let self = self else { return }
            if let indexPath = self.tableView.indexPathForSelectedRow {
                self.tableView.deselectRow(at: indexPath, animated: true)
            }
            let quoteDetailEntity = QuoteDetailEntity(
                image: item.image,
                quote: item.quote)
            self.presenter?.navigateToDetailView(using: self.navigationController!, with: quoteDetailEntity)
            
        }.disposed(by: bag)
    }
}

