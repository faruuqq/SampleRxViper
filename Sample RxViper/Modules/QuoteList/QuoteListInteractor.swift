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
//  QuoteListInteractor.swift
//  Sample RxViper
//
//  Created by Faruuq on 18/06/21
// 

import Foundation
import RxSwift

class QuoteListInteractor {
    
    private let apiManager = ApiManager(endpoint: "https://thesimpsonsquoteapi.glitch.me/quotes?count=10")
    private let bag = DisposeBag()
    
    var quoteListSubject = PublishSubject<[QuoteListEntity]>()
    
    func getQuoteList() {
        apiManager.fetchData()
            .subscribe { [weak self] (data: [QuoteListEntity]) in
                guard let self = self else { return }
                self.quoteListSubject.onNext(data)
                self.quoteListSubject.onCompleted()
            } onError: { [weak self] error in
                guard let self = self else { return }
                print(error.localizedDescription)
                self.quoteListSubject.onError(error)
            }.disposed(by: bag)
    }
    
    func loadMetrics() {
        apiManager.checkMetrics()
    }
}
