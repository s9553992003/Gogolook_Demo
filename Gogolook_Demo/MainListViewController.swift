//
//  MainListViewController.swift
//  Gogolook_Demo
//
//  Created by Helios Chen on 2022/7/18.
//

import UIKit
import ESPullToRefresh
import SafariServices

enum MainListPageType: Int {
    case topAnime = 0
    case topManga
}

class MainListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SFSafariViewControllerDelegate, ItemListTableViewCellDelegate {

    private var segmentedControlSelect : UISegmentedControl!
    private var viewSegmentedControlAnime : UIView!
    private var viewSegmentedControlManga : UIView!
    private var segmentedControlTypeAnime : UISegmentedControl!
    private var segmentedControlFilterAnime : UISegmentedControl!
    private var segmentedControlTypeManga : UISegmentedControl!
    private var segmentedControlFilterManga : UISegmentedControl!
    private var tableviewListShow : UITableView!
    var arrayAnimeData = Array<listData>()
    var arrayMangaData = Array<listData>()
    var arrayAnimeType = ["tv", "movie", "ova", "special", "ona", "music"]
    var arrayAnimeFilter = ["airing", "upcoming", "bypopularity", "favorite"]
    var arrayMangaType = ["manga", "novel", "lightnovel", "oneshot", "doujin", "manhwa", "manhua"]
    var arrayMangaFilter = ["publishing", "upcoming", "bypopularity", "favorite"]

    var selectAnimeType = ""
    var selectAnimeFilter = ""
    var selectMangaType = ""
    var selectMangaFilter = ""

    private var pageType: MainListPageType = .topAnime
    var latestPageForTopAnime = 1
    var latestPageForTopManga = 1
    var noTopAnimeData = false
    var noTopMangaData = false
    var topAnimePageInitial = true
    var topMangaPageInitial = true
    
    var returnData: listReturnData = listReturnData()

    var dictionaryFavoriteURL : [String: Any] = [:]
    var dictionaryFavoriteTitle : [String: Any] = [:]
    var dictionaryFavoriteRank : [String: Any] = [:]
    var dictionaryFavoriteAiredFrom : [String: Any] = [:]
    var dictionaryFavoriteAiredTo : [String: Any] = [:]
    var dictionaryFavoriteImage_url : [String: Any] = [:]

    var footer: ESRefreshFooterAnimator {
        get {
            let f = ESRefreshFooterAnimator.init(frame: CGRect.zero)
            f.loadingMoreDescription = ""
            f.noMoreDataDescription = ""
            f.loadingDescription = ""
            return f
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupUI()
        setupListShowTable()
        getUserData()
        getData()
    }
    
    func setupUI() {
        segmentedControlSelect = UISegmentedControl(items: ["Top Anime", "Top Manga"])
        segmentedControlSelect.selectedSegmentTintColor = UIColor(hexString: "#39FFED")
        segmentedControlSelect.backgroundColor = UIColor(hexString: "#DDDDDD")
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        segmentedControlSelect.setTitleTextAttributes(titleTextAttributes, for:.normal)
        segmentedControlSelect.addTarget(self, action: #selector(segmenteSelectChange), for: .valueChanged)
        segmentedControlSelect.selectedSegmentIndex = 0
        segmentedControlSelect.accessibilityIdentifier = "segmentedControlSelect"
        self.view.addSubview(segmentedControlSelect)
        segmentedControlSelect.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 208 * AppDelegate.SCALE_VALUE, height: 48 * AppDelegate.SCALE_VALUE))
        }
        
