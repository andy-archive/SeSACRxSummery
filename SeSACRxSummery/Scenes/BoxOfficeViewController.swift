//
//  BoxOfficeViewController.swift
//  SeSACRxSummery
//
//  Created by jack on 2023/11/06.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class BoxOfficeViewController: UIViewController {
    
    private let tableView = UITableView()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout() )
    private let searchBar = UISearchBar()
    
    private let disposeBag = DisposeBag()
    
    // Subject
    private let items = PublishSubject<[DailyBoxOfficeList]>() // 배열의 기본 형태
    
//    // Relay
    // completed, .error를 발생하지 않고 Dispose되기 전까지 계속 작동하기 때문에 UI Event에서 사용하기 적절함
    private let recent = BehaviorRelay(value: ["Test 4", "Test 5", "Test 6"])
    
//    // Subject
    //BehaviorSubject(value: ["Test 4", "Test 5", "Test 6"]) // Subject를 통한 옵저버블의 이벤트 전달
    
//    // Observable
//    private let items = Observable.just(["Test 1", "Test 2", "Test 3"])
//    Observable.just(["Test 4", "Test 5", "Test 6"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        bind()
    }
    
    private func bind() {
        
        // UITableView
        items
            .bind(to: tableView.rx.items(cellIdentifier: "MovieCell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = "\(element) @ row \(row)"
            }
            .disposed(by: disposeBag)
        
        // UICollectionView
        recent
            .bind(to: collectionView.rx.items(cellIdentifier: MovieCollectionViewCell.identifier, cellType: MovieCollectionViewCell.self)) {
                (row, element, cell) in
                cell.label.text = "\(element) @ row \(row)"
            }
            .disposed(by: disposeBag)
        
        // UISearchBar
        searchBar
            .rx
            .searchButtonClicked
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .flatMap { BoxOfficeNetwork.fetchBoxOfficeData(date: "20231030") } // 검색 이후 네트워크 처리
            .subscribe(with: self, onNext: { owner, movie in
                print(movie)
                
                // Movie 구조체의 프로퍼티 접근 - 타입이 맞는 것을 가져 오기
                let data = movie.boxOfficeResult.dailyBoxOfficeList
                owner.items.onNext(data)
            })
            .disposed(by: disposeBag)
        
// 값 가져 오기 또는 인덱스 가져 오기
//        tableView
//            .rx
//            .modelSelected(String.self) // -> 값 가져 오기 (타입 일치해야)
//            //.itemSelected // -> 인덱스 가져 오기
//            .subscribe(with: self) { owner, indexPath in
//                print(indexPath)
//            }
//            .disposed(by: disposeBag)

//      // Observable.zip
//      // 값과 인덱스 둘 다 가져 오기
        Observable.zip(tableView.rx.modelSelected(String.self), tableView.rx.itemSelected)
            .subscribe(with: self) { owner, value in
                print(value.0, value.1)
                
                ///1. do-try-catch or try!
                ///2. subject
                ///
                ///value() 접근은 가능하지만 에러를 던지게 되어 있다 -> try를 써야 함
                
//                do {
//                    var data = try owner.recent.value()
//                } catch {
//                    print("ERROR")
//                }
//                owner.recent.onNext([value.0]) // Subject를 통한 옵저버블의 이벤트 전달

                ///3. relay
                var data = owner.recent.value + [value.0]
                
                owner.recent.accept(data)
            }
            .disposed(by: disposeBag)
    }
    
    private func configure() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(collectionView)
        view.addSubview(searchBar)
        
        navigationItem.titleView = searchBar
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MovieCell")
        tableView.backgroundColor = .green
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView.backgroundColor = .red
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    static func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 40)
        layout.scrollDirection = .horizontal
        return layout
    }
}
