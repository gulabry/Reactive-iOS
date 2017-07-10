//
//  ReactiveModel.swift
//  Reactive
//
//  Created by Bryan Gula on 7/10/17.
//  Copyright © 2017 Gula, Inc. All rights reserved.
//

import Foundation
import ReactiveJSON
import ReactiveSwift
import Result

struct ReactiveModel: Singleton, ServiceHost {

    //'Singleton'
    private(set) static var shared = Instance()
    typealias Instance = ReactiveModel
    
    // 'ServiceHost'
    static var scheme: String { return "http" }
    static var host: String { return "jsonplaceholder.typicode.com" }
    static var path: String? { return nil }
}

struct User {
    var id : Int
    var name : String
    var username : String
    var email : String
}

struct Post {
    var id : Int
    var title : String
    var body : String
}

struct Comment {
    var id : Int
    var name : String
    var email : String
    var body : String
}
