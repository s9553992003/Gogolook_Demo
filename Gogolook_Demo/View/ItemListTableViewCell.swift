//
//  ItemListTableViewCell.swift
//  Gogolook_Demo
//
//  Created by Helios Chen on 2022/7/19.
//

import UIKit

protocol ItemListTableViewCellDelegate: AnyObject {
    func setFavorite(isFavorite: Bool, data: listData)
}

class ItemListTableViewCell: UITableViewCell {

    weak var delegate: ItemListTableViewCellDelegate?

    @IBOutlet weak var imageviewAnime: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelRank: UILabel!
    @IBOutlet weak var labelStartDate: UILabel!
    @IBOutlet weak var labelEndDate: UILabel!
    @IBOutlet weak var buttonFavorite: UIButton!
    var itemListData: listData = listData()
    var isFavorite: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupUI(data: listData, favorite: Bool) {
        itemListData = data
        self.isFavorite = favorite
        labelTitle.text = data.title
        labelRank.text = "Rank: " + "\(data.rank)"
        labelStartDate.text = "Start:" + TimeTools.instance.utcToLocalDate(dateStr: data.airedFrom)
        labelEndDate.text = "End:" + TimeTools.instance.utcToLocalDate(dateStr: data.airedTo)
        if let url = URL(string: data.image_url) {
            let placeholderImage = UIImage(named: "imageParkingPhotoPic")
            imageviewAnime.kf.setImage(with: url, placeholder: placeholderImage)
        }
        if favorite {
            buttonFavorite.setImage(UIImage(named: "btnFavoriteOnDark"), for: .normal)
        } else {
            buttonFavorite.setImage(UIImage(named: "btnFavoriteOnLight"), for: .normal)
        }
    }
    
    @IBAction func setFavorite(_ sender: Any) {
        isFavorite = !isFavorite
        if isFavorite {
            buttonFavorite.setImage(UIImage(named: "btnFavoriteOnDark"), for: .normal)
        } else {
            buttonFavorite.setImage(UIImage(named: "btnFavoriteOnLight"), for: .normal)
        }
        self.delegate?.setFavorite(isFavorite: isFavorite, data: itemListData)
    }
}
