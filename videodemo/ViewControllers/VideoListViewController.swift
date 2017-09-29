//
//  VideoListViewController.swift
//  videodemo
//
//  Created by Mallabelly, Manikanta on 9/28/17.
//  Copyright © 2017 Mallabelly, Manikanta. All rights reserved.
//

import GoogleAPIClientForREST
import GoogleSignIn
import UIKit
import QuartzCore

class VideoListViewController: UIViewController {
    
    private let service = GTLRYouTubeService() // GoogleYoutube service class
    private var videos = Array<Video>() // Collection to hold videos
    @IBOutlet weak var collectionView: UICollectionView! // Collection view to hold the video cells
    @IBOutlet weak var searchBarContainer: UIView! // Search bar to search for the video
    var searchController: UISearchController? //Container to hold search bar

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constants.videoSearchScreenTitle
        
        // Hide the back button
        self.navigationItem.hidesBackButton = true
        //Setup the search controller
        searchController = ({
            let searchController = UISearchController(searchResultsController: nil)
            searchController.searchResultsUpdater = self
            searchController.hidesNavigationBarDuringPresentation = false
            
            //setup the search bar
            searchController.searchBar.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
            self.searchBarContainer?.addSubview(searchController.searchBar)
            searchController.searchBar.sizeToFit()
            
            return searchController
        })()
    }
    
    //Set the authorized user
    func setUser(user: GIDGoogleUser) {
        service.authorizer = user.authentication.fetcherAuthorizer()
    }
    
    // get the search text entered
    func getSearchQuery() -> String?
    {
        if let searchTerm = self.searchController?.searchBar.text {
            return (searchTerm.isEmpty) ? nil : searchTerm
        }
        return nil
    }
    
    // fetch up to 10 results based on search term
    func fetchChannelResource() {
        
        // fetch not needed for empty search
        guard let searchTerm = getSearchQuery() else {
            return
        }
        // construct searchlist query
        let query = GTLRYouTubeQuery_SearchList.query(withPart: "snippet")
        query.maxResults = Constants.videoSearchMaxResults
        query.q = searchTerm
        query.type = ""
        service.executeQuery(query,
                             delegate: self,
                             didFinish: #selector(displayResultWithTicket(ticket:finishedWithObject:error:)))
    }
    
    //Process the response and display output
    @objc func displayResultWithTicket(
        ticket: GTLRServiceTicket,
        finishedWithObject response : GTLRYouTube_SearchListResponse,
        error : NSError?) {
        
        if let error = error {
            showAlert(title: "Error", message: error.localizedDescription)
            return
        }
        
        if let channels = response.items, !channels.isEmpty {
            var filteredVideos = Array<Video>()
            for item in channels {
                if let identifier = item.identifier?.videoId,
                   let title = item.snippet?.title,
                   let thumbnailURL = item.snippet?.thumbnails?.medium?.url {
                
                    let video = Video(identifier: identifier, title: title, description: "description", thumbnailURL: thumbnailURL)
                    filteredVideos.append(video)
                }
            }
            videos = filteredVideos
        }
        collectionView?.reloadData()
    }
}

extension VideoListViewController: UISearchControllerDelegate, UISearchResultsUpdating {
    
    public func updateSearchResults(for searchController: UISearchController)
    {
        fetchChannelResource()
    }
}

extension VideoListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        //create a dummy UICollectionViewCell so the compiler doesn't complain
        var cell = UICollectionViewCell()
        
        // Get the video cell
        if let videoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCollectionCell", for: indexPath) as? VideoCollectionCell {
            let videoItem = videos[indexPath.row]
            // configure cell with data
            videoCell.configureWith(video: videoItem)
            cell = videoCell
        }
        
        return cell
    }
    
    //MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let video = videos[indexPath.row]
        
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let videoPlayerViewController = storyBoard.instantiateViewController(withIdentifier: "VideoPlayerViewController") as? VideoPlayerViewController {
            videoPlayerViewController.videoId = video.identifier
            self.navigationController?.pushViewController(videoPlayerViewController, animated: true)
        }
    }
    
    //MARK: UICollectionViewFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        // Size after adjusting insets
        return CGSize(width: collectionView.frame.width - Constants.videoCollectionViewInset, height: Constants.videoCellHeight)
    }
    
    //MARK: UIScrollViewDelegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    {
        //dismiss the keyboard if the search results are scrolled
        searchController?.searchBar.resignFirstResponder()
    }
}

