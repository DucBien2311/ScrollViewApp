//
//  SlideView.swift
//  ScrollViewApp
//
//  Created by NguyenDucBien on 1/9/17.
//  Copyright © 2017 NguyenDucBien. All rights reserved.
//

import UIKit

class SlideView: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var pageController: UIPageControl!
    
    var photo: [UIImageView] = []
    
    var pageImages: [String] = []
    
    var frontScrollViews: [UIScrollView] = []
    
    var first = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        pageImages = ["Dog1", "Dog2", "Dog3", "Dog4", "Dog5"]
        pageController.currentPage = 0
        pageController.numberOfPages = pageImages.count
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 2
        
        
        
    }
    
    
    override func viewDidLayoutSubviews() {
        
        if (!first)
        {
            first = true
            let pageScrollViewSize = scrollView.frame.size
            scrollView.contentSize = CGSizeMake(pageScrollViewSize.width * CGFloat(pageImages.count), 0)
            for i in 0 ..< pageImages.count
            {
                
                let imgView = UIImageView(image: UIImage(named: pageImages[i] + ".jpg"))
                imgView.frame = CGRectMake(0, 0, scrollView.frame.size.width, scrollView.frame.size.height)
                imgView.contentMode = .ScaleAspectFit
                imgView.userInteractionEnabled = true
                imgView.multipleTouchEnabled = true
                let tap = UITapGestureRecognizer(target: self, action: #selector(SlideView.tapImg(_:)))
                tap.numberOfTapsRequired = 1
                imgView.addGestureRecognizer(tap)
                let doubleTap = UITapGestureRecognizer(target: self, action: #selector(SlideView.doubleTapImg(_:)))
                doubleTap.numberOfTapsRequired = 2
                imgView.addGestureRecognizer(doubleTap)
                tap.requireGestureRecognizerToFail(doubleTap)
                photo.append(imgView)
                
                let frontScrollView = UIScrollView(frame: CGRectMake(CGFloat(i) * scrollView.frame.size.width, 0, scrollView.frame.size.width, scrollView.frame.size.height))
                
                frontScrollView.minimumZoomScale = 1
                frontScrollView.maximumZoomScale = 2
                frontScrollView.delegate = self
                frontScrollView.addSubview(imgView)
                frontScrollViews.append(frontScrollView)
                self.scrollView.addSubview(frontScrollView)
                
            }
        }
    }
    
    
    func tapImg(gesture: UITapGestureRecognizer) {
        let position = gesture.locationInView(photo[pageController.currentPage])
        zoomRectForScale(frontScrollViews[pageController.currentPage].zoomScale * 1.5, center: position)
    }
    
    func doubleTapImg(gesture: UITapGestureRecognizer) {
        let position = gesture.locationInView(photo[pageController.currentPage])
        zoomRectForScale(frontScrollViews[pageController.currentPage].zoomScale * 0.5, center: position)
    }
    
    func zoomRectForScale(scale: CGFloat, center: CGPoint) {
        var zoomRect = CGRect()
        let scrollViewSize = scrollView.bounds.size
        zoomRect.size.height = scrollViewSize.height / scale
        zoomRect.size.width = scrollViewSize.width / scale
        
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0)
        
        frontScrollViews[pageController.currentPage].zoomToRect(zoomRect, animated: true)
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageController.currentPage = Int(pageNumber)
        
    }
    
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView?
    {
        return photo[pageController.currentPage]
    }
    
    
    @IBAction func onChange(sender: AnyObject) {
        scrollView.contentOffset = CGPointMake(CGFloat(pageController.currentPage) * scrollView.frame.size.width, 0)
    }
    
    
    
    
    
    
    
    
    
    
}
