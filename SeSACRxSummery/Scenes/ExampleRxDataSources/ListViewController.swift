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

final class ListViewController: UIViewController {
    
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    private func configure() {
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
