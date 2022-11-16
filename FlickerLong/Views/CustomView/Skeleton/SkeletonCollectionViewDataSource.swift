//
//  SkeletonCollectionViewDataSource.swift
//  FlickerLong
//
//  Created by LAP15335 on 16/11/2022.
//

import UIKit

enum AssociationPolicy: UInt {
    // raw values map to objc_AssociationPolicy's raw values
    case assign = 0
    case copy = 771
    case copyNonatomic = 3
    case retain = 769
    case retainNonatomic = 1
    
    var objc: objc_AssociationPolicy {
        // swiftlint:disable:next force_unwrapping
        return objc_AssociationPolicy(rawValue: rawValue)!
    }
}

protocol AssociatedObjects: AnyObject { }
extension AssociatedObjects {
    /// wrapper around `objc_getAssociatedObject`
    func ao_get(pkey: UnsafeRawPointer) -> Any? {
        return objc_getAssociatedObject(self, pkey)
    }
    
    /// wrapper around `objc_setAssociatedObject`
    func ao_setOptional(_ value: Any?, pkey: UnsafeRawPointer, policy: AssociationPolicy = .retainNonatomic) {
        guard let value = value else { return }
        objc_setAssociatedObject(self, pkey, value, policy.objc)
    }}

extension NSObject: AssociatedObjects { }


enum CollectionAssociatedKeys {
    static var dummyDataSource = "dummyDataSource"
    static var dummyDelegate = "dummyDelegate"
}

protocol CollectionSkeleton {
    
    var skeletonDataSource: SkeletonCollectionDataSource? { get set }
    var estimatedNumberOfRows: Int { get }
    
    func addDummyDataSource()
    func updateDummyDataSource()
    func removeDummyDataSource(reloadAfter: Bool)
}

extension CollectionSkeleton where Self: UIScrollView {
    
    var estimatedNumberOfRows: Int { return 0 }
    func addDummyDataSource() {}
    func removeDummyDataSource(reloadAfter: Bool) {}
}

public typealias ReusableCellIdentifier = String

public protocol SkeletonCollectionViewDataSource: UICollectionViewDataSource {
    func numSections(in collectionSkeletonView: UICollectionView) -> Int
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier
    func collectionSkeletonView(_ skeletonView: UICollectionView, supplementaryViewIdentifierOfKind: String, at indexPath: IndexPath) -> ReusableCellIdentifier?
    func collectionSkeletonView(_ skeletonView: UICollectionView, skeletonCellForItemAt indexPath: IndexPath) -> UICollectionViewCell?
    func collectionSkeletonView(_ skeletonView: UICollectionView, prepareCellForSkeleton cell: UICollectionViewCell, at indexPath: IndexPath)
    func collectionSkeletonView(_ skeletonView: UICollectionView, prepareViewForSkeleton view: UICollectionReusableView, at indexPath: IndexPath)
}

public extension SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        UICollectionView.automaticNumberOfSkeletonItems
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, supplementaryViewIdentifierOfKind: String, at indexPath: IndexPath) -> ReusableCellIdentifier? {
        nil
    }
    
    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
        1
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, skeletonCellForItemAt indexPath: IndexPath) -> UICollectionViewCell? {
        nil
    }

    func collectionSkeletonView(_ skeletonView: UICollectionView, prepareCellForSkeleton cell: UICollectionViewCell, at indexPath: IndexPath) { }

    func collectionSkeletonView(_ skeletonView: UICollectionView, prepareViewForSkeleton view: UICollectionReusableView, at indexPath: IndexPath) { }
}

public protocol SkeletonCollectionViewDelegate: UICollectionViewDelegate { }


public extension UICollectionView {
    
    static let automaticNumberOfSkeletonItems = -1
    
    func prepareSkeleton(completion: @escaping (Bool) -> Void) {
        guard let originalDataSource = self.dataSource as? SkeletonCollectionViewDataSource,
            !(originalDataSource is SkeletonCollectionDataSource)
            else { return }
        
        let dataSource = SkeletonCollectionDataSource(collectionViewDataSource: originalDataSource, rowHeight: 0.0)
        self.skeletonDataSource = dataSource
        performBatchUpdates({
            self.reloadData()
        }) { done in
            completion(done)
            
        }
    }
}


