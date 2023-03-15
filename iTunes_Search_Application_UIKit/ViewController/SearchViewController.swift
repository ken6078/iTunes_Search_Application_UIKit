//
//  SearchViewController.swift
//  iTunes_Search_Application_UIKit
//
//  Created by Jacky Ben on 2023/3/14.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    private let searchController: UISearchController = {
        let controller = UISearchController()
        controller.searchBar.placeholder = "輸入你想搜尋的項目"
        return controller
    }()
    
    private static var segmentedControl: UISegmentedControl = {
        let style = ["歌曲","專輯","歌手"]
        var picker = UISegmentedControl(items: style)
        picker.selectedSegmentIndex = 0
//        picker.backgroundColor = .lightGray
        return picker
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        title = "搜尋"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        let stylePicker = SearchViewController.segmentedControl
        view.addSubview(stylePicker)
        stylePicker.translatesAutoresizingMaskIntoConstraints = false
        stylePicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        stylePicker.bottomAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: view.safeAreaLayoutGuide.bottomAnchor, multiplier: 30).isActive = true
        stylePicker.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        stylePicker.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        
        
        
        let searchView = UITableView()
//        searchView.backgroundColor = .yellow
        searchView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        searchView.delegate = self
        searchView.dataSource = self
        view.addSubview(searchView)
        searchView.translatesAutoresizingMaskIntoConstraints = false
        searchView.topAnchor.constraint(equalTo: view.forLastBaselineLayout.bottomAnchor).isActive = true
        searchView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        searchView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        searchView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true

        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Tet"
            return cell
        }
}
