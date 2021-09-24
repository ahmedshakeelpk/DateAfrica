//
//  EditProfileExtension.swift
//  DateAfrica
//
//  Created by Apple on 05/01/2021.
//

import Foundation
import UIKit

extension EditProfile: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let numberofItem: CGFloat = 3

        let collectionViewWidth = self.colv.bounds.width

        let extraSpace = (numberofItem - 1) * flowLayout.minimumInteritemSpacing

        let inset = flowLayout.sectionInset.right + flowLayout.sectionInset.left

        let width = Int((collectionViewWidth - extraSpace - inset) / numberofItem)

        print(width)

        return CGSize(width: width, height: width+50)
    }

    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userPicturesModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EditProfileCell", for: indexPath) as! EditProfileCell
        
        cell.layer.cornerRadius = 4
        cell.layer.borderWidth = 1
        cell.clipsToBounds = true
        cell.layer.borderColor = tabBarHomeIconColor.cgColor
        cell.imgv.loadImage(urlString: userPicturesModel[indexPath.row].imagename)
        cell.btnImage.tag = indexPath.row
        cell.btnImage.addTarget(self, action: #selector(funUploadImage), for: .touchUpInside)
        cell.btnRemoveImage.tag = indexPath.row
        cell.btnRemoveImage.addTarget(self, action: #selector(funRemoveImage), for: .touchUpInside)
//        if selectedCell == indexPath {
//            cell.contentView.backgroundColor = tabBarHomeIconColor
//        }
//        else {
//            cell.contentView.backgroundColor = .white
//        }
        return cell
    }
    
    @objc func funUploadImage(sender: UIButton) {
        selectedCellForImage = colv.cellForItem(at: IndexPath(item: sender.tag, section: 0)) as! EditProfileCell
        
        choosePicture()
    }
    @objc func funRemoveImage(sender: UIButton) {
        funRemoveUserPicture(imageid: userPicturesModel[sender.tag].imgid, index: sender.tag)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //selectedCell = indexPath
//        colv.reloadData()
    }
    
    
}
extension EditProfile: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func choosePicture(){
        imagePicker.delegate = self
        let alert  = UIAlertController(title: "Select Image", message: "", preferredStyle: .actionSheet)
        alert.modalPresentationStyle = .overCurrentContext
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        let popoverController = alert.popoverPresentationController
        
        popoverController?.permittedArrowDirections = .up
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad ) {
            if let currentPopoverpresentioncontroller = alert.popoverPresentationController{
                    currentPopoverpresentioncontroller.permittedArrowDirections = []
                    currentPopoverpresentioncontroller.sourceRect = CGRect(x: (self.view.bounds.midX), y: (self.view.bounds.midY), width: 0, height: 0)
                    currentPopoverpresentioncontroller.sourceView = self.view
                    self.present(alert, animated: true, completion: nil)
                }
            }else{
                self.present(alert, animated: true, completion: nil)
            }
    }
            
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
  
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image  = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage {
            selectedCellForImage.imgv.image = image
            picker.dismiss(animated: true, completion: nil)
            self.andicator.startAnimating()
            DispatchQueue.main.async {
                self.funUploadUserPicture(image: image)
            }
        }
    }
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary() {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
}
