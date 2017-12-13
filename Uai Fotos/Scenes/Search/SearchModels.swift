//
//  SearchModels.swift
//  Uai Fotos
//
//  Created by Elifazio Bernardes da Silva on 12/12/2017.
//  Copyright (c) 2017 Uai Fotos. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum Search {
  // MARK: Use cases
  
  enum Friends {
    struct Request {
        var searchText: String
    }
    struct Response {
        var filteredFriends: [UserDTO]?
    }
    struct ViewModel {
        struct DisplayFriend {
            var name: String
            var avatarUrl: URL
            var title: String
        }
        var displayedFriends: [DisplayFriend]
    }
  }
}