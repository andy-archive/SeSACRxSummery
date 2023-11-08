//
//  ListViewController.swift
//  SeSACRxSummery
//
//  Created by Taekwon Lee on 2023/11/08.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

final class ListViewController: UIViewController {
    
    private let tableView = UITableView()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        bind()
        setMentor()
    }
    
    private func configure() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func bind() {
        let mentors = [
            Mentor(name: "Jack", items: [
                Ment(word: "맛점하셧나여", count: 11),
                Ment(word: "돌아오세여", count: 11),
                Ment(word: "살아계신가여", count: 11)
            ]),
            Mentor(name: "Hue", items: [
                Ment(word: "맛점하셧나여", count: 11),
                Ment(word: "돌아오세여", count: 11),
                Ment(word: "살아계신가여", count: 11)
            ]),
            Mentor(name: "Bran", items: [
                Ment(word: "맛점하셧나여", count: 11),
                Ment(word: "돌아오세여", count: 11),
                Ment(word: "살아계신가여", count: 11)
            ]),
            Mentor(name: "Koko", items: [
                Ment(word: "맛점하셧나여", count: 11),
                Ment(word: "돌아오세여", count: 11),
                Ment(word: "살아계신가여", count: 11)
            ])
        ]
        
        let dataSource = RxTableViewSectionedReloadDataSource<Mentor>(
          configureCell: { dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
              cell.textLabel?.text = "Item \(item.word) @ \(item.count)"
            return cell
        })
        
        dataSource.titleForHeaderInSection = { dataSource, index in
          return dataSource.sectionModels[index].name
        }
        
        Observable.just(mentors)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func setMentor() {
    }
}

//MARK: Model - Mentor & Ment

struct Mentor: SectionModelType {
    typealias Item = Ment
    
    var name: String
    var items: [Item]
}

struct Ment {
    var word: String
    var count: Int
}

extension Mentor {
    init(original: Mentor, items: [Ment]) {
        self = original
        self.items = items
    }
}
