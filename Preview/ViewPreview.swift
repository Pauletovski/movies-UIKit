//
//  ViewPreview.swift
//  Movies-UIKit
//
//  Created by Paulo Lazarini on 31/03/23.
//

import UIKit
import SwiftUI

public struct ViewPreview: UIViewRepresentable {
    let viewBuilder: () -> UIView
    
    public init(_ viewBuilder: @escaping () -> UIView) {
        self.viewBuilder = viewBuilder
    }
    
    public func makeUIView(context: Context) -> some UIView {
        return viewBuilder()
    }
    
    public func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
