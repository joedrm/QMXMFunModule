//
//  QNNDomainNameAnalysis.swift
//  QNN
//
//  Created by Smalla on 2018/11/12.
//  Copyright © 2018 qianshengqian. All rights reserved.
//

import UIKit
import dnssd

public let globalDomain: String = "domain.qianniuniu.com"

public class QNNDomainNameAnalysis: NSObject {
    
    public typealias DNSLookupHandler = (String) -> Void
    
    /// 域名解析
    public static func getIP() {
        
        let host = CFHostCreateWithName(nil, globalDomain as CFString).takeRetainedValue()
        CFHostStartInfoResolution(host, .addresses, nil)
        var success: DarwinBoolean = false
        if let addresses = CFHostGetAddressing(host, &success)?.takeUnretainedValue() as NSArray?,
            let theAddress = addresses.firstObject as? NSData {
            var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
            if getnameinfo(theAddress.bytes.assumingMemoryBound(to: sockaddr.self), socklen_t(theAddress.length),
                           &hostname, socklen_t(hostname.count), nil, 0, NI_NUMERICHOST) == 0 {
                let numAddress = String(cString: hostname)
                debugPrintOnly(numAddress)
            }
        }
        
    }
    
    /// 获取域名对应下的所有IP地址
    public static func getAllIP() {
        let host = CFHostCreateWithName(nil, globalDomain as CFString).takeRetainedValue()
        CFHostStartInfoResolution(host, .addresses, nil)
        var success: DarwinBoolean = false
        if let addresses = CFHostGetAddressing(host, &success)?.takeUnretainedValue() as NSArray? {
            for case let theAddress as NSData in addresses {
                var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                if getnameinfo(theAddress.bytes.assumingMemoryBound(to: sockaddr.self), socklen_t(theAddress.length),
                               &hostname, socklen_t(hostname.count), nil, 0, NI_NUMERICHOST) == 0 {
                    let numAddress = String(cString: hostname)
                    debugPrintOnly(numAddress)
                }
            }
        }
    }
    
    public static func lookup(_ domainName: String, completionHandler: @escaping DNSLookupHandler) {
        var mutableCompletionHandler = completionHandler // completionHandler needs to be mutable to be used as inout param
        let callback: DNSServiceQueryRecordReply = {
            (sdRef, flags, interfaceIndex, errorCode, fullname, rrtype, rrclass, rdlen, rdata, ttl, context) -> Void in
            // dereference completionHandler from pointer since we can't directly capture it in a C callback
            guard let completionHandlerPtr = context?.assumingMemoryBound(to: DNSLookupHandler.self) else { return }
            let completionHandler = completionHandlerPtr.pointee
            // map memory at rdata to a UInt8 pointer
            guard let txtPtr = rdata?.assumingMemoryBound(to: UInt8.self) else {
                completionHandler("")
                return
            }
            // advancing pointer by 1 to skip bad character at beginning of record
            let txt = String(cString: txtPtr.advanced(by: 1))
            // parse name=value txt record into dictionary
            //            var record: [String: String] = [:]
            //            let recordParts = txt.components(separatedBy: "=")
            //            record[recordParts[0]] = recordParts[1]
            completionHandler(txt)
        }
        
        // MemoryLayout<T>.size can give us the necessary size of the struct to allocate
        let serviceRef: UnsafeMutablePointer<DNSServiceRef?> = UnsafeMutablePointer.allocate(capacity: MemoryLayout<DNSServiceRef>.size)
        // pass completionHandler as context object to callback so that we have a way to pass the record result back to the caller
        DNSServiceQueryRecord(serviceRef, 0, 0, domainName, UInt16(kDNSServiceType_TXT), UInt16(kDNSServiceClass_IN), callback, &mutableCompletionHandler);
        DNSServiceProcessResult(serviceRef.pointee)
        DNSServiceRefDeallocate(serviceRef.pointee)
    }
}
