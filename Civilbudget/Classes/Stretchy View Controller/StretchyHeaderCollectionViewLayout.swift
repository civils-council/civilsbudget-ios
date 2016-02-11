//
//  StretchyHeaderCollectionViewLayout.swift
//  Civilbudget
//
//  Created by Max Odnovolyk on 11/22/15.
//  Copyright © 2015 Build Apps. All rights reserved.
//

import UIKit

class StretchyHeaderCollectionViewLayout: UICollectionViewFlowLayout {
    static let defaultBounceThreshold = CGFloat(50.0)
    
    var headerBounceThreshold = StretchyHeaderCollectionViewLayout.defaultBounceThreshold
    
    override init() {
        super.init()
        
        setUpDefaults()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setUpDefaults()
    }
    
    func setUpDefaults() {
        scrollDirection = .Vertical
        minimumLineSpacing = 0.0
        minimumInteritemSpacing = 0.0
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }

    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView,
            attributes = super.layoutAttributesForElementsInRect(rect) else {
            return super.layoutAttributesForElementsInRect(rect)
        }
        
        let offset = collectionView.contentOffset
        let insets = collectionView.contentInset
        let minY = -insets.top

        if offset.y < minY + headerReferenceSize.height {
            
            // Calculate limited by `headerBounceThreshold` deltaY
            let deltaY = min(max(-(offset.y - minY), -headerBounceThreshold), headerBounceThreshold)
            for attribute in attributes {
                if attribute.representedElementKind == UICollectionElementKindSectionHeader {
                    attribute.frame.size.height = max(minY, headerReferenceSize.height + deltaY);
                    attribute.frame.origin.y -= deltaY;
                    break
                }
            }
        }
        
        return attributes
    }
}