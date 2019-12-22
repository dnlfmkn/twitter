//
//  HomeViewController.swift
//  Twitter
//
//  Created by user160656 on 12/17/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    var preferences = UserDefaults.standard
    var tweets = [NSDictionary]()
    var tweetCount: Int!
    let _refreshControl = UIRefreshControl()
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        preferences.set(false, forKey: "logged_in")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _refreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = _refreshControl
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadTweets()
    }
    
    @objc func loadTweets() {
        tweetCount = 20
       let tweetsEndpoint = "https://api.twitter.com/1.1/statuses/home_timeline.json"
       let params = ["count" : tweetCount]
        TwitterAPICaller.client?.getDictionariesRequest(url: tweetsEndpoint, parameters: params as [String : Any], success: { (tweets: [NSDictionary]) in
            self.tweets.removeAll()
           for tweet in tweets {
               self.tweets.append(tweet)
           }
        self.tableView.reloadData()
        self._refreshControl.endRefreshing()
       }, failure: { (error) in
            print("Could not fetch tweets")
       })
    }
    
    func loadMoreTweets() {
        let tweetsEndpoint = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        tweetCount += 10
        let params = ["count": tweetCount]
        TwitterAPICaller.client?.getDictionariesRequest(url: tweetsEndpoint, parameters: params as [String : Any], success: { (tweets: [NSDictionary]) in
            self.tweets.removeAll()
            for tweet in tweets {
                   self.tweets.append(tweet)
               }
            self.tableView.reloadData()
        }, failure: { (error) in
            print("Could not fetch more tweets")
        })
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCellTableViewCell
        let tweet = tweets[indexPath.row]
        let user = tweet["user"] as! NSDictionary
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        
        cell.tweetId = tweet["id"] as! Int
        cell.tweetContent.text = tweet["text"] as? String
        cell.screenName.text = user["screen_name"] as? String
        
        let data = try? Data(contentsOf: imageUrl!)
        if let imageData = data {
            cell.profileImage.image = UIImage(data: imageData)
        }
        cell.setFavorited(isFavorited: tweet["favorited"] as! Bool)
        cell.setRetweeted(isRetweeted: tweet["retweeted"] as! Bool)
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == self.tweets.count {
            loadMoreTweets()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
