//
//  BoxOfficeViewModel.swift
//  SeSACRxSummery
//
//  Created by Taekwon Lee on 2023/11/08.
//

import Foundation

import RxSwift
import RxCocoa

final class BoxOfficeViewModel: ViewModelType {
        
    struct Input {
        let searchBarText: ControlProperty<String>
        let searchButtonTap: ControlEvent<Void>
        let cellTap: ControlEvent<IndexPath>
    }
    
    struct Output {
        let items: PublishSubject<[DailyBoxOfficeList]>
        let recent: BehaviorRelay<[String]>
    }
    
    private var recents = [String]()
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let boxOfficeList = PublishSubject<[DailyBoxOfficeList]>()
        let recentList = BehaviorRelay(value: [String]())
        
        input.searchButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchBarText, resultSelector: { _, query in
                guard query.count == 8, let _ = Int(query) else { return  "20231106" }
                return query
            })
            .flatMap { query in
                BoxOfficeNetwork.fetchBoxOfficeData(date: query)
            }
            .subscribe(with: self, onNext: { owner, movie in
                let data = movie.boxOfficeResult.dailyBoxOfficeList
                boxOfficeList.onNext(data)
            })
            .disposed(by: disposeBag)
        
        input.searchBarText
            .subscribe(with: self) { owner, value in
                owner.recents.append(value)
                recentList.accept(owner.recents)
            }
            .disposed(by: disposeBag)
        
        return Output(items: boxOfficeList, recent: recentList)
    }
}
