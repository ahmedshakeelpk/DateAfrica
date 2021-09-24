//
//  EditProfile.swift
//  DateAfrica
//
//  Created by Apple on 12/12/2020.
//

import UIKit
import RangeSeekSlider
import DropDown

class EditProfile: UIViewController {
    var phoneNumber = ""
    let dropDown = DropDown()
    var imagePicker  = UIImagePickerController()

    let arrEthnicity = ["American Indian or Alaska Native", "Asian", "Black or African American", "Native Hawaiian or Other Pacific Islander", "White"]
    let arrReligion = ["Christianity", "Islam", "Hinduism", "Buddhism", "Folk Religions", "Sikhism", "Judaism", "Other"]
    let arrEduLevel = ["Pre School", "Elementary School", "Middle School", "High School"]
    let arrStar = ["Aquarius", "Pisces", "Aries", "Taurus", "Gemini", "Cancer","Leo", "Virgo","Libra", "Scorpio", "Sagittarius", "Capricorn"]
    let arrLanguages = ["English", "Chinese", "Hindi", "Spanish", "French", "Bengali", "Russian", "Portuguese", "Indonesian", "Urdu", "German"]
    let arrEyeColor = ["Blue", "Gray", "Hazel", "Green"]
    let arrHairColor = ["Blonde", "Brunette", "Red", "Black", "Sunflower Blonde"]
    
    
    var userProfileModel: UserProfile.UserProfileModel!
    var selectedCellForImage = EditProfileCell()
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    var userPicturesModel = [UserPicturesModel]()
    @IBOutlet weak var colv: UICollectionView!
    @IBOutlet weak var scrollv: UIScrollView!
    @IBOutlet weak var contentv: UIView!
    
