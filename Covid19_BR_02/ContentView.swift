//
//  ContentView.swift
//  Covid19_BR_02
//
//  Created by Nazildo Souza on 24/07/20.
//

import SwiftUI

struct ContentView: View {
    @StateObject var covidData = CovidData()
    
    var body: some View {
        Group {
            if covidData.response == 200 {
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)), Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        .edgesIgnoringSafeArea(.all)
                    
                    Blur(style: .systemMaterial)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack(spacing: 15) {
                        HStack {
                            Text("Estatísticas")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            Button(action: { covidData.dialog() }, label: {
                                Text("\(covidData.country.uppercased())")
                                    .fontWeight(.bold)
                            })
                        }
                        .padding(.top, 15)
                        .padding(.horizontal)
                        
                        Picker("Picker", selection: $covidData.selectPicker) {
                            ForEach(0..<covidData.picker.count) { select in
                                Text(covidData.picker[select])
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal, 15)
                        .padding(.all)
                        .disabled(covidData.main == nil || covidData.daily.isEmpty)
                        
                        HStack(spacing: 12) {
                            VStack(spacing: 10) {
                                Text("Infectados")
                                    .fontWeight(.bold)
                               
                                if covidData.main != nil {
                                    Text("\((covidData.main?.cases ?? 0))")
                                        .font(.title)
                                        .fontWeight(.bold)
                                } else {
                                    ProgressView()
                                }
                                
                            }
                            .padding(.vertical)
                            .frame(width: (UIScreen.main.bounds.width / 2) - 20)
                            .background(Color.orange)
                            
                            .cornerRadius(12)
                            .shadow(radius: 5)
                            
                            VStack(spacing: 10) {
                                Text("Mortos")
                                    .fontWeight(.bold)
                                
                                if covidData.main != nil {
                                    Text("\(covidData.main?.deaths ?? 0)")
                                        .font(.title)
                                        .fontWeight(.bold)
                                } else {
                                    ProgressView()
                                }
                            }
                            .padding(.vertical)
                            .frame(width: (UIScreen.main.bounds.width  / 2) - 20)
                            .background(Color.red)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                        }
                        
                        HStack(spacing: 12) {
                            VStack(spacing: 10) {
                                Text("Recuperados")
                                    .fontWeight(.bold)
                                
                                if covidData.main != nil {
                                    Text("\(covidData.main?.recovered ?? 0)")
                                        .fontWeight(.bold)
                                } else {
                                    ProgressView()
                                }
                            }
                            .padding(.vertical)
                            .frame(width: (UIScreen.main.bounds.width  / 3) - 20)
                            .background(Color.green)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                            
                            VStack(spacing: 10) {
                                Text("Ativos")
                                    .fontWeight(.bold)
                                
                                if covidData.main != nil {
                                    Text("\(covidData.main?.active ?? 0)")
                                        .fontWeight(.bold)
                                } else {
                                    ProgressView()
                                }
                            }
                            .padding(.vertical)
                            .frame(width: (UIScreen.main.bounds.width  / 3) - 20)
                            .background(Color.blue)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                            
                            VStack(spacing: 10) {
                                Text("Sérios")
                                    .fontWeight(.bold)
                                
                                if covidData.main != nil {
                                    Text("\(covidData.main?.critical ?? 0)")
                                        .fontWeight(.bold)
                                } else {
                                    ProgressView()
                                }
                            }
                            .padding(.vertical)
                            .frame(width: (UIScreen.main.bounds.width  / 3) - 20)
                            .background(Color.purple)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                        }
                        
                        Spacer(minLength: 5)
                        
                        ZStack {
                            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.1412506998, green: 0.9358793497, blue: 0.6233919263, alpha: 1)), Color(#colorLiteral(red: 0, green: 0.6720501781, blue: 0.887023747, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                .edgesIgnoringSafeArea(.all)
                            
                            
                            Blur(style: .systemMaterial)
                                .edgesIgnoringSafeArea(.all)
                            
                            VStack {
                                HStack {
                                    Spacer()
                                    
                                    Text("Últimos 7 Dias")
                                        .font(.title)
                                    
                                    Spacer()
                                }
                                .padding(.all)
                                
                                if !covidData.daily.isEmpty {
                                    
                                    HStack {
                                        ForEach(covidData.daily.sorted(), id: \.id) { i in
                                            VStack {
                                                Text("\(i.cases / 1000)K")
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                                
                                                GeometryReader { g in
                                                    VStack {
                                                        Spacer(minLength: 0)
                                                        
                                                        Rectangle()
                                                            .fill(Color.red)
                                                            .frame(width: 20, height: self.covidData.getHeight(value: i.cases, height: g.frame(in: .global).height))
                                                            .cornerRadius(5)
                                                    }
                                                }
                                                .padding(.leading)
                                                
                                                Text(i.day)
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                    
                                } else {
                                    ProgressView()
                                }
                            }
                            .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
                            
                        }
                        .clipShape(Corners(corner: [.topLeft, .topRight], size: CGSize(width: 40, height: 40)))
                        .shadow(radius: 8)
                        .edgesIgnoringSafeArea(.bottom)
                    }
                    .alert(isPresented: self.$covidData.alert) {
                        Alert(title: Text("Erro"), message: Text("Nome de país invalido!"), dismissButton: .destructive(Text("OK")))
                    }
                }
            } else {
                ProgressView("Aguarde...")
            }
        }
        .preferredColorScheme(.dark)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

