//
//  RecordedAudio.swift
//  Perfect Pitch
//
//  Created by Luc Peeters on 30/04/15.
//  Copyright (c) 2015 Digitmedia. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl: NSURL, title: String){
        self.filePathUrl = filePathUrl
        self.title = title
    }
}
