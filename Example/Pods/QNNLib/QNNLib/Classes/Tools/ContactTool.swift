//
//  ContactTool.swift
//  QNN
//
//  Created by zhenyu on 17/3/28.
//  Copyright © 2017年 qianshengqian. All rights reserved.
//

import Foundation
import AddressBook
import AddressBookUI

public class ContactTool: NSObject {
    
    public static func isEnableAuthorize() -> Bool {
        let status = ABAddressBookGetAuthorizationStatus()
        if status == .denied || status == .restricted {
            debugPrintOnly("通讯录未授权")
            return false
        }
        return true
    }
    
    public static func getContact(success: ((String) -> Void)? = nil, fail: (() -> ())? = nil) {
        var error: Unmanaged<CFError>?
        let addressBook = ABAddressBookCreateWithOptions(nil, &error).takeRetainedValue()
        if error != nil {
            debugPrintOnly(error!.takeRetainedValue())
            fail?()
            return
        }
        ABAddressBookRequestAccessWithCompletion(addressBook) { (granted, error) in
            if !granted {
                return
            }
            
            var dict = [[String: String]]()
            if let people = ABAddressBookCopyArrayOfAllPeople(addressBook)?.takeRetainedValue() {
                let numberOfPeople = CFArrayGetCount(people)
                for i in 0..<numberOfPeople {
                    var personDic = [String: String]()
                    
                    let personP = CFArrayGetValueAtIndex(people, i)
                    let person = unsafeBitCast(personP, to: ABRecord.self)
                    let firstName = ABRecordCopyValue(person, kABPersonFirstNameProperty)?.takeRetainedValue() as? String ?? ""
                    let lastName = ABRecordCopyValue(person, kABPersonLastNameProperty)?.takeRetainedValue() as? String ?? ""
                    personDic["name"] = firstName + lastName
                    
                    //电话
                    let phone = unsafeBitCast(ABRecordCopyValue(person, kABPersonPhoneProperty), to: ABMultiValue.self)
                    
                    if ABMultiValueGetCount(phone) > 0 {
                        let personPhone = unsafeBitCast(ABMultiValueCopyValueAtIndex(phone, 0), to: AnyObject.self) as? String ?? ""
                        personDic["phone"] = personPhone.replacingOccurrences(of: "-", with: "")
                        
                    }else{
                        continue
                    }
                    dict.append(personDic)
                }
                do {
                    let data = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                    let strJson = String(data: data, encoding: String.Encoding.utf8) ?? ""
                    success?(strJson)
                } catch let dataError {
                    debugPrintOnly(dataError)
                    fail?()
                }
            }
        }
    }
}
