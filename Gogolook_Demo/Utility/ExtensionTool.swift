//
//  ExtensionTool.swift
//  Gogolook_Demo
//
//  Created by Helios Chen on 2022/7/20.
//

import UIKit

var orininalFrame = "orininalFrame"

extension UITableView {
    func reloadDataSmoothly() {
        UIView.setAnimationsEnabled(false)
        CATransaction.begin()
        
        CATransaction.setCompletionBlock { () -> Void in
            UIView.setAnimationsEnabled(true)
        }
        
        reloadData()
        beginUpdates()
        endUpdates()
        
        CATransaction.commit()
    }
    
    func setHeaderView(frame: CGRect, headView: UIView?) {
        objc_setAssociatedObject(self, &orininalFrame, frame, .OBJC_ASSOCIATION_RETAIN)
        self.tableHeaderView = headView
    }
}

