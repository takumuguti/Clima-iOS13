//
//  WeatherData.swift
//  Clima
//
//  Created by Takudzwanashe Muguti on 2024/04/04.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
    let name: String
    let main: Temperature
    let weather: [Weather]
}

struct Temperature: Decodable {
    let temp: Double
}

struct Weather: Decodable {
    let id: Int
}
