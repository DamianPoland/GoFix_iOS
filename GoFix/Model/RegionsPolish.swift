//
//  File.swift
//  GoFix
//
//  Created by Wolf on 06/03/2020.
//  Copyright © 2020 WolfMobileApp. All rights reserved.
//

import Foundation

class RegionsPolish {
    
    func getRegions() -> [RegionsPolishItem] {
        
        var helpListOfRegions: [RegionsPolishItem] = []
        
        helpListOfRegions.append(RegionsPolishItem(region_ID: 1, region_name: "dolnośląskie"))
        helpListOfRegions.append(RegionsPolishItem(region_ID: 2, region_name: "kujawsko-pomorskie"))
        helpListOfRegions.append(RegionsPolishItem(region_ID: 3, region_name: "lubelskie"))
        helpListOfRegions.append(RegionsPolishItem(region_ID: 4, region_name: "lubuskie"))
        helpListOfRegions.append(RegionsPolishItem(region_ID: 5, region_name: "łódzkie"))
        helpListOfRegions.append(RegionsPolishItem(region_ID: 6, region_name: "małopolskie"))
        helpListOfRegions.append(RegionsPolishItem(region_ID: 7, region_name: "mazowieckie"))
        helpListOfRegions.append(RegionsPolishItem(region_ID: 8, region_name: "opolskie"))
        helpListOfRegions.append(RegionsPolishItem(region_ID: 9, region_name: "podkarpackie"))
        helpListOfRegions.append(RegionsPolishItem(region_ID: 10, region_name: "podlaskie"))
        helpListOfRegions.append(RegionsPolishItem(region_ID: 11, region_name: "pomorskie"))
        helpListOfRegions.append(RegionsPolishItem(region_ID: 12, region_name: "śląskie"))
        helpListOfRegions.append(RegionsPolishItem(region_ID: 13, region_name: "świętokrzyskie"))
        helpListOfRegions.append(RegionsPolishItem(region_ID: 14, region_name: "warmińsko-mazurskie"))
        helpListOfRegions.append(RegionsPolishItem(region_ID: 15, region_name: "wielkopolskie"))
        helpListOfRegions.append(RegionsPolishItem(region_ID: 16, region_name: "zachodnio-pomorskie"))
        
        return helpListOfRegions
        
    }

}

struct RegionsPolishItem {
    var region_ID: Int
    var region_name: String
}
