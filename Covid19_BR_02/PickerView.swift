//
//  PickerView.swift
//  Covid19_BR_02
//
//  Created by Nazildo Souza on 26/07/20.
//

import SwiftUI

struct PickerView: View {
    @ObservedObject var covidData: CovidData
    
    var body: some View {
        ZStack(alignment: .top) {
            Blur(style: .systemMaterial)
       
            Picker("Pais", selection: $covidData.country) {
                ForEach(countryList, id: \.self) {
                        Text($0)
                    }
                }
                .labelsHidden()
                .padding(.vertical, 50)

            
            HStack {
                Button(action: {
                    covidData.country = covidData.paisTemp
                    covidData.showPicker = false
                }, label: {
                    Text("Cancelar")
                        .accentColor(.red)
                })
                
                Spacer()
                
                Button(action: { covidData.SearchPais() }, label: {
                    Text("Buscar")
                })
            }
            .padding(.horizontal, 50)
            .padding(.top, 30)
            .padding(.bottom)
            .background(Color.black.opacity(0.3))
        }
    }
}

struct PickerView_Previews: PreviewProvider {
    static var previews: some View {
        PickerView(covidData: CovidData())
    }
}
