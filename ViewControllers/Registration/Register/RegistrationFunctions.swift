//
//  RegistrationFunctions.swift
//  DateAfrica
//
//  Created by Apple on 17/12/2020.
//

import Foundation

extension Registration {
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
        let sexuality = segcSexuality.selectedSegmentIndex == 0 ? "Male" : "Female"
        let maritalStatus = segcMaritalStatus.selectedSegmentIndex == 0 ? "Married" : "Single"
        let living = segcLiving.selectedSegmentIndex == 0 ? "Indipendent" : "Dependent"
        let longRelationShip = segcLongestRelationship.selectedSegmentIndex == 0 ? "Yes" : "No"
        let userHeight = txtHeight.placeholder == "  Feet/Inches" ? txtFeet.text!+"."+txtInches.text! : txtFeet.text!
        let parameterDic = [
            "id":"",
            "userage":"\(txtAge.text!)",
            "mobilenumber":phoneNumber,
            "phoneno":phoneNumber,
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
        
        Registration.simpleRegistration(parametersData: perameters, completionHandler:{ success, message in
            
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


