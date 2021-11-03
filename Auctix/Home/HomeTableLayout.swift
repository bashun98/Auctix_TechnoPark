//
//  HomeTableLayout.swift
//  Auctix
//
//  Created by Михаил Шаговитов on 28.10.2021.
//

import UIKit

class HomeTableLayout: UICollectionViewFlowLayout {
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
            guard let collectionView = collectionView else { return .zero }
        
            let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.frame.width, height: collectionView.frame.height)
            guard let rectAttributes = super.layoutAttributesForElements(in: targetRect) else { return .zero }

            var offsetAdjustment = CGFloat.greatestFiniteMagnitude
            let horizontalCenter = proposedContentOffset.x + collectionView.frame.width / 2

            for layoutAttributes in rectAttributes {
                let itemHorizontalCenter = layoutAttributes.center.x
                if (itemHorizontalCenter - horizontalCenter).magnitude < offsetAdjustment.magnitude {
                    offsetAdjustment = itemHorizontalCenter - horizontalCenter
                }
            }

            return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
        }
}
