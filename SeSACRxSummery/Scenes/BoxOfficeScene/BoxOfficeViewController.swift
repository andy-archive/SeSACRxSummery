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
    private let searchBar = {
        let bar =  UISearchBar()
        bar.placeholder = "검색어를 입력하세요 yyyyMMdd"
        return bar
    }()
    
    private let viewModel = BoxOfficeViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        bind()
    }
    
    private func bind() {
        let input = BoxOfficeViewModel.Input(searchBarText: searchBar.rx.text.orEmpty, searchButtonTap: searchBar.rx.searchButtonClicked, cellTap: tableView.rx.itemSelected)
        let output = viewModel.transform(input: input)
        
        output.items
            .bind(to: tableView.rx.items(cellIdentifier: "MovieCell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = "\(element.movieNm) | \(element.openDt)"
            }
            .disposed(by: disposeBag)
        
        output.recent
            .asDriver()
            .drive(collectionView.rx.items(cellIdentifier: MovieCollectionViewCell.identifier, cellType: MovieCollectionViewCell.self)) {
                (row, element, cell) in
                cell.label.text = "\(element)"
            }
            .disposed(by: disposeBag)
        
        Observable.zip(tableView.rx.modelSelected(DailyBoxOfficeList.self), tableView.rx.itemSelected)
            .map { (dailyBoxOfficeList, indexPath) in
                dailyBoxOfficeList.movieNm }
            .subscribe(with: self) { _, value in
                var data = output.recent.value
                
                if !output.recent.value.contains(value) { data.append(value) }
                
                output.recent.accept(data)
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
        tableView.backgroundColor = .systemBackground
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView.backgroundColor = .secondarySystemGroupedBackground
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

/* 📝 ViewModel X Intput-Output 전환 이전
 
 // Subject
 private let items = PublishSubject<[DailyBoxOfficeList]>() // 배열의 기본 형태
 
//    // Relay
 // completed, .error를 발생하지 않고 Dispose되기 전까지 계속 작동하기 때문에 UI Event에서 사용하기 적절함
 private let recent = BehaviorRelay(value: [String]())
 
//    // Subject
 //BehaviorSubject(value: ["Test 4", "Test 5", "Test 6"]) // Subject를 통한 옵저버블의 이벤트 전달
 
//    // Observable
//    private let items = Observable.just(["Test 1", "Test 2", "Test 3"])
//    Observable.just(["Test 4", "Test 5", "Test 6"])
 
 
 📌
 private func bind() {
     
     /*
      🛞 items에서 .drive()를 못 쓰는 이유?
      -> drive는 에러 핸들링을 하지 못함
      -> 그에 반해 items인 Subject은 error를 포함한 next, complete를 받을 수 있음
      -> 예외 처리를 대응해야 함
         -> Subject는 asDriver 이용
      
      🛞 recent에 .drive()를 사용가능한 이유?
      -> relay라서 accept만 가능
         -> Relay는 .drive
      */
 
     // 📌 UITableView
     items
//            .asDriver(onErrorJustReturn: <#T##[DailyBoxOfficeList]#>)
         .bind(to: tableView.rx.items(cellIdentifier: "MovieCell", cellType: UITableViewCell.self)) { (row, element, cell) in
             cell.textLabel?.text = "\(element.movieNm) | \(element.openDt)"
         }
         .disposed(by: disposeBag)
     
     // 📌 UICollectionView
     recent
         .asDriver() // 🛞 Driver<[String]> -> bind 인식 못함
         // 🛞 .bind(to: ) -> .drive()
         .drive(collectionView.rx.items(cellIdentifier: MovieCollectionViewCell.identifier, cellType: MovieCollectionViewCell.self)) {
             (row, element, cell) in
             cell.label.text = "\(element)"
         }
         .disposed(by: disposeBag)
     
     // 📌 UISearchBar
     searchBar
         .rx
         .searchButtonClicked
         .throttle(.seconds(1), scheduler: MainScheduler.instance)
         .withLatestFrom(searchBar.rx.text.orEmpty, resultSelector: { _, query in
             guard query.count == 8, let _ = Int(query) else { return  "20231106" }
             return query // String을 반환 -> ControlProperty<String>.Element
         })
         .flatMap { query in
             BoxOfficeNetwork.fetchBoxOfficeData(date: query)
         } // query가 명확하기에 $0 사용 // 검색 이후 네트워크 처리
         .subscribe(with: self, onNext: { owner, movie in
             // Movie 구조체의 프로퍼티 접근 - 타입이 맞는 것을 가져 오기
             let data = movie.boxOfficeResult.dailyBoxOfficeList
             owner.items.onNext(data)
         })
         .disposed(by: disposeBag)
     
// 값 가져 오기 또는 인덱스 가져 오기
//       // 📌 tableView
//            .rx
//            .modelSelected(String.self) // -> 값 가져 오기 (타입 일치해야)
//            //.itemSelected // -> 인덱스 가져 오기
//            .subscribe(with: self) { owner, indexPath in
//                print(indexPath)
//            }
//            .disposed(by: disposeBag)

//      // 📌 Observable.zip
//      // 값과 인덱스 둘 다 가져 오기
//      // modelSelected의 데이터 맞추기
     Observable.zip(tableView.rx.modelSelected(DailyBoxOfficeList.self), tableView.rx.itemSelected)
         .map { $0.0.movieNm }
         // 튜플 - (ControlEvent<DailyBoxOfficeList>.Element, ControlEvent<IndexPath>.Element)
         // 0번 인덱스 - ControlEvent<DailyBoxOfficeList>.Element
         .subscribe(with: self) { owner, value in
             
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
             
             var data = owner.recent.value
             
             ///3. relay
             // 중복되지 않을 경우 컬렉션뷰에 추가
             if !owner.recent.value.contains(value) { data.append(value) }
             
             owner.recent.accept(data)
         }
         .disposed(by: disposeBag)
 */
