//
//  WeatherTableViewCell.swift
//  WeatherApp
//
//  Created by 박다현 on 7/10/24.
//

import UIKit

final class HourWeatherTVCell: BaseTableViewCell {

    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: CVlayout())

    private func CVlayout() -> UICollectionViewLayout{
        let layout = UICollectionViewFlowLayout()
        let width = ( UIScreen.main.bounds.width - 50 ) / 5
        layout.itemSize = CGSize(width: width, height: width * 2)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        return layout
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        collectionView.backgroundColor = .clear
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
}
