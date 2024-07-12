//
//  TabBarController.swift
//  WeatherApp
//
//  Created by 박다현 on 7/12/24.
//

import UIKit

final class TabBarController:UITabBarController{
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            //tabBar.tintColor = AppColor.primary
            tabBar.unselectedItemTintColor = .gray
            
            let appearance = UINavigationBarAppearance()
            //appearance.backgroundColor = AppColor.white
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            
            let weather = WeatherViewController()
            //let nav1 = UINavigationController(rootViewController: main)
            weather.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "IconName.search"), tag: 0)
            
            let map = MapViewController()
            //let nav2 = UINavigationController(rootViewController: map)
            map.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "map"), tag: 1)
            
            let search = CitySearchViewController()
            let nav = UINavigationController(rootViewController: search)
            nav.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "list.bullet"), tag: 2)


            setViewControllers([weather, map, nav], animated: true)
            
        }
    }
