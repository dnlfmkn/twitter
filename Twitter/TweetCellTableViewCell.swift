//
//  TweetCellTableViewCell.swift
//  Twitter
//
//  Created by user160656 on 12/17/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class TweetCellTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var tweetContent: UILabel!
    @IBOutlet weak var favorite: UIButton!
    @IBOutlet weak var retweet: UIButton!
    
    var favorited: Bool = false
    var retweeted: Bool = false
    var tweetId: Int = -1
    
    @IBAction func onFavorite(_ sender: Any) {
        let toBeFavorited = !favorited
        if (toBeFavorited) {
            TwitterAPICaller.client?.favoriteTweet(tweetId: tweetId, success: {
                self.setFavorited(isFavorited: true)
            }, failure: { (Error) in
                print("Could not favorite tweet: \(Error)")
            })
        } else {
            TwitterAPICaller.client?.unfavoriteTweet(tweetId: tweetId, success: {
                self.setFavorited(isFavorited: false)
            }, failure: { (Error) in
                print("Could not unfavorite tweet: \(Error)")
            })
        }
    }
    
    @IBAction func onRetweet(_ sender: Any) {
        let toBeRetweeted = !retweeted
        if (toBeRetweeted) {
            TwitterAPICaller.client?.retweet(tweetId: tweetId, success: {
                self.setRetweeted(isRetweeted: true)
            }, failure: { (Error) in
                print("Could not retweet tweet: \(Error)")
            })
        } else {
            TwitterAPICaller.client?.unretweet(tweetId: tweetId, success: {
                self.setRetweeted(isRetweeted: false)
            }, failure: { (Error) in
                print("Could not unretweet tweet: \(Error)")
            })
        }
    }
    
    func setFavorited(isFavorited: Bool) {
        favorited = isFavorited
        if (favorited) {
            favorite.setImage(UIImage(named: "favor-icon"), for: UIControl.State.normal)
        } else {
            favorite.setImage(UIImage(named: "favor-icon-1"), for: UIControl.State.normal)
        }
    }
    
    func setRetweeted(isRetweeted: Bool) {
        retweeted = isRetweeted
        if (retweeted) {
            retweet.setImage(UIImage(named: "retweet-icon-green"), for: UIControl.State.normal)
        } else {
            retweet.setImage(UIImage(named: "retweet-icon"), for: UIControl.State.normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
