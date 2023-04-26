//
//  PreviewVC.swift
//  FlynautAssessment
//
//  Created by iMac on 25/04/23.
//

import AVFoundation
import UIKit
import AVKit
import Kingfisher

protocol PreviewVCDelegate {
    func goNextPage(fowardTo : Int)
    func goPreviousPage(reverseTo : Int)
}

class PreviewVC: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var videoPlayerView: UIView!
    
    var userIndex : Int = 0
    var storyData: UserStory!
    var previewVCDelegate: PreviewVCDelegate?
    var storyProgressBar: StoryProgressBar!
    var videoPlayer: AVPlayer!
    var contentIndex: Int = 0
    var isLongPressed: Bool = false
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Lifecycle Actions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupStoryProgressBar()
        self.setupGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.storyProgressBar.startAnimation()
            self.playContent(index: 0)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        DispatchQueue.main.async {
            self.storyProgressBar.isPaused = true
            self.storyProgressBar.cancel()
            self.resetContent()
        }
    }
    
    // MARK: - IBActions
    @IBAction func didTapBackButton(_ sender: Any) {
        self.dismiss(animated: true)
    }

    // MARK: - Gesture Actions
    
    /// Swipe on story
    /// - Parameter sender: Gesture Recognizer
    @objc private func didSwipeOnContent(_ sender: UISwipeGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /// Long Press on story
    /// - Parameter sender: Longpress Recognizer
    @objc func didLongPressOnContent(_ sender: UITapGestureRecognizer) {
        self.isLongPressed = !self.isLongPressed
        self.storyProgressBar.isPaused = self.isLongPressed
        
        // Pause video
        if self.videoPlayer != nil {
            self.isLongPressed ? self.videoPlayer.pause() : self.videoPlayer.play()
        }
    }
    
    /// Tap on story
    /// - Parameter sender: Gesture Recognizer
    @objc func didTapOnContent(_ sender: UITapGestureRecognizer) {
        let point = sender.location(in: self.view)
        let leftArea = CGRect(x: 0, y: 0, width: view.bounds.width/2, height: view.bounds.height)
        if leftArea.contains(point) {
            //Your actions when you click on the left side of the screen
        
            if self.contentIndex == 0 && self.userIndex > 0{
                // Handle previous User
                self.storyProgressBar.isPaused = true
                self.previewVCDelegate?.goPreviousPage(reverseTo: userIndex - 1)
                return
            } else if self.contentIndex-1 >= 0 {
                // Handle previous story
                self.contentIndex = contentIndex-1
                self.storyProgressBar.rewind()
            } else {
                return
            }
        } else {
            //Your actions when you click on the Right side of the screen
            if self.contentIndex >= AppConstant.maxContentCount - 1 && self.userIndex < AppConstant.maxUserCount - 1 {
                // Handle next User
                self.storyProgressBar.isPaused = true
                self.previewVCDelegate?.goNextPage(fowardTo: userIndex + 1)
                return
            } else if (self.contentIndex+1) < self.storyData.content.count {

                // Handle next story
                self.contentIndex += 1
                self.storyProgressBar.skip()
            } else {
                self.dismiss(animated: true)
            }
        }
    }
    
    // MARK: - Custom Actions
    
    /// Setup view
    private func setupView() {
        self.navigationController?.isNavigationBarHidden = true
        self.imageView.isUserInteractionEnabled = true
        
        // Set User data
        self.profileImage.kf.setImage(with: URL(string: self.storyData.image)!)
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height / 2;
        self.username.text = self.storyData.name
    }
    
    /// Setup gesture for tap and swipe
    private func setupGesture() {
        
        // Image Tap Gesture to view next or prevoius story
        let tapGestureImage = UITapGestureRecognizer(target: self, action: #selector(didTapOnContent(_:)))
        self.imageView.addGestureRecognizer(tapGestureImage)
        
        // Video Tap Gesture to view next or prevoius story
        let tapGestureVideo = UITapGestureRecognizer(target: self, action: #selector(didTapOnContent(_:)))
        self.videoPlayerView.addGestureRecognizer(tapGestureVideo)
        
        // Image Swipe Gesture to dismiss storyview
        let swipeGestureRecognizerDownImage = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeOnContent(_:)))
        swipeGestureRecognizerDownImage.direction = .down
        self.imageView.addGestureRecognizer(swipeGestureRecognizerDownImage)
        
        // Video Swipe Gesture to dismiss storyview
        let swipeGestureRecognizerDownVideo = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeOnContent(_:)))
        swipeGestureRecognizerDownVideo.direction = .down
        self.videoPlayerView.addGestureRecognizer(swipeGestureRecognizerDownVideo)
        
        // Image Long Press Gesture to pause content
        let longGestureImage = UILongPressGestureRecognizer(target: self, action: #selector(didLongPressOnContent(_:)))
        self.imageView.addGestureRecognizer(longGestureImage)
        
        // Video Long Press Gesture to pause content
        let longGestureVideo = UILongPressGestureRecognizer(target: self, action: #selector(didLongPressOnContent(_:)))
        self.videoPlayerView.addGestureRecognizer(longGestureVideo)
    }
    
    
    /// Setup Story progress bar
    private func setupStoryProgressBar() {
        self.storyProgressBar = StoryProgressBar(numberOfSegments: self.storyData.content.count, duration: AppConstant.defaultContentTimeout)
        
        // Get a height of Status bar and set progess bar based on that
        if #available(iOS 11.0, *) {
            self.storyProgressBar.frame = CGRect(x: 8, y: (UIApplication.shared.statusBarFrame.height) + 5, width: view.frame.width - 35, height: 3)
        } else {
            // Fallback on earlier versions
            self.storyProgressBar.frame = CGRect(x: 18, y: 15, width: view.frame.width - 35, height: 3)
        }
        
        self.storyProgressBar.delegate = self
        self.storyProgressBar.isPaused = true
        self.storyProgressBar.duration = 5.0
        
        self.view.addSubview(storyProgressBar)
        self.view.bringSubviewToFront(storyProgressBar)
    }

    
    /// Play story content
    /// - Parameter index: index
    private func playContent(index: Int) {
        let contentAtIndex = self.storyData.content[index]
        switch (contentAtIndex.type) {
        case .image:
            self.storyProgressBar.duration = AppConstant.defaultContentTimeout
            self.imageView.isHidden = false
            self.videoPlayerView.isHidden = true
            self.imageView.kf.setImage(with: URL(string: contentAtIndex.path)!)
        case .video:
            self.imageView.isHidden = true
            self.videoPlayerView.isHidden = false
            
            let file = contentAtIndex.path.components(separatedBy: ".")
            
            guard let path = Bundle.main.path(forResource: file[0], ofType: file[1]) else {
                    debugPrint( "File not found")
                    return
                }
            self.storyProgressBar.duration = CMTimeGetSeconds(AVAsset(url: URL(fileURLWithPath: path)).duration)
            
            self.videoPlayer = AVPlayer(url: URL(fileURLWithPath: path))
            let videoLayer = AVPlayerLayer(player: self.videoPlayer)
            videoLayer.frame = view.bounds
            videoLayer.videoGravity = .resizeAspect
            self.videoPlayerView.layer.addSublayer(videoLayer)
            self.videoPlayer.play()
        }
    }
    
    
    /// Reset story content 
    private func resetContent() {
        if self.videoPlayer != nil {
            self.videoPlayer.pause()
            self.videoPlayer.replaceCurrentItem(with: nil)
            self.videoPlayer = nil
        }
        self.imageView.image = nil
    }

}

// MARK: - StoryProgressBarDelegate Actions
extension PreviewVC: StoryProgressBarDelegate {
    func storyProgressBarChangedIndex(index: Int) {
        self.resetContent()
        self.playContent(index: index)
    }
    
    func storyProgressBarFinished() {
        if self.userIndex == AppConstant.maxUserCount - 1, self.storyData.content.count == AppConstant.maxContentCount {
            dismiss(animated: true)
        }
        else {
            self.previewVCDelegate?.goNextPage(fowardTo: userIndex + 1)
        }
    }

}
