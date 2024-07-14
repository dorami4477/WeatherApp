//
//  WeatherInfoCVCell.swift
//  WeatherApp
//
//  Created by 박다현 on 7/13/24.
//

import UIKit

final class WeatherInfoCVCell: UICollectionViewCell {
    private let titleLabel = UILabel()
    private let resultLabel = UILabel()
    private let detailLebel = UILabel()
    
    var data:AdditionalWeatherInfo?{
        didSet{
            guard let data else { return }
            titleLabel.text = data.title
            resultLabel.text = data.Info
            detailLebel.text = data.detail
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func configureHierarchy(){
        contentView.addSubview(titleLabel)
        contentView.addSubview(resultLabel)
        contentView.addSubview(detailLebel)
    }
    private func configureLayout(){
        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(10)
        }
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
        detailLebel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
        }
    }
    private func configureUI(){
        titleLabel.textColor = .gray
        resultLabel.font = .systemFont(ofSize: 30)
        contentView.backgroundColor = .gray.withAlphaComponent(0.2)
        contentView.layer.cornerRadius = 15
        contentView.clipsToBounds = true
    }
}
