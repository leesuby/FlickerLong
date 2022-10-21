//
//  Request.swift
//  FlickerLong
//
//  Created by LAP15335 on 20/10/2022.
//

import Foundation

class RequestData{
    var userId : String = ""
    var page: Int = 1
    
    init(userId : String){
        self.userId = userId
    }
    
    init(page: Int){
        self.page = page
    }
    
    init(){
        
    }
}
