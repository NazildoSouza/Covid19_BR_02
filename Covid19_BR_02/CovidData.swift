//
//  CovidData.swift
//  Covid19_BR_02
//
//  Created by Nazildo Souza on 24/07/20.
//

import SwiftUI

class CovidData: ObservableObject {
    @Published var selectPicker = 0 {
        didSet {
            if selectPicker == 0 {
                main = nil
                daily.removeAll()
                loadData()
            } else {
                main = nil
                daily.removeAll()
                loadData()
            }
        }
    }
    @Published var main: MainData?
    @Published var daily = [Daily]()
    @Published var last = 0
    @Published var alert = false
    @Published var country: String = "Brazil"
    @Published var response = 0
    @Published var showPicker = false
    @Published var paisTemp = ""
    @Published var statusCode2 = 0
    
    let picker: [String] = ["Meu País", "Mundial"]

    init() {
        loadData()
    }
    
    func loadData() {
        var url = ""
        
        if self.selectPicker == 0 {
            url = "https://disease.sh/v3/covid-19/countries/\(country.replacingOccurrences(of: " ", with: "%20"))"
        } else {
            url = "https://disease.sh/v3/covid-19/all"
        }
        
        let session = URLSession(configuration: .default)
        guard let url1 = URL(string: url) else {return}
        
        session.dataTask(with: url1) { (data, response, error) in
            if error != nil {
                print(error?.localizedDescription ?? "erro desconhecido")
                return
            }
            guard let data = data,
                  let response = response as? HTTPURLResponse else {return}

            do {
                let json = try JSONDecoder().decode(MainData.self, from: data)
                DispatchQueue.main.async {
                    self.response = response.statusCode
                    print(response.statusCode)
                    self.main = json
                    if json.message != nil { self.alert = true }
                }

            } catch {
                print(error.localizedDescription)
                print(error)
            }
        }.resume()
        
        var url2 = ""
        
        if self.selectPicker == 0 {
            url2 = "https://disease.sh/v3/covid-19/historical/\(self.country.replacingOccurrences(of: " ", with: "%20"))?lastdays=7"
        } else {
            url2 = "https://disease.sh/v3/covid-19/historical/all?lastdays=7"
        }
        
        let session2 = URLSession(configuration: .default)
        guard let url3 = URL(string: url2) else {return}
        
        session2.dataTask(with: url3) { (data, response, error) in
            if error != nil {
                print(error?.localizedDescription ?? "erro desconhecido")
                return
            }
            var cases: [String: Int] = [:]
            var count: Int = 0
            
            guard let data = data,
                  let response = response as? HTTPURLResponse else {return}
            
            if self.selectPicker == 0 {
                do {
                    let json = try JSONDecoder().decode(MyCountry.self, from: data)
                    cases = json.timeline.cases
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                do {
                    let json = try JSONDecoder().decode(Timeline.self, from: data)
                    cases = json.cases
                } catch {
                    print(error.localizedDescription)
                }
            }
            
            DispatchQueue.main.async {
                self.statusCode2 = response.statusCode
                print(response.statusCode)
                print("---------------")
                for i in cases {
                    self.daily.append(Daily(id: count, day: i.key, cases: i.value))
                    count += 1
                }
                
                self.daily.sort(by: { $0.day < $1.day })
                
                self.last = self.daily.last?.cases ?? 0
            }
 
        }.resume()
        
    }
    
    func getHeight(value: Int, height: CGFloat) -> CGFloat {
        if self.last != 0 {
            let converted = CGFloat(value) / CGFloat(self.last)
            
            return converted * height
        } else {
            return 0
        }
    }
    
    func dialog() {
        let alert = UIAlertController(title: "País", message: "Digite o nome do seu país", preferredStyle: .alert)
        alert.addTextField { (_) in
            
        }
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .destructive, handler: nil))
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            for i in countryList {
                if i.lowercased() == alert.textFields?.first?.text?.lowercased() {
                    self.country = alert.textFields!.first!.text!.lowercased()
                    self.main = nil
                    self.daily.removeAll()
                    self.loadData()
                    return
                }
            }
            
            self.alert.toggle()
        }))
        
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func SearchPais() {
        self.showPicker = false
        self.statusCode2 = 0
        self.main = nil
        self.daily.removeAll()
        self.loadData()
        
    }
    
}
