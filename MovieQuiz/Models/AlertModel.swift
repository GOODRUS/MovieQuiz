//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Дмитрий Шиляев on 29.09.2025.
//

import Foundation

struct AlertModel {
    var title: String
    var message: String
    var buttonText: String
    var completion: () -> Void
} 