class SkeletonCollectionDataSource: NSObject {
    weak var originalCollectionViewDataSource: SkeletonCollectionViewDataSource?
    var rowHeight: CGFloat = 0.0
    var originalRowHeight: CGFloat = 0.0
    
    convenience init(collectionViewDataSource: SkeletonCollectionViewDataSource? = nil, rowHeight: CGFloat = 0.0, originalRowHeight: CGFloat = 0.0) {
        self.init()
        self.originalCollectionViewDataSource = collectionViewDataSource
        self.rowHeight = rowHeight
        self.originalRowHeight = originalRowHeight
    }
}


extension UICollectionView: CollectionSkeleton {

    var estimatedNumberOfRows: Int {
        guard let flowlayout = collectionViewLayout as? UICollectionViewFlowLayout else { return 0 }
        switch flowlayout.scrollDirection {
        case .vertical:
            return Int(ceil(frame.height / flowlayout.itemSize.height))
        case .horizontal:
            return Int(ceil(frame.width / flowlayout.itemSize.width))
        default:
            return 0
        }
    }
    
    var skeletonDataSource: SkeletonCollectionDataSource? {
        get { return ao_get(pkey: &CollectionAssociatedKeys.dummyDataSource) as? SkeletonCollectionDataSource }
        set {
            ao_setOptional(newValue, pkey: &CollectionAssociatedKeys.dummyDataSource)
            self.dataSource = newValue
        }
    }

    
    func addDummyDataSource() {
        guard let originalDataSource = self.dataSource as? SkeletonCollectionViewDataSource,
            !(originalDataSource is SkeletonCollectionDataSource)
            else { return }
        
        let dataSource = SkeletonCollectionDataSource(collectionViewDataSource: originalDataSource)
        self.skeletonDataSource = dataSource
        reloadData()
    }
    
    func updateDummyDataSource() {
        if (dataSource as? SkeletonCollectionDataSource) != nil {
            reloadData()
        } else {
            addDummyDataSource()
        }
    }
    
    func removeDummyDataSource(reloadAfter: Bool) {
        guard let dataSource = self.dataSource as? SkeletonCollectionDataSource else { return }
        self.skeletonDataSource = nil
        self.dataSource = dataSource.originalCollectionViewDataSource
        if reloadAfter { self.reloadData() }
    }
    
}


// MARK: - UICollectionViewDataSource
extension SkeletonCollectionDataSource: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        originalCollectionViewDataSource?.numSections(in: collectionView) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let originalCollectionViewDataSource = originalCollectionViewDataSource else {
            return 0
        }

        let numberOfItems = originalCollectionViewDataSource.collectionSkeletonView(collectionView, numberOfItemsInSection: section)

        if numberOfItems == UICollectionView.automaticNumberOfSkeletonItems {
            return collectionView.estimatedNumberOfRows
        } else {
            return numberOfItems
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = originalCollectionViewDataSource?.collectionSkeletonView(collectionView, skeletonCellForItemAt: indexPath) else {
            let cellIdentifier = originalCollectionViewDataSource?.collectionSkeletonView(collectionView, cellIdentifierForItemAt: indexPath) ?? ""
            let fakeCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)

            originalCollectionViewDataSource?.collectionSkeletonView(collectionView, prepareCellForSkeleton: fakeCell, at: indexPath)
            skeletonizeViewIfContainerSkeletonIsActive(container: collectionView, view: fakeCell)
            
            return fakeCell
        }

        originalCollectionViewDataSource?.collectionSkeletonView(collectionView, prepareCellForSkeleton: cell, at: indexPath)
        skeletonizeViewIfContainerSkeletonIsActive(container: collectionView, view: cell)
        return cell
    }
    
    
}

extension SkeletonCollectionDataSource {
    private func skeletonizeViewIfContainerSkeletonIsActive(container: UIView, view: UIView) {
//        guard container.sk.isSkeletonActive,
//              let skeletonConfig = container._currentSkeletonConfig else {
//            return
//        }

        view.isSkeletonLoading = true
    }
}
