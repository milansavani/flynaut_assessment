//
//  StoryVC.swift
//  FlynautAssessment
//
//  Created by iMac on 25/04/23.
//

import UIKit
var StoryPage = StoryVC()

class StoryVC: UIViewController {
    
    var pageVC : UIPageViewController?
    
    /// Setup User Stories
    var userStories: [UserStory] = [
        UserStory(name: "Milan", image: "https://www.gravatar.com/avatar/2c7d99fe281ecd3bcd65ab915bac6dd5?s=240", content: UserStoryData().contentGenerator()),
        UserStory(name: "Jachin", image: "https://i.pravatar.cc/240?u=mail@ashallendesign.co.uk", content: UserStoryData().contentGenerator()),
        UserStory(name: "Flynaut", image: "https://eu.ui-avatars.com/api/?name=Fly+Naut&size=240", content: UserStoryData().contentGenerator()),
    ]
    
    // MARK: - Lifecycle Actions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpInitialVC()
    }
    
    // MARK: - Custom Actions
    
    /// Setup Initial View controller
    private func setUpInitialVC() {
        let initialVC: PreviewVC = self.VCAtIndex(index: 0)!
        self.pageVC = storyboard?.instantiateViewController(withIdentifier: VCIdentifier.PageVC) as? UIPageViewController
        self.pageVC!.dataSource = self
        self.pageVC!.delegate = self
        self.pageVC!.setViewControllers([initialVC] , direction: .forward, animated: false, completion: nil)
        self.pageVC!.view.frame = view.bounds
        
        // Add ChildVC
        addChild(self.pageVC!)
        view.addSubview(self.pageVC!.view)
        view.sendSubviewToBack(self.pageVC!.view)
        self.pageVC!.didMove(toParent: self)
    }
    
    /// Navigate to next user
    /// - Parameters:
    ///   - position: This valye define the index of view controller
    ///   - isForward: This value define the direction of view controller
    private func goToPage(to position: Int, isForward: Bool) {
        let nextVC: PreviewVC = self.VCAtIndex(index: position)!
        self.pageVC!.setViewControllers([nextVC] , direction: isForward ? .forward : .reverse, animated: true, completion: nil)
    }
    
    /// Setup a view controller to display stories of single user
    /// - Parameter index: This valye define the index of view controller
    /// - Returns: Story view controller
    private func VCAtIndex(index: Int) -> PreviewVC? {
        if index >= AppConstant.maxUserCount {
            return nil
        }
    
        // Setup a Preview VC for user story
        let previewVC = storyboard?.instantiateViewController(withIdentifier: VCIdentifier.PreviewVC) as! PreviewVC
        previewVC.userIndex = index
        previewVC.storyData = userStories[index]
        previewVC.previewVCDelegate = self
        return previewVC
    }
}

// MARK: - UIPageViewControllerDelegate Actions
extension StoryVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentPageIndex = (viewController as! PreviewVC).userIndex
        if (currentPageIndex == NSNotFound) || (currentPageIndex + 1 == AppConstant.maxUserCount) {
            return nil
        }
        return self.VCAtIndex(index: currentPageIndex + 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentPageIndex = (viewController as! PreviewVC).userIndex
        if (currentPageIndex == NSNotFound) || (currentPageIndex == 0) {
            return nil
        }
        return self.VCAtIndex(index: currentPageIndex - 1)
    }
}

// MARK: - PreviewVCDelegate Actions
extension StoryVC : PreviewVCDelegate {
    func goPreviousPage(reverseTo: Int) {
        self.goToPage(to: reverseTo, isForward: false)
    }
    
    func goNextPage(fowardTo: Int) {
        self.goToPage(to: fowardTo, isForward: true)
    }
}
