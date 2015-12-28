//
//  CollectionController.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 12/19/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import Bond

class StretchyCollectionController: NSObject {
    var maxHorizontalBounceDistance = GlobalConstants.maxHorizontalBounceDistance
    var exposedHeaderViewHeight = GlobalConstants.exposedHeaderViewHeight
    var topToolbarHeight = GlobalConstants.topToolbarHeight
    
    let toolbarIsHiden = Observable(false)
    let toolbarAlpha = Observable(CGFloat(0.0))
    let stretchDistance = Observable(CGFloat(0.0))
}

extension StretchyCollectionController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -maxHorizontalBounceDistance {
            scrollView.contentOffset = CGPointMake(0, -maxHorizontalBounceDistance)
        }
        
        let toolbarIsHiden = scrollView.contentOffset.y < exposedHeaderViewHeight - topToolbarHeight
        if toolbarIsHiden {
            let headerViewOffset = min(max(-scrollView.contentOffset.y, -maxHorizontalBounceDistance), maxHorizontalBounceDistance)
            if self.stretchDistance.value != headerViewOffset {
                self.stretchDistance.value = headerViewOffset
            }
        } else {
            let toolbarAlpha =  (scrollView.contentOffset.y - exposedHeaderViewHeight + topToolbarHeight) / topToolbarHeight
            if toolbarAlpha != self.toolbarAlpha.value {
                self.toolbarAlpha.value = toolbarAlpha
            }
        }
        self.toolbarIsHiden.value = toolbarIsHiden
    }
}