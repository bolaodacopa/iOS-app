//
//  Constants.swift
//  Bolao
//
//  Created by Vagner Machado on 29/09/22.
//

import FirebaseDatabase

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")
let AUTH_URL = API_URL + "auth/"
let API_URL = "https://bolaodacopa.tk/api/"