        viewSegmentedControlAnime = UIView(frame: .zero)
        self.view.addSubview(viewSegmentedControlAnime)
        viewSegmentedControlAnime.snp.makeConstraints { (make) in
            make.top.equalTo(segmentedControlSelect.snp.bottom).offset(20 * AppDelegate.SCALE_VALUE)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 375 * AppDelegate.SCALE_VALUE, height: 100 * AppDelegate.SCALE_VALUE))
        }
        
        segmentedControlTypeAnime = UISegmentedControl(items: arrayAnimeType)
        segmentedControlTypeAnime.selectedSegmentTintColor = UIColor(hexString: "#39FFED")
        segmentedControlTypeAnime.backgroundColor = UIColor(hexString: "#DDDDDD")
        segmentedControlTypeAnime.setTitleTextAttributes(titleTextAttributes, for:.normal)
        segmentedControlTypeAnime.addTarget(self, action: #selector(segmenteTypeAnimeSelectChange), for: .valueChanged)
        viewSegmentedControlAnime.addSubview(segmentedControlTypeAnime)
        segmentedControlTypeAnime.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20 * AppDelegate.SCALE_VALUE)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 325 * AppDelegate.SCALE_VALUE, height: 28 * AppDelegate.SCALE_VALUE))
        }
        
        segmentedControlFilterAnime = UISegmentedControl(items: arrayAnimeFilter)
        segmentedControlFilterAnime.selectedSegmentTintColor = UIColor(hexString: "#39FFED")
        segmentedControlFilterAnime.backgroundColor = UIColor(hexString: "#DDDDDD")
        segmentedControlFilterAnime.setTitleTextAttributes(titleTextAttributes, for:.normal)
        segmentedControlFilterAnime.addTarget(self, action: #selector(segmenteFilterAnimeSelectChange), for: .valueChanged)
        viewSegmentedControlAnime.addSubview(segmentedControlFilterAnime)
        segmentedControlFilterAnime.snp.makeConstraints { (make) in
            make.top.equalTo(segmentedControlTypeAnime.snp.bottom).offset(20 * AppDelegate.SCALE_VALUE)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 325 * AppDelegate.SCALE_VALUE, height: 28 * AppDelegate.SCALE_VALUE))
        }
        
        viewSegmentedControlManga = UIView(frame: .zero)
        viewSegmentedControlManga.isHidden = true
        self.view.addSubview(viewSegmentedControlManga)
        viewSegmentedControlManga.snp.makeConstraints { (make) in
            make.top.equalTo(segmentedControlSelect.snp.bottom).offset(20 * AppDelegate.SCALE_VALUE)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 375 * AppDelegate.SCALE_VALUE, height: 100 * AppDelegate.SCALE_VALUE))
        }
        
        segmentedControlTypeManga = UISegmentedControl(items: arrayMangaType)
        segmentedControlTypeManga.selectedSegmentTintColor = UIColor(hexString: "#39FFED")
        segmentedControlTypeManga.backgroundColor = UIColor(hexString: "#DDDDDD")
        segmentedControlTypeManga.setTitleTextAttributes(titleTextAttributes, for:.normal)
        segmentedControlTypeManga.addTarget(self, action: #selector(segmenteTypeMangaSelectChange), for: .valueChanged)
        viewSegmentedControlManga.addSubview(segmentedControlTypeManga)
        segmentedControlTypeManga.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20 * AppDelegate.SCALE_VALUE)
            make.left.right.equalToSuperview()
            make.size.height.equalTo(28 * AppDelegate.SCALE_VALUE)
        }
        
        segmentedControlFilterManga = UISegmentedControl(items: arrayMangaFilter)
        segmentedControlFilterManga.selectedSegmentTintColor = UIColor(hexString: "#39FFED")
        segmentedControlFilterManga.backgroundColor = UIColor(hexString: "#DDDDDD")
        segmentedControlFilterManga.setTitleTextAttributes(titleTextAttributes, for:.normal)
        segmentedControlFilterManga.addTarget(self, action: #selector(segmenteFilterMangaSelectChange), for: .valueChanged)
        viewSegmentedControlManga.addSubview(segmentedControlFilterManga)
        segmentedControlFilterManga.snp.makeConstraints { (make) in
            make.top.equalTo(segmentedControlTypeManga.snp.bottom).offset(20 * AppDelegate.SCALE_VALUE)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 325 * AppDelegate.SCALE_VALUE, height: 28 * AppDelegate.SCALE_VALUE))
        }
    }
    
    func setupListShowTable() {
        tableviewListShow = UITableView(frame: CGRect.zero, style: .plain)
        tableviewListShow.backgroundColor = .clear
        tableviewListShow.delegate = self
        tableviewListShow.dataSource = self
        tableviewListShow.separatorStyle = .none
        self.view.addSubview(tableviewListShow)
        tableviewListShow.snp.makeConstraints { (make) in
            make.top.equalTo(self.viewSegmentedControlAnime.snp.bottom).offset(10 * AppDelegate.SCALE_VALUE)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
        let nibItemListCell = UINib(nibName: "ItemListTableViewCell", bundle: nil)
        tableviewListShow.register(nibItemListCell, forCellReuseIdentifier: "itemListCell")
        self.tableviewListShow.es.addInfiniteScrolling(animator: footer) {
            [unowned self] in
            if pageType == .topAnime {
                if self.noTopAnimeData == false {
                    self.latestPageForTopAnime += 1
                    self.getTopAnimeData(type: selectAnimeType, filter: selectAnimeFilter, page: self.latestPageForTopAnime, handler: { () in
                        self.tableviewListShow.es.stopLoadingMore()
                    })
                } else {
                    self.tableviewListShow.es.stopLoadingMore()
                    print("已經沒有最新資料了")
                }
            } else {
                if self.noTopMangaData == false {
                    self.latestPageForTopManga += 1
                    self.getTopMangaData(type: selectMangaType, filter: selectMangaFilter, page: self.latestPageForTopManga, handler: { () in
                        self.tableviewListShow.es.stopLoadingMore()
                    })
                } else {
                    self.tableviewListShow.es.stopLoadingMore()
                    print("已經沒有最新資料了")
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if pageType == .topAnime {
            return arrayAnimeData.count
        } else {
            return arrayMangaData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let itemListCell = tableView.dequeueReusableCell(withIdentifier: "itemListCell", for: indexPath) as? ItemListTableViewCell {
            var isFavorite = false
            if pageType == .topAnime {
                if dictionaryFavoriteTitle.keys.contains("\(arrayAnimeData[indexPath.row].mal_id)") {
                    isFavorite = true
                }
                itemListCell.setupUI(data: arrayAnimeData[indexPath.row], favorite: isFavorite)
            } else {
                if dictionaryFavoriteTitle.keys.contains("\(arrayMangaData[indexPath.row].mal_id)") {
                    isFavorite = true
                }
                itemListCell.setupUI(data: arrayMangaData[indexPath.row], favorite: isFavorite)
            }
            itemListCell.delegate = self
            return itemListCell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if pageType == .topAnime {
            if let url = URL(string: arrayAnimeData[indexPath.row].url){
                let safari = SFSafariViewController(url: url)
                safari.delegate = self
                present(safari, animated: true, completion: nil)
            }
        } else {
            if let url = URL(string: arrayMangaData[indexPath.row].url){
                let safari = SFSafariViewController(url: url)
                safari.delegate = self
                present(safari, animated: true, completion: nil)
            }
        }
    }
    
    @objc func segmenteSelectChange(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            viewSegmentedControlAnime.isHidden = false
            viewSegmentedControlManga.isHidden = true
            pageType = .topAnime
        } else {
            viewSegmentedControlAnime.isHidden = true
            viewSegmentedControlManga.isHidden = false
            pageType = .topManga
        }
        getData()
        tableviewListShow.reloadData()
    }
    
    @objc func segmenteTypeAnimeSelectChange(sender: UISegmentedControl) {
        selectAnimeType = arrayAnimeType[sender.selectedSegmentIndex]
        getData()
    }
    
    @objc func segmenteFilterAnimeSelectChange(sender: UISegmentedControl) {
        selectAnimeFilter = arrayAnimeFilter[sender.selectedSegmentIndex]
        getData()
    }
    
    @objc func segmenteTypeMangaSelectChange(sender: UISegmentedControl) {
        selectMangaType = arrayMangaType[sender.selectedSegmentIndex]
        getData()
    }
    
    @objc func segmenteFilterMangaSelectChange(sender: UISegmentedControl) {
        selectMangaFilter = arrayMangaFilter[sender.selectedSegmentIndex]
        getData()
    }
    
    func getTopAnimeData(type: String, filter: String, page: Int, handler: (() -> Void)?) {
        DemoAPI.share.getTopAnime(type: type, filter: filter, page: page, limit: 10)
        .done { (data) in
            self.returnData = data
            if self.latestPageForTopAnime == data.pagination.last_visible_page {
                self.noTopAnimeData = true
            } else {
                self.noTopAnimeData = false
            }
            var _arrayResult: [listData] = []
            _arrayResult = data.listArray
            
            if page == 1 {
                self.arrayAnimeData.removeAll()
                self.arrayAnimeData = _arrayResult
            } else {
                self.arrayAnimeData += _arrayResult
            }
        }
        .ensure {
            self.topAnimePageInitial = false
            self.tableviewListShow.es.stopLoadingMore()
            self.tableviewListShow.reloadDataSmoothly()
            handler?()
        }
        .catch { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getTopMangaData(type: String, filter: String, page: Int, handler: (() -> Void)?) {
        DemoAPI.share.getTopManga(type: type, filter: filter, page: page, limit: 10)
        .done { (data) in
            self.returnData = data
            if self.latestPageForTopManga == data.pagination.last_visible_page {
                self.noTopMangaData = true
            } else {
                self.noTopMangaData = false
            }
            var _arrayResult: [listData] = []
            _arrayResult = data.listArray
            
            if page == 1 {
                self.arrayMangaData.removeAll()
                self.arrayMangaData = _arrayResult
            } else {
                self.arrayMangaData += _arrayResult
            }
        }
        .ensure {
            self.topAnimePageInitial = false
            self.tableviewListShow.es.stopLoadingMore()
            self.tableviewListShow.reloadDataSmoothly()
            handler?()
        }
        .catch { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getData() {
        if pageType == .topAnime {
            latestPageForTopAnime = 1
            self.getTopAnimeData(type: selectAnimeType, filter: selectAnimeFilter, page: self.latestPageForTopAnime, handler: { () in
                self.tableviewListShow.es.stopLoadingMore()
            })
            arrayMangaData.removeAll()
        } else {
            latestPageForTopManga = 1
            self.getTopMangaData(type: selectMangaType, filter: selectMangaFilter, page: self.latestPageForTopManga, handler: { () in
                self.tableviewListShow.es.stopLoadingMore()
            })
            arrayAnimeData.removeAll()
        }
    }
    
    func getUserData() {
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
    
    func getTopAnimeData() -> Int? {
        return arrayAnimeData.count
    }
    
    func getTopMangaData() -> Int? {
        return arrayMangaData.count
    }
}
