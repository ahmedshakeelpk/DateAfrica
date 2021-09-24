//
//  ProfileDetails.swift
//  DateAfrica
//
//  Created by Apple on 12/12/2020.
//

import UIKit

class ProfileDetails: UIViewController {
    @IBOutlet weak var colv: UICollectionView!
    @IBOutlet weak var scrollv: UIScrollView!
    @IBOutlet weak var contentv: UIView!

    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidLoad() {
        
        colv.registerCell(cellName: "ProfileDetailsCell")

        self.title = "Profile Details"

        for object in self.contentv.subviews {
            if object is UITextField {
                (object as! UITextField).setRound()
                print ("UITextField")
            }
            else {
                for subobject in object.subviews {
                    if subobject  is UITextField {
                        (subobject as! UITextField).setRound()
                        print ("UITextField")
                    }
                }
            }
            
        }
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension ProfileDetails: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let numberofItem: CGFloat = 1

        let collectionViewWidth = self.colv.bounds.width

        let extraSpace = (numberofItem - 1) * flowLayout.minimumInteritemSpacing

        let inset = flowLayout.sectionInset.right + flowLayout.sectionInset.left

        let width = Int((collectionViewWidth - extraSpace - inset) / numberofItem)

        print(width)

        return CGSize(width: width, height: width+50)
    }

    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileDetailsCell", for: indexPath) as! ProfileDetailsCell
        
        cell.layer.cornerRadius = 4
        cell.layer.borderWidth = 1
        cell.clipsToBounds = true
        cell.layer.borderColor = tabBarHomeIconColor.cgColor
//        if selectedCell == indexPath {
//            cell.contentView.backgroundColor = tabBarHomeIconColor
//        }
//        else {
//            cell.contentView.backgroundColor = .white
//        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //selectedCell = indexPath
        colv.reloadData()
    }
    
    
}
