//
//  MovieCollectionViewCell.swift
//  SeSACRxSummery
//
//  Created by jack on 2023/11/07.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    static let identifier = NSStringFromClass(MovieCollectionViewCell.self)
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.label.cgColor
        
        contentView.backgroundColor = .systemGroupedBackground
        
        label.textAlignment = .center
        
        contentView.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
