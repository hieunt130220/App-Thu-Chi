//
//  Const.swift
//  QuanLyChiTieuCaNhan
//
//  Created by Nguyễn Trung Hiếu on 11/11/2021.
//

import UIKit
let  APP_DELEGATE = UIApplication.shared.delegate as! AppDelegate
var SCENE_DELEGATE = (UIApplication.shared.connectedScenes.filter{ $0.activationState == .foregroundActive }.first as? UIWindowScene)?.delegate as? SceneDelegate
let SCREEN_WIDTH:CGFloat = UIScreen.main.bounds.width
let SCREEN_HEIGHT:CGFloat = UIScreen.main.bounds.height