    @IBOutlet weak var btnUpdate: UIButton!
    @IBAction func btnUpdate(_ sender: Any) {
        DispatchQueue.main.async {
            self.funRegisteration()
        }
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidLoad() {
        funUserProfileDetails()
        colv.registerCell(cellName: "EditProfileCell")
        funGetUserPictures()
        self.title = "Update Profile"
        btnUpdate.setButtonCornorRadius()
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

    func funFillDataInFields() {
        DispatchQueue.main.async {
            self.txtvAbout.text = self.userProfileModel.aboutuser
            //self.lblName.text = self.userProfileModel.username
            self.txtvAbout.text = self.userProfileModel.aboutuser
            self.segcGender.selectedSegmentIndex = self.userProfileModel.gender == "Male" ? 0 : 1
            self.txtJob.text = self.userProfileModel.jobtitle
            self.txtSchool.text = "School: " + self.userProfileModel.school
            self.txtCompany.text = "Company: " + self.userProfileModel.company
            //self.pagecontrol.numberOfPages = userProfileModel
            
            //self.lblRange.text = "\(self.userProfileModel.agerangefrom) - \(self.userProfileModel.agerangeto)"
            self.ageRangeSlider.minLabelAccessibilityLabel = "\(self.userProfileModel.agerangefrom)"
            self.ageRangeSlider.maxLabelAccessibilityLabel = "\(self.userProfileModel.agerangeto)"
            self.txtUserName.text = self.userProfileModel.username
            self.txtEmail.text = self.userProfileModel.emailaddress
            self.txtPassword.text = self.userProfileModel.userpasword
            self.txtAge.text = self.userProfileModel.userage
            self.txtEthnicity.text = self.userProfileModel.interestedethnicity
            self.txtReligion.text = self.userProfileModel.interestedreligion
            self.txtEducation.text = self.userProfileModel.educationlevel
            self.segcIntrustedGender.selectedSegmentIndex = self.userProfileModel.intertestedgender == "Male" ? 0 : 1
            self.txtHeight.text = self.userProfileModel.userheight
           // self.txtFeet = self.userProfileModel.
           // self.txtInches.text
            self.segcChildrens.selectedSegmentIndex = self.userProfileModel.interestedchildern == "Yes" ? 0 : 1

            self.segcDrinking.selectedSegmentIndex = self.userProfileModel.interestedindrink == "Yes" ? 0 : 1

            self.segcSmoking.selectedSegmentIndex = self.userProfileModel.interestedinsmoking == "Yes" ? 0 : 1

            self.segcPolitics.selectedSegmentIndex = self.userProfileModel.interestedinpolitics == "Yes" ? 0 : 1

            self.segcDrugs.selectedSegmentIndex = self.userProfileModel.interestedingrugs == "Yes" ? 0 : 1

            self.segcLookingFor.selectedSegmentIndex = self.userProfileModel.lookingfor == "Yes" ? 0 : 1

            self.segcPets.selectedSegmentIndex = self.userProfileModel.interestedinpets == "Yes" ? 0 : 1

            self.segcExercise.selectedSegmentIndex = self.userProfileModel.interestedinexercise == "Gym Lover" ? 0 : self.userProfileModel.interestedinexercise == "Occasionally" ? 1 : 2
            
            self.segcBodyType.selectedSegmentIndex = self.userProfileModel.interestedinexercise == "Skinny" ? 0 : self.userProfileModel.interestedinexercise == "Slim" ? 1 : 2
            
            self.txtStarSign.text = self.userProfileModel.interestedstarsign

            self.txtLanguage.text = self.userProfileModel.interestedlanguage

            
            
            self.segcSexuality.selectedSegmentIndex = self.userProfileModel.interestedsexuality == "Male" ? 0 : 1

            
            self.segcMaritalStatus.selectedSegmentIndex = self.userProfileModel.interestedmatritalstatus == "Married" ? 0 : 1
            
            self.segcLiving.selectedSegmentIndex = self.userProfileModel.livingin == "Independent" ? 0 : 1

            self.segcLongestRelationship.selectedSegmentIndex = self.userProfileModel.interestedinlogestrelationship == "Yes" ? 0 : 1
            
            self.txtEyeColor.text = self.userProfileModel.interestedeyecolor
            self.txtHair.text = self.userProfileModel.interestedhaircolor

            //self.ageRangeSlider: RangeSeekSlider!
            
        }
    }
}




extension EditProfile {
    func funSetRegistrationParameters() -> [String: Any] {
        let gender = segcGender.selectedSegmentIndex == 0 ? "Male" : "Female"
        let intrustGender = segcIntrustedGender.selectedSegmentIndex == 0 ? "Male" : "Female"
        let maxAge = ageRangeSlider.selectedMaxValue
        let minAge = ageRangeSlider.selectedMinValue
        let childrens = segcChildrens.selectedSegmentIndex == 0 ? "Yes" : "No"
        let drinking = segcDrinking.selectedSegmentIndex == 0 ? "Yes" : "No"
        let smoking = segcSmoking.selectedSegmentIndex == 0 ? "Yes" : "No"
        let politics = segcPolitics.selectedSegmentIndex == 0 ? "Yes" : "No"
        let drugs = segcDrugs.selectedSegmentIndex == 0 ? "Yes" : "No"
        let loogkingFor = segcLookingFor.selectedSegmentIndex == 0 ? "Yes" : "No"
        let pets = segcPets.selectedSegmentIndex == 0 ? "Yes" : "No"
        let exercise = (segcExercise.selectedSegmentIndex == 0) ? "GymLover" : (segcExercise.selectedSegmentIndex == 1) ? "Occasionally" : "No Way"
        let bodyType = (segcExercise.selectedSegmentIndex == 0) ? "Skinny" : (segcExercise.selectedSegmentIndex == 1) ? "Slim" : "Average"
        let intrustedGender = segcIntrustedGender.selectedSegmentIndex == 0 ? "Male" : "Female"
        let sexuality = segcIntrustedGender.selectedSegmentIndex == 0 ? "Male" : "Female"
        let maritalStatus = segcMaritalStatus.selectedSegmentIndex == 0 ? "Married" : "Single"
        let living = segcLiving.selectedSegmentIndex == 0 ? "Indipendent" : "Dependent"
        let longRelationShip = segcLongestRelationship.selectedSegmentIndex == 0 ? "Yes" : "No"
        let userHeight = txtHeight.placeholder == "  Feet/Inches" ? txtFeet.text!+"."+txtInches.text! : txtFeet.text!

        
        let parameterDic = [
            "id":"",
            "userage":"\(txtAge.text!)",
            "mobilenumber":phoneNumber,
            "phoneno": phoneNumber,
            "username":txtUserName.text!,
            "emailaddres":txtEmail.text!,
            "userpassword":txtPassword.text!,
            "jobtitle":txtJob.text!,
            "company":txtCompany.text!,
            "school":txtSchool.text!,
            "aboutuser":txtvAbout.text!,
            "intertestedgender":intrustGender,
            "gender":gender,
            "agerangefrom": minAge,
            "agerangeto": maxAge,
            "userheight":userHeight,
            "interestedreligion":txtReligion.text!,
            "interestedchildern":childrens,
            "educationlevel":txtEducation.text!,
            "interestedindrink":drinking,
            "interestedinsmoking":smoking,
            "interestedethnicity":txtEthnicity.text!,
            "interestedinpolitics":politics,
            "interestedingrugs":drugs,
            "interestedinpets":pets,
            "lookingfor":loogkingFor,
            "interestedsexuality":sexuality,
            "interestedbodytype":bodyType,
            "interestedlanguage":txtLanguage.text!,
            "interestedstarsign":txtStarSign.text!,
            "interestedinexercise":exercise,
            "interestedhaircolor":txtHair.text!,
            "interestedeyecolor":txtEyeColor.text!,
            "interestedmatritalstatus":maritalStatus,
            "interestedinlogestrelationship":longRelationShip,
            "interestedpersonalitytype":intrustedGender,
            "livingin":living
        ] as [String: Any]
        
        return parameterDic
    }
    
    
    func funRegisteration() {
        
        let perameters = funSetRegistrationParameters()
        andicator.startAnimating()
        updateProfile(parametersData: perameters, completionHandler:{ success, message in
            self.andicator.stopAnimating()
            if success {
                let vc = sbHome.instantiateViewController(withIdentifier: "HomeTabBar") as! HomeTabBar
                      //  self.present(vc, animated: true, completion: nil)
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            else {
                showAlert(controller: self, title: "Error!", message: message)
            }
        })
    }
    
    func validationRegisteration() -> Bool {
        
        return true
    }
    
    
}


