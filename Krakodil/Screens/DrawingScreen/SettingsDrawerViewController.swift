//
//  SettingsDrawerViewController.swift
//  Krakodil
//
//  Created by Nikita Gura on 29/08/2020.
//  Copyright © 2020 Nikita Gura. All rights reserved.
//

import UIKit

class SettingsDrawerViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var widthSlider: UISlider!
    @IBOutlet weak var colorsCollecntionView: UICollectionView!
    
    private let arrayColors: Array<UIColor> = [.red, .black, .blue, .brown, .cyan, .orange, .green]
    public var selectedColor: UIColor = .black
    public var selectedWidth: Float = 5
    var handlerSelectedColor : ((_ color:UIColor, _ width: Float) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibCell = UINib(nibName: CellNames.colorCollectionViewCell, bundle: nil)
        self.colorsCollecntionView.register(nibCell, forCellWithReuseIdentifier: CellNames.colorCollectionViewCell)
        self.widthSlider.value = selectedWidth
        self.widthSlider.addTarget(self, action: #selector(onChangeSlider(sender:)), for: .valueChanged)
    }
    
    @objc func onChangeSlider(sender: UISlider){
        if(sender == widthSlider){
            selectedWidth = sender.value
        }
    }
    
    @IBAction func tappedCancel(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func tappedAccept(_ sender: Any) {
        if let handler = handlerSelectedColor {
            handler(selectedColor, selectedWidth)
        }
        self.dismiss(animated: false, completion: nil)
    }
}

extension SettingsDrawerViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedColor = arrayColors[indexPath.row]
        collectionView.reloadData()
    }
    
}

extension SettingsDrawerViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
}


extension SettingsDrawerViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayColors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colorsCollecntionView.dequeueReusableCell(withReuseIdentifier: CellNames.colorCollectionViewCell, for: indexPath) as! ColorCollectionViewCell
        
        if(selectedColor == arrayColors[indexPath.row]){
            
            cell.setSelected()
            
        }else{
            
            cell.setUnSelected()
            
        }
        
        cell.imageColor.tintColor = arrayColors[indexPath.row]
        return cell
    }
    
    
}
