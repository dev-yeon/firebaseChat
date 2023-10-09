//
//  FirebaseUtil.swift
//  FirebaseChat
//
//  Created by yeon on 10/10/23.
//

import Foundation
import Firebase

class FirebaseUtil: NSObject {
    let auth: Auth
    //스스로 객체 생성 - 인스턴스 (싱글톤)
    static let shared = FirebaseUtil()
    
    //객체생성시 자동호출됨
    override init() {
        FirebaseApp.configure()
        
        self.auth = Auth.auth()
        
        super.init()
    }
}
