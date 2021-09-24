//
//  Registration.swift
//  DateAfrica
//
//  Created by Apple on 07/12/2020.
//

import UIKit
import Foundation
import RangeSeekSlider
import DropDown

class Registration: UIViewController {
    
    var phoneNumber = ""
    let dropDown = DropDown()
    
    let arrEthnicity = ["American Indian or Alaska Native", "Asian", "Black or African American", "Native Hawaiian or Other Pacific Islander", "White"]
    let arrReligion = ["Christianity", "Islam", "Hinduism", "Buddhism", "Folk Religions", "Sikhism", "Judaism", "Other"]
    let arrEduLevel = ["Pre School", "Elementary School", "Middle School", "High School"]
    let arrStar = ["Aquarius", "Pisces", "Aries", "Taurus", "Gemini", "Cancer","Leo", "Virgo","Libra", "Scorpio", "Sagittarius", "Capricorn"]
    let arrLanguages = ["English", "Chinese", "Hindi", "Spanish", "French", "Bengali", "Russian", "Portuguese", "Indonesian", "Urdu", "German"]
    let arrEyeColor = ["Blue", "Gray", "Hazel", "Green"]
    let arrHairColor = ["Blonde", "Brunette", "Red", "Black", "Sunflower Blonde"]
    
    @IBOutlet weak var scrollv: UIScrollView!
    @IBOutlet weak var contentv: UIView!
    
    @IBOutlet weak var btnRegister: UIButton!
    @IBAction func btnRegister(_ sender: Any) {
        if validationRegisteration() {
            funRegisteration()
        }
    }
    
    @IBOutlet weak var txtvAbout: UITextView!
    @IBOutlet weak var txtJob: UITextField!
    @IBOutlet weak var txtCompany: UITextField!
    @IBOutlet weak var txtSchool: UITextField!
    @IBOutlet weak var segcGender: UISegmentedControl!
    @IBAction func segcGender(_ sender: UISegmentedControl) {
        
    }
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtAge: UITextField!
    @IBOutlet weak var txtEthnicity: UITextField!
    @IBOutlet weak var txtReligion: UITextField!
    @IBOutlet weak var txtEducation: UITextField!
    @IBOutlet weak var segcIntrustedGender: UISegmentedControl!
    @IBAction func segcIntrustedGender(_ sender: UISegmentedControl) {
        
    }
    
    @IBOutlet weak var txtHeight: UITextField!
    @IBOutlet weak var txtFeet: UITextField!
    @IBOutlet weak var txtInches: UITextField!
    @IBOutlet weak var segcChildrens: UISegmentedControl!
    @IBAction func segcChildrens(_ sender: UISegmentedControl) {
        
    }
    @IBOutlet weak var segcDrinking: UISegmentedControl!
    @IBAction func segcDrinking(_ sender: UISegmentedControl) {
        
    }
    @IBAction func txtfunEyeColor(_ sender: Any) {
        funDropDownSet(textField: txtEyeColor, dataSource: arrEyeColor)
    }
    @IBAction func txtfunHairColor(_ sender: Any) {
        funDropDownSet(textField: txtHair, dataSource: arrHairColor)
    }
    @IBAction func txtfunEthnicity(_ sender: Any) {
        funDropDownSet(textField: txtEthnicity, dataSource: arrEthnicity)
    }
    @IBAction func txtfunReligion(_ sender: Any) {
        funDropDownSet(textField: txtReligion, dataSource: arrReligion)
    }
    @IBAction func txtfunEduLevel(_ sender: Any) {
        funDropDownSet(textField: txtEducation, dataSource: arrEduLevel)
    }
    @IBAction func txtfunStar(_ sender: Any) {
        funDropDownSet(textField: txtStarSign, dataSource: arrStar)
    }
    @IBAction func txtfunLanguage(_ sender: Any) {
        funDropDownSet(textField: txtLanguage, dataSource: arrLanguages)
    }
    
    func funDropDownSet(textField: UITextField, dataSource: [String]) {
        textField.resignFirstResponder()
        dropDown.direction = .bottom
        dropDown.width = 140
        self.dropDown.anchorView = textField
        
        
        dropDown.dataSource = dataSource
        dropDown.show()
        self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.dropDown.hide()
            
            textField.text = dataSource[index] as? String
        }
    }
    @IBOutlet weak var segcSmoking: UISegmentedControl!
    @IBAction func segcSmoking(_ sender: UISegmentedControl) {
        
    }
    @IBOutlet weak var segcPolitics: UISegmentedControl!
    @IBAction func segcPolitics(_ sender: UISegmentedControl) {
        
    }
    @IBOutlet weak var segcDrugs: UISegmentedControl!
    @IBAction func segcDrugs(_ sender: UISegmentedControl) {
        
    }
    @IBOutlet weak var segcLookingFor: UISegmentedControl!
    @IBAction func segcLookingFor(_ sender: UISegmentedControl) {
        
    }
    @IBOutlet weak var segcPets: UISegmentedControl!
    @IBAction func segcPets(_ sender: UISegmentedControl) {
        
    }
    @IBOutlet weak var segcExercise: UISegmentedControl!
    @IBAction func segcExercise(_ sender: UISegmentedControl) {
        
    }
    @IBOutlet weak var txtStarSign: UITextField!

    @IBOutlet weak var txtLanguage: UITextField!
    
    @IBOutlet weak var segcBodyType: UISegmentedControl!
    @IBAction func segcBodyType(_ sender: UISegmentedControl) {
        
    }
    @IBOutlet weak var segcSexuality: UISegmentedControl!
    @IBAction func segcSexuality(_ sender: UISegmentedControl) {
        
    }
    @IBOutlet weak var segcMaritalStatus: UISegmentedControl!
    @IBAction func segcMaritalStatus(_ sender: UISegmentedControl) {
        
    }
    @IBOutlet weak var segcLiving: UISegmentedControl!
    @IBAction func segcLiving(_ sender: UISegmentedControl) {
        
    }
    @IBOutlet weak var segcLongestRelationship: UISegmentedControl!
    @IBAction func segcLongestRelationship(_ sender: UISegmentedControl) {
        
    }
    @IBOutlet weak var txtEyeColor: UITextField!
    @IBOutlet weak var txtHair: UITextField!

    @IBOutlet weak var ageRangeSlider: RangeSeekSlider!
    @IBAction func ageRangeSlider(_ sender: Any) {

    }
    
    @IBAction func txtfunHeight(_ sender: Any) {
        txtHeight.resignFirstResponder()
        dropDown.direction = .bottom
        dropDown.width = 140
        self.dropDown.anchorView = txtHeight
        
        
        dropDown.dataSource = ["Feet/Inches", "Centimeters"]
        dropDown.show()
        self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.dropDown.hide()
            //MARK:-
            switch dropDown.dataSource[index] {
                
            case "Feet/Inches":
                txtFeet.placeholder = "  Feet/Inches"
                txtInches.isHidden = false
                break
            case "Centimeters":
                txtFeet.placeholder = "  Centimeters"
                txtInches.isHidden = true
                break
            
            default:
                print("no match")
                break
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidLoad() {
        txtvAbout.delegate = self
        txtvAbout.textColor = .lightGray
        self.title = "Registeration"
        btnRegister.setButtonCornorRadius()
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

}
