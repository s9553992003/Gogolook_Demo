//
//  FavoriteListViewController.swift
//  Gogolook_Demo
//
//  Created by Helios Chen on 2022/7/21.
//

import UIKit
import SafariServices

class FavoriteListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SFSafariViewControllerDelegate, ItemListTableViewCellDelegate {

    var favoriteListData = Array<listData>()
    private var tableviewListShow : UITableView!

    var dictionaryFavoriteURL : [String: Any] = [:]
    var dictionaryFavoriteTitle : [String: Any] = [:]
    var dictionaryFavoriteRank : [String: Any] = [:]
    var dictionaryFavoriteAiredFrom : [String: Any] = [:]
    var dictionaryFavoriteAiredTo : [String: Any] = [:]
    var dictionaryFavoriteImage_url : [String: Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupListShowTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUserData()
    }
    
    func setupListShowTable() {
        tableviewListShow = UITableView(frame: CGRect.zero, style: .plain)
        tableviewListShow.backgroundColor = .clear
        tableviewListShow.delegate = self
        tableviewListShow.dataSource = self
        tableviewListShow.separatorStyle = .none
        self.view.addSubview(tableviewListShow)
        tableviewListShow.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10 * AppDelegate.SCALE_VALUE)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
        let nibItemListCell = UINib(nibName: "ItemListTableViewCell", bundle: nil)
        tableviewListShow.register(nibItemListCell, forCellReuseIdentifier: "itemListCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let itemListCell = tableView.dequeueReusableCell(withIdentifier: "itemListCell", for: indexPath) as? ItemListTableViewCell {
            var isFavorite = false
            if dictionaryFavoriteTitle.keys.contains("\(favoriteListData[indexPath.row].mal_id)") {
                isFavorite = true
            }
            itemListCell.setupUI(data: favoriteListData[indexPath.row], favorite: isFavorite)
            itemListCell.delegate = self
            return itemListCell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = URL(string: favoriteListData[indexPath.row].url){
            let safari = SFSafariViewController(url: url)
            safari.delegate = self
            present(safari, animated: true, completion: nil)
        }
    }
    
    func getUserData() {
        favoriteListData.removeAll()
        if let userFavoriteURLDictionary = UserDefaults.standard.dictionary(forKey: "userFavoriteURLs") {
            dictionaryFavoriteURL = userFavoriteURLDictionary
        }
        if let userFavoriteTitleDictionary = UserDefaults.standard.dictionary(forKey: "userFavoriteTitles") {
            dictionaryFavoriteTitle = userFavoriteTitleDictionary
        }
        if let userFavoriteRankDictionary = UserDefaults.standard.dictionary(forKey: "userFavoriteRanks") {
            dictionaryFavoriteRank = userFavoriteRankDictionary
        }
        if let userFavoriteAiredFromDictionary = UserDefaults.standard.dictionary(forKey: "userFavoriteAiredFroms") {
            dictionaryFavoriteAiredFrom = userFavoriteAiredFromDictionary
        }
        if let userFavoriteAiredToDictionary = UserDefaults.standard.dictionary(forKey: "userFavoriteAiredTos") {
            dictionaryFavoriteAiredTo = userFavoriteAiredToDictionary
        }
        if let userFavoriteImageUrlDictionary = UserDefaults.standard.dictionary(forKey: "userFavoriteImageUrls") {
            dictionaryFavoriteImage_url = userFavoriteImageUrlDictionary
        }
        
        for (key, _) in dictionaryFavoriteTitle {
            let data = listData(malId: Int(key) ?? 0, urlString: dictionaryFavoriteTitle["\(key)"] as! String, titleString: dictionaryFavoriteTitle["\(key)"] as! String, rankInt: dictionaryFavoriteRank["\(key)"] as! Int, airedFromString: dictionaryFavoriteAiredFrom["\(key)"] as! String, airedToString: dictionaryFavoriteAiredTo["\(key)"] as! String, imageUrlString: dictionaryFavoriteImage_url["\(key)"] as! String)
            self.favoriteListData.append(data)
        }
        tableviewListShow.reloadData()
    }
    
    func setFavorite(isFavorite: Bool, data: listData) {
        if isFavorite {
            dictionaryFavoriteURL.updateValue(data.url, forKey: "\(data.mal_id)")
            dictionaryFavoriteTitle.updateValue(data.title, forKey: "\(data.mal_id)")
            dictionaryFavoriteRank.updateValue(data.rank, forKey: "\(data.mal_id)")
            dictionaryFavoriteAiredFrom.updateValue(data.airedFrom, forKey: "\(data.mal_id)")
            dictionaryFavoriteAiredTo.updateValue(data.airedTo, forKey: "\(data.mal_id)")
            dictionaryFavoriteImage_url.updateValue(data.image_url, forKey: "\(data.mal_id)")
        
            UserDefaults.standard.set(dictionaryFavoriteURL, forKey: "userFavoriteURLs")
            UserDefaults.standard.set(dictionaryFavoriteTitle, forKey: "userFavoriteTitles")
            UserDefaults.standard.set(dictionaryFavoriteRank, forKey: "userFavoriteRanks")
            UserDefaults.standard.set(dictionaryFavoriteAiredFrom, forKey: "userFavoriteAiredFroms")
            UserDefaults.standard.set(dictionaryFavoriteAiredTo, forKey: "userFavoriteAiredTos")
            UserDefaults.standard.set(dictionaryFavoriteImage_url, forKey: "userFavoriteImageUrls")
            UserDefaults.standard.synchronize()
        } else {
            dictionaryFavoriteURL.removeValue(forKey: "\(data.mal_id)")
            dictionaryFavoriteTitle.removeValue(forKey: "\(data.mal_id)")
            dictionaryFavoriteRank.removeValue(forKey: "\(data.mal_id)")
            dictionaryFavoriteAiredFrom.removeValue(forKey: "\(data.mal_id)")
            dictionaryFavoriteAiredTo.removeValue(forKey: "\(data.mal_id)")
            dictionaryFavoriteImage_url.removeValue(forKey: "\(data.mal_id)")

            UserDefaults.standard.set(dictionaryFavoriteURL, forKey: "userFavoriteURLs")
            UserDefaults.standard.set(dictionaryFavoriteTitle, forKey: "userFavoriteTitles")
            UserDefaults.standard.set(dictionaryFavoriteRank, forKey: "userFavoriteRanks")
            UserDefaults.standard.set(dictionaryFavoriteAiredFrom, forKey: "userFavoriteAiredFroms")
            UserDefaults.standard.set(dictionaryFavoriteAiredTo, forKey: "userFavoriteAiredTos")
            UserDefaults.standard.set(dictionaryFavoriteImage_url, forKey: "userFavoriteImageUrls")
            UserDefaults.standard.synchronize()
        }
    }
}
