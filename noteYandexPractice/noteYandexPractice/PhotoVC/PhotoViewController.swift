//
//  PhotoViewController.swift
////  noteYandexPractice
////
////  Created by Admin on 10/07/2019.
////  Copyright © 2019 musamuss. All rights reserved.
////

import UIKit

class PhotoViewController: UIViewController {
    
    var imageViews = [UIImageView]()
    var images: [UIImage]?
    var lastIndex: Int?
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let images = self.images else {
            return
        }
        imageViews.removeAll()
        
        
        if let lastIndex = lastIndex {
            let currentImages = images[lastIndex..<images.count]
            let finishImage = images[0..<lastIndex]
            for image in currentImages {
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFit
                scrollView?.addSubview(imageView)
                imageViews.append(imageView)
            }
            for image in finishImage {
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFit
                scrollView?.addSubview(imageView)
                imageViews.append(imageView)
            }
            
        } else {
            for image in images {
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFit
                scrollView?.addSubview(imageView)
                imageViews.append(imageView)
            }
        }
        
        
        
        
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//       if let lastIndex = lastIndex  {
//            var frame: CGRect = scrollView.frame
//            frame.origin.x = frame.width * CGFloat(lastIndex)
//            frame.origin.y = 0
//            scrollView.scrollRectToVisible(frame, animated: false)
//        }
//    }
   
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        for (index, imageView) in imageViews.enumerated(){
            imageView.frame.size = scrollView.frame.size
            imageView.frame.origin.x = scrollView.frame.width * CGFloat(index)
            imageView.frame.origin.y = 0
        }
        let contentWidth = scrollView.frame.width * CGFloat(imageViews.count)
        scrollView.contentSize = CGSize(width: contentWidth, height: scrollView.frame.height)
    }

}
