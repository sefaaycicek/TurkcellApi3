//
//  ViewControllerViewModel.swift
//  TurkcellApi3
//
//  Created by Sefa Aycicek on 19.09.2024.
//

import UIKit
import RxRelay
import RxSwift

class ViewControllerViewModel {
    
    let disposeBag = DisposeBag()
    
    var data = BehaviorRelay<[MovieUIModel]>(value : [])
    
    let apiService : ApiServiceProtocol
    init(apiService: ApiServiceProtocol = ApiService()) {
        self.apiService = apiService
    }

    func getData() {
        self.apiService.searchMovies()
            .observe(on: MainScheduler.instance)
            .subscribe { response in // closure
                let models = response?.result.map {
                    MovieUIModel(title: $0.title, year: $0.year, type: $0.type, poster: $0.poster)
                }
                self.data.accept(models ?? [])
            } onFailure: { error in
                self.data.accept([])
            }.disposed(by: disposeBag)
            
    }
}
