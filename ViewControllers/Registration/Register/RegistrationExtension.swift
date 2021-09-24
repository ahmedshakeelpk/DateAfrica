//
//  RegistrationExtenstion.swift
//  DateAfrica
//
//  Created by Apple on 17/12/2020.
//

import Foundation
import UIKit

extension Registration: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "About User" {
            textView.text = nil
            textView.textColor = .black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView.text! == nil) || (textView.text! == "") || textView.text!.trimmingCharacters(in: .whitespaces) == "" {
            textView.text = "About User"
            textView.textColor = .lightGray
        }
    }
}
