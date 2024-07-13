//
//  WeatherInfoTVCell.swift
//  WeatherApp
//
//  Created by 박다현 on 7/13/24.
//

import UIKit

class WeatherInfoTVCell: BaseTableViewCell {

    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: CVlayout())

    private func CVlayout() -> UICollectionViewLayout{
        let layout = UICollectionViewFlowLayout()
        let width = ( UIScreen.main.bounds.width - 50 ) / 2
        layout.itemSize = CGSize(width: width, height: width)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        return layout
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
