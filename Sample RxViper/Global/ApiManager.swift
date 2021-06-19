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
//  ApiManager.swift
//  Sample RxViper
//
//  Created by Faruuq on 18/06/21
// 

import Foundation
import RxAlamofire
import RxSwift
import Alamofire

enum ErrorHandler: Error {
    case invalidLink
    case failedParsing
    case unknownError
}

class ApiManager {
    
    let endpoint: String!
    
    init(endpoint: String) {
        self.endpoint = endpoint
    }
    
    func fetchData<T: Decodable>() -> Observable<T> {
        guard let url = URL(string: endpoint) else { return
            Observable.error(ErrorHandler.invalidLink)
        }
        return Observable.create { observer in
            request(.get, url)
                .flatMap {
                    $0.validate(statusCode: 200...299)
                        .validate(contentType: ["application/json"])
                        .rx.data()
                }
                .observe(on: MainScheduler.instance)
                .decode(type: T.self, decoder: JSONDecoder())
                .subscribe { data in
                    observer.onNext(data)
                    observer.onCompleted()
                } onError: { error in
                    print(error.localizedDescription)
                    observer.onError(ErrorHandler.failedParsing)
                }
        }
        
    }
    
    func checkMetrics() {
        AF.request(endpoint)
            .cURLDescription { print($0) }
            .responseJSON { print($0.metrics!) }
    }
    
}
