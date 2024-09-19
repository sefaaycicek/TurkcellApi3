//
//  ViewController.swift
//  TurkcellApi3
//
//  Created by Sefa Aycicek on 19.09.2024.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var searchBar : UISearchBar!
    @IBOutlet weak var collectionView : UICollectionView!
    
    let CELL_PADDING : CGFloat = 10
    
    let viewModel = ViewControllerViewModel()
    
    let cellName = "MovieCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        
        observeItems()
        
        viewModel.getData(searchText: "man")
        showAlert(title: "", message: "")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        viewModel.save()
    }
    
    func configureCollectionView() {
        let cellNib = UINib(nibName: cellName, bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: cellName)
        
        let viewFlowLaout = UICollectionViewFlowLayout()
        viewFlowLaout.scrollDirection = .vertical
        collectionView.collectionViewLayout = viewFlowLaout
    }
    
    func observeItems() {
        
        nameTextField.rx.text.orEmpty
            .bind(to: viewModel.nameText)
            .disposed(by: viewModel.disposeBag)
        
        
        searchBar.rx.text.orEmpty
            .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe { searchText in
                print(searchText)
                self.viewModel.getData(searchText: searchText)
            }.disposed(by: viewModel.disposeBag)
        
        viewModel.data
            .observe(on: MainScheduler.instance)
            .subscribe { result in
                self.collectionView.reloadData()
            }.disposed(by: viewModel.disposeBag)
    }
}

extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.rowCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName,
                                                         for: indexPath) as? MovieCell {
            
            cell.configure(data: viewModel.getItem(index: indexPath.row))
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension ViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionViewSize = collectionView.frame.size.width - CELL_PADDING * 3
        let width = collectionViewSize / 2
        let ratio : CGFloat = 445.0/300.0
        return CGSize(width: width, height: width * ratio)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: CELL_PADDING, left: CELL_PADDING, bottom: CELL_PADDING, right: CELL_PADDING)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CELL_PADDING
    }
    
    
}


extension UIViewController : AlertMessageProtocol {
    
}

protocol AlertMessageProtocol {
    func showAlert(title : String, message : String)
}

extension AlertMessageProtocol {
    func showAlert(title : String, message : String) {
        
    }
}

