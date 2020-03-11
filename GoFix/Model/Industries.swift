//
//  Industries.swift
//  GoFix
//
//  Created by Wolf on 25/02/2020.
//  Copyright © 2020 WolfMobileApp. All rights reserved.
//

import Foundation

struct Industries {
    let icon: String
    let id: Int
    let name: String
    let services: [Services]
}

struct Services {

    let id: Int
    let industry_id: Int
    let name: String
}

struct IndustriesAndServices {

    let industry_id: Int
    let industry_name: String
    let service_id: Int
    let service_name: String
    
}
