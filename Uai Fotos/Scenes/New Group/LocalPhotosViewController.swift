//
//  LocalPhotosViewController.swift
//  Uai Fotos
//
//  Created by Aloc SP08608 on 13/12/2017.
//  Copyright (c) 2017 Uai Fotos. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import MapKit

protocol LocalPhotosDisplayLogic: class {
    func displayPhotosByLocation(viewModel: LocalPhotos.PhotosByLocation.ViewModel)
}


class LocalPhotosViewController: UIViewController, LocalPhotosDisplayLogic {
    
    var interactor: LocalPhotosBusinessLogic?
    var router: (NSObjectProtocol & LocalPhotosRoutingLogic & LocalPhotosDataPassing)?
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var localPhotosCollection: UICollectionView!
    // constraint de altura da collection para ser alterada de acordo com o contentsize.height
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    lazy var photosOfLocation = [(photo: PhotoDTO, friend: UserDTO)]()
    var location: LocationDTO?
    
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = LocalPhotosInteractor()
        let presenter = LocalPhotosPresenter()
        let router = LocalPhotosRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.mapView.userTrackingMode = .follow
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        
        self.localPhotosCollection.dataSource = self
        self.localPhotosCollection.delegate = self

        self.localPhotosCollection.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        getPhotosByLocation()
        
        self.title = self.location?.city
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if let size = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                self.collectionViewHeightConstraint.constant = size.height
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showLocation()
    }
    
    func showLocation() {
        if let loc = self.location {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(loc.latitude), longitude: CLLocationDegrees(loc.longitude))
            annotation.title = loc.description
            annotation.subtitle = loc.description
            self.mapView.showAnnotations([annotation], animated: true)
        }
    }
    
    func getPhotosByLocation() {
        if let location = self.location {
            let request = LocalPhotos.PhotosByLocation.Request(latitude: location.latitude, longitude: location.longitude)
            interactor?.getPhotosByLocation(request: request)
        }
    }
    
    func displayPhotosByLocation(viewModel: LocalPhotos.PhotosByLocation.ViewModel) {
        self.photosOfLocation = viewModel.photos
        self.localPhotosCollection.reloadData()
    }
}

extension LocalPhotosViewController: MKMapViewDelegate {
    
}

extension LocalPhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photosOfLocation.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCell
        let photoUrl = self.photosOfLocation[indexPath.row].photo.imageUrl
        cell.photoImage.kf.indicatorType = .activity
        cell.photoImage.kf.setImage(with: photoUrl)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier:  UIPhotoCellTitleView.identifier,
                                                                             for: indexPath) as! UIPhotoCellTitleView
            headerView.lblTitle.text = "Principais publicações"
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: false)
        
        let item  = self.photosOfLocation[indexPath.row]
//        let values = (photo: item, friend: UserDTO(name: nil, title: nil, email: nil, avatar: nil, photos: nil, friends: nil, website: nil, gender: nil, phone: nil, birthday: nil))
        
        router?.navigateToPhotoDetail(values: item)
        
    }
    
}

extension LocalPhotosViewController: UICollectionViewDelegate {
    
    
}

extension LocalPhotosViewController : PhotoCellDelegate {
    
    func feedPhotoCell(_ photoCell: PhotoCell, imageTap image: UIImageView) {
//        router?.navigateToPhotoDetail(values: <#T##(photo: PhotoDTO, friend: UserDTO)#>)
    }

}

extension LocalPhotosViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width / 3) - 2
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
}