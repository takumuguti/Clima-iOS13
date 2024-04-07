//
//  WeatherManager.swift
//  Clima
//
//  Created by Takudzwanashe Muguti on 2024/04/03.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weather: WeatherModel)
    func didFailWithError(_ error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=b6b6682171a714e071379c92c48fded1&units=metric"
    
    func fetchWeather(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString: urlString)
    }
    
    func fetchWeather(lat: CLLocationDegrees, lon: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(lat)&lon=\(lon)"
        print(urlString)
        performRequest(urlString: urlString)
    }
    var delegate: WeatherManagerDelegate?
    
    func performRequest(urlString: String){
        guard let url = URL(string: urlString) else {
            return
        }
        //Create a URLSession
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url){(data, reponse, error)  in
            if error != nil {
                self.delegate?.didFailWithError(error!)
                return
            }
            if let safeData = data {
                if let weather = self.parseJSON(safeData){
                    delegate?.didUpdateWeather(weather)
                }
            }
        }
        task.resume()
        
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
            print(weatherData)
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let conditionId = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            return WeatherModel(conditionId: conditionId, cityName: name, temperature: temp)
        }
        catch {
            self.delegate?.didFailWithError(error)
            return nil
        }
    }
    
    
}

