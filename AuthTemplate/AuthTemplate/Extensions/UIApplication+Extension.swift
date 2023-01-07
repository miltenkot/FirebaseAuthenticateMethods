//
//  UIApplication+Extension.swift
//  AuthTemplate
//
//  Created by Bartłomiej on 07/01/2023.
//

import SwiftUI

extension UIApplication {
    static var keyWindow: UIWindow? {
        UIApplication.shared
            .connectedScenes.lazy
            .compactMap{ $0.activationState == .foregroundActive ? ($0 as? UIWindowScene) : nil }
            .first(where: { $0.keyWindow != nil })?
            .keyWindow
    }
}
