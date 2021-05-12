//
//  NoteListLayout.swift
//
//  Created by Senthil Kumar on 19/04/18.
//  Copyright © 2018 Senthil Kumar. All rights reserved.
//  Developer : Senthil Kumar (@senmdu96) - senmdu96@gmail.com
//  Reference: https://www.ductran.co/p/pinterest,
//  https://www.raywenderlich.com/164608/uicollectionview-custom-layout-tutorial-pinterest-2

import UIKit

protocol NoteListLayoutDelegate: class {
    
    func collectionView(collectionView:UICollectionView, heightForTitleAt indexPath:IndexPath,with width:CGFloat) -> CGFloat
    
    func collectionView(collectionView:UICollectionView, heightForSubTitleAt indexPath:IndexPath,with width:CGFloat) -> CGFloat
}

class NoteListLayout: UICollectionViewLayout {
    
    private var numberOfColumns : CGFloat = 2
    var cellPadding : CGFloat = 5.0

    
    weak var delegate : NoteListLayoutDelegate?
    
    private var contentHeight : CGFloat = 0.0
    private var contentWidth  : CGFloat {
        
        let insets = collectionView!.contentInset
        return collectionView!.bounds.width - (insets.left + insets.right)
    }
    
    private var attributeCache = [NoteListLayoutAttributes]()
    
    override func invalidateLayout() {
        self.attributeCache.removeAll()
        super.invalidateLayout()
    }
    
    override func prepare() {
        
        if attributeCache.isEmpty {
            
            let columnWidth = contentWidth / numberOfColumns
           
            var xOffset  =  [CGFloat]()
            for column in 0 ..< Int(numberOfColumns)  {
                xOffset.append(CGFloat(column) * columnWidth)
            }
            var column = 0
            var yOffset = [CGFloat](repeating: 0, count: Int(numberOfColumns) )
            
            for item in 0 ..< collectionView!.numberOfItems(inSection: 0) {
                
                let indexPath = IndexPath(item: item, section: 0)
                
                if indexPath.row == 2 {
                   // columnWidth = contentWidth
                }
                //calculating the frame
                
                let width  =  columnWidth - cellPadding * 2
                
                let titleHeight : CGFloat  = (delegate?.collectionView(collectionView: collectionView!, heightForTitleAt: indexPath, with: width))!
                let subtitleHeight : CGFloat = (delegate?.collectionView(collectionView: collectionView!, heightForSubTitleAt: indexPath, with: width))!
                
              
                let height =  cellPadding + titleHeight + subtitleHeight + cellPadding
                let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
                let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                
                //create cell attribute
                let attribute = NoteListLayoutAttributes(forCellWith: indexPath)
                attribute.titleHeight = titleHeight
                attribute.frame = insetFrame
                attributeCache.append(attribute)
                
                contentHeight = max(contentHeight, frame.maxY)
                yOffset[column] =  yOffset[column] + height
                
                if column >= Int(numberOfColumns - 1) {
                    
                    column = 0
                }else {
                    
                    column +=  1
                }
            }
         
        }
        
    }
    
    override var collectionViewContentSize: CGSize {
        
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        

        return true
    }
    
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in attributeCache {
            
            if attributes.frame.intersects(rect) {
                
                layoutAttributes.append(attributes)
            }
        }
        
        return layoutAttributes
    }

}


class NoteListLayoutAttributes: UICollectionViewLayoutAttributes {
    
    
    var titleHeight : CGFloat = 0.0
    
    override func copy(with zone: NSZone? = nil) -> Any {
        
        let copy = super.copy(with: zone) as! NoteListLayoutAttributes
        copy.titleHeight = titleHeight
        return copy
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        
        if let attributes = object as? NoteListLayoutAttributes {
            
            if attributes.titleHeight == titleHeight {
                
                return super.isEqual(object)
            }
        }
        
        return false
    }
    
}
