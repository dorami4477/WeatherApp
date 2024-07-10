//
//  WeatherTableViewCell.swift
//  WeatherApp
//
//  Created by 박다현 on 7/10/24.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: CVlayout())

    private func CVlayout() -> UICollectionViewLayout{
        let layout = UICollectionViewFlowLayout()
        let width = ( UIScreen.main.bounds.width - 80 ) / 5
        layout.itemSize = CGSize(width: width, height: width * 2)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        return layout
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
