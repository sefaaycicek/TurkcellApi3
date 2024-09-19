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
    
    let nameText : BehaviorRelay<String> = BehaviorRelay(value: "")
    
    let disposeBag = DisposeBag()
    
    var data = BehaviorRelay<[MovieUIModel]>(value : [])
    
    let apiService : ApiServiceProtocol
    init(apiService: ApiServiceProtocol = ApiService()) {
        self.apiService = apiService
    }

    func getData(searchText : String) {
        self.apiService.searchMovies(searchText: searchText)
            .observe(on: MainScheduler.instance)
            .subscribe { response in // closure
                let models = response?.result.map {
                    MovieUIModel(title: $0.title, year: $0.year, type: $0.type, poster: $0.poster)
                }
                self.data.accept(models ?? [])
            } onFailure: { error in
                //(error as? NSError)?.code == 401
                self.data.accept([])
            }.disposed(by: disposeBag)
            
    }
    
    func save() {
        print(nameText.value)
    }
    
    var rowCount : Int {
        return self.data.value.count
    }
    
    func getItem(index : Int) -> MovieUIModel {
        return self.data.value[index]
    }
}
