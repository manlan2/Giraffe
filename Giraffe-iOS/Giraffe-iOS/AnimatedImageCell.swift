//
//  AnimatedImageCell.swift
//  Giraffe-iOS
//
//  Created by Evgen Dubinin on 7/9/16.
//  Copyright © 2016 Yevhen Dubinin. All rights reserved.
//

import UIKit
import FLAnimatedImage

class AnimatedImageCell: UICollectionViewCell {
    
    @IBOutlet weak var animatedImageView: FLAnimatedImageView!
    
    override init(frame: CGRect) {
        fatalError("init(frame:) is not implemented")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.contentView.backgroundColor = UIColor.giraffeOrange()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // some code...
    }
    
    func configureWith(viewModel: AnimatedImageViewModelType) {
        // local
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let pathForFile = NSBundle.mainBundle().pathForResource("01", ofType: "gif")
            let url = NSURL.fileURLWithPath(pathForFile!)
            let data = NSData(contentsOfURL: url)
            let imageLocal = FLAnimatedImage.init(animatedGIFData: data)
            dispatch_async(dispatch_get_main_queue(), {
                self.animatedImageView.animatedImage = imageLocal
            })
        }
        
        // remote
//        let image = FLAnimatedImage.init(animatedGIFData: NSData(contentsOfURL: NSURL(string: "https://media1.giphy.com/media/l46CpUy7GwBmjP8QM/200.gif")!))
//        self.animatedImageView?.animatedImage = image
    }
}