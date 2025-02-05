//
//  Section.swift
//  Medusa
//
//  Created by zheer barzan on 5/2/25.
//

import Foundation
import SwiftUI

struct Section : Identifiable{
    let id = UUID()
    let title: String
    let body: [String]
    let symbol: String?
    let symbolColor: Color?
}
