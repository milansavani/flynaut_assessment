//
//  StoryProgressBar.swift
//  FlynautAssessment
//
//  Created by iMac on 25/04/23.
//

import Foundation
import UIKit

protocol StoryProgressBarDelegate {
    func storyProgressBarChangedIndex(index: Int)
    func storyProgressBarFinished()
}

class StoryProgressBar: UIView {
    
    var delegate: StoryProgressBarDelegate?
    var isPaused: Bool = false {
        didSet {
            if self.isPaused {
                for segment in self.segments {
                    let layer = segment.topView.layer
                    let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
                    layer.speed = 0.0
                    layer.timeOffset = pausedTime
                }
            } else {
                let segment = self.segments[self.currentAnimationIndex]
                let layer = segment.topView.layer
                let pausedTime = layer.timeOffset
                layer.speed = 1.0
                layer.timeOffset = 0.0
                layer.beginTime = 0.0
                let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
                layer.beginTime = timeSincePause
            }
        }
    }
    
    private var segments = [Segment]()
    var duration: TimeInterval
    private var hasDoneLayout = false
    private var currentAnimationIndex = 0
    
    // MARK: - Init Actions
    init(numberOfSegments: Int, duration: TimeInterval = AppConstant.defaultContentTimeout) {
        self.duration = duration
        super.init(frame: CGRect.zero)
        
        for _ in 0..<numberOfSegments {
            let segment = Segment()
            segment.topView.backgroundColor = UIColor.white
            segment.bottomView.backgroundColor = UIColor.white.withAlphaComponent(0.40)
            addSubview(segment.bottomView)
            addSubview(segment.topView)
            self.segments.append(segment)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Actions
    
    /// Layout subview
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.hasDoneLayout {
            return
        }
        let padding = 2.0
        let width = (frame.width - (padding * CGFloat(self.segments.count - 1)) ) / CGFloat(self.segments.count)
        for (index, segment) in self.segments.enumerated() {
            let segFrame = CGRect(x: CGFloat(index) * (width + padding), y: 0, width: width, height: frame.height)
            segment.bottomView.frame = segFrame
            segment.topView.frame = segFrame
            segment.topView.frame.size.width = 0
            
            let cr = frame.height / 2
            segment.bottomView.layer.cornerRadius = cr
            segment.topView.layer.cornerRadius = cr
        }
        self.hasDoneLayout = true
    }
    
    // MARK: - Custom Actions
    func startAnimation() {
        self.layoutSubviews()
        self.animate()
    }
    
    /// Animate the segment view
    /// - Parameter animationIndex: index
    private func animate(animationIndex: Int = 0) {
        let nextSegment = self.segments[animationIndex]
        self.currentAnimationIndex = animationIndex
        self.isPaused = false
        UIView.animate(withDuration: self.duration, delay: 0.0, options: .curveLinear, animations: {
            nextSegment.topView.frame.size.width = nextSegment.bottomView.frame.width
        }) { (finished) in
            if !finished {
                return
            }
            self.next()
        }
    }
    
    /// Move to next segment
    private func next() {
        let newIndex = self.currentAnimationIndex + 1
        if newIndex < self.segments.count {
            self.delegate?.storyProgressBarChangedIndex(index: newIndex)
            self.animate(animationIndex: newIndex)
        } else {
            self.delegate?.storyProgressBarFinished()
        }
    }
    
    /// Skip segment
    func skip() {
        let currentSegment = self.segments[self.currentAnimationIndex]
        currentSegment.topView.frame.size.width = currentSegment.bottomView.frame.width
        currentSegment.topView.layer.removeAllAnimations()
        self.next()
    }
    
    /// Rewind segment
    func rewind() {
        let currentSegment = self.segments[self.currentAnimationIndex]
        currentSegment.topView.layer.removeAllAnimations()
        currentSegment.topView.frame.size.width = 0
        let newIndex = max(currentAnimationIndex - 1, 0)
        let prevSegment = self.segments[newIndex]
        prevSegment.topView.frame.size.width = 0
        self.delegate?.storyProgressBarChangedIndex(index: newIndex)
        self.animate(animationIndex: newIndex)
    }
    
    
    /// Cancel current segment
    func cancel() {
        for segment in segments {
            segment.topView.layer.removeAllAnimations()
            segment.bottomView.layer.removeAllAnimations()
        }
    }
}

fileprivate class Segment {
    let bottomView = UIView()
    let topView = UIView()
    init() {
    }
}
