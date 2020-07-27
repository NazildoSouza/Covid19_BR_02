//
//  ContentView.swift
//  Covid19_BR_02
//
//  Created by Nazildo Souza on 24/07/20.
//

import SwiftUI
import SDWebImageSwiftUI

struct ContentView: View {
    @StateObject var covidData = CovidData()
    @State private var dragAmount = CGSize.zero
    @State private var showGraphic = false
    
    var body: some View {
        Group {
            if covidData.response == 200 || covidData.main != nil {
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)), Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        .edgesIgnoringSafeArea(.all)
                    
                    Blur(style: .systemMaterial)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack(spacing: UIDevice.current.name == "iPhone SE (2nd generation)" ? 10 : 15) {
                        HStack {
                            Text("Estatísticas")
                                .font(UIDevice.current.name == "iPhone SE (2nd generation)" ? .title2 : .title)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            if covidData.selectPicker == 0 {
                                Button(action: {
                                    covidData.paisTemp = covidData.country
                                    covidData.showPicker.toggle()
                                }, label: {
                                    Text("\(covidData.country)")
                                        .fontWeight(.bold)
                                        .multilineTextAlignment(.center)
                                        .padding(.trailing, 5)
                                })
                                
                                ZStack {
                                    Capsule()
                                        .frame(width: 50, height: 30)
                                        .background(Color(.red))
                                        .clipShape(Capsule())
                                        .shadow(radius: 5)
                                    
                                WebImage(url: URL(string: covidData.main?.countryInfo?.flag ?? ""))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 30)
                                    .clipShape(Capsule())
                                    .shadow(radius: 5)
                                    
                                }
                                
                            } else {
                                Text("Mundial")
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                            }
                            
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
                        .disabled((covidData.main == nil && covidData.response == 200) || (covidData.daily.isEmpty && covidData.statusCode2 == 200))
                        
                        HStack(spacing: 12) {
                            VStack(spacing: UIDevice.current.name == "iPhone SE (2nd generation)" ? 5 : 10) {
                                Text("Infectados")
                                    .fontWeight(.bold)
                               
                                if covidData.main != nil {
                                    Text("\((covidData.main?.cases ?? 0))")
                                        .font(UIDevice.current.name == "iPhone SE (2nd generation)" ? .title2 : .title)
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
                            
                            VStack(spacing: UIDevice.current.name == "iPhone SE (2nd generation)" ? 5 : 10) {
                                Text("Mortos")
                                    .fontWeight(.bold)
                                
                                if covidData.main != nil {
                                    Text("\(covidData.main?.deaths ?? 0)")
                                        .font(UIDevice.current.name == "iPhone SE (2nd generation)" ? .title2 : .title)
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
                        
                        HStack(spacing: 8) {
                            VStack(spacing: UIDevice.current.name == "iPhone SE (2nd generation)" ? 5 : 10) {
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
                            .frame(width: (UIScreen.main.bounds.width  / 3) - 10)
                            .background(Color.green)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                            
                            VStack(spacing: UIDevice.current.name == "iPhone SE (2nd generation)" ? 5 : 10) {
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
                            .frame(width: (UIScreen.main.bounds.width  / 3) - 10)
                            .background(Color.blue)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                            
                            VStack(spacing: UIDevice.current.name == "iPhone SE (2nd generation)" ? 5 : 10) {
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
                            .frame(width: (UIScreen.main.bounds.width  / 3) - 10)
                            .background(Color.purple)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                        }
                        
                        Spacer(minLength: 5)
                        
                        ZStack {
                            VStack(spacing: UIDevice.current.name == "iPhone SE (2nd generation)" ? 15 : (showGraphic ? 30 : 15)) {
                                VStack(spacing: UIDevice.current.name == "iPhone SE (2nd generation)" ? 5 : 10) {
                                    Text("Casos Confirmados Hoje")
                                        .fontWeight(.bold)
                                   
                                    if covidData.main != nil {
                                        Text("\((covidData.main?.todayCases ?? 0))")
                                            .font(UIDevice.current.name == "iPhone SE (2nd generation)" ? .title2 : .title)
                                            .fontWeight(.bold)
                                    } else {
                                        ProgressView()
                                    }
                                    
                                }
                                .padding(.vertical)
                                .frame(width: (UIScreen.main.bounds.width) - 50)
                                .background(Color.gray)
                                .cornerRadius(15)
                                .shadow(radius: 5)
                                
                                VStack(spacing: UIDevice.current.name == "iPhone SE (2nd generation)" ? 5 : 10) {
                                    Text("Mortes Confirmadas Hoje")
                                        .fontWeight(.bold)
                                   
                                    if covidData.main != nil {
                                        Text("\((covidData.main?.todayDeaths ?? 0))")
                                            .font(UIDevice.current.name == "iPhone SE (2nd generation)" ? .title2 : .title)
                                            .fontWeight(.bold)
                                    } else {
                                        ProgressView()
                                    }
                                    
                                }
                                .padding(.vertical)
                                .frame(width: (UIScreen.main.bounds.width) - 50)
                                .background(Color.red)
                                .cornerRadius(15)
                                .shadow(radius: 5)
                            }
                            .offset(y: showGraphic ? -50 : 0)
                            
                            ZStack(alignment: .top) {
                                LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.1412506998, green: 0.9358793497, blue: 0.6233919263, alpha: 1)), Color(#colorLiteral(red: 0, green: 0.6720501781, blue: 0.887023747, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                    .edgesIgnoringSafeArea(.all)
                                
                                
                                Blur(style: .systemMaterial)
                                    .edgesIgnoringSafeArea(.all)
                                
                                VStack {
                                    Capsule()
                                        .background(Color.red)
                                        .frame(width: 60, height: 5)
                                        .padding(.top)
                                    
                                    HStack {
                                        Spacer()
                                        
                                        Text("Últimos 7 Dias")
                                            .font(UIDevice.current.name == "iPhone SE (2nd generation)" ? .title2 : .title)
                                        
                                        Spacer()
                                    }
                                    .padding([.horizontal, .bottom])
                                    
                                    if !covidData.daily.isEmpty {
                                        
                                        HStack {
                                            ForEach(covidData.daily.sorted(), id: \.id) { i in
                                                VStack {
                                                    Text(i.cases > 1000 ? "\(i.cases / 1000)K" : "\(i.cases)")
                                                        .font(UIDevice.current.name == "iPhone SE (2nd generation)" ? .caption2 : .caption)
                                                        .foregroundColor(.secondary)
                                                        .lineLimit(1)
                                                    
                                                    GeometryReader { g in
                                                        VStack {
                                                            Spacer(minLength: 0)
                                                            
                                                            Rectangle()
                                                                .fill(Color.red)
                                                                .frame(width: 20, height: self.covidData.getHeight(value: i.cases, height: g.frame(in: .global).height))
                                                                .clipShape(Corners(corner: [.topLeft, .topRight], size: CGSize(width: 6, height: 6)))
                                                        }
                                                    }
                                                    .padding(.leading, UIDevice.current.name == "iPhone SE (2nd generation)" ? 10 : 15)
                                                    
                                                    Text(i.day)
                                                        .font(UIDevice.current.name == "iPhone SE (2nd generation)" ? .caption2 : .caption)
                                                        .foregroundColor(.secondary)
                                                        .lineLimit(1)
                                                        .padding(.bottom, UIDevice.current.name == "iPhone SE (2nd generation)" ? 5 : 0)
                                                    
                                                }
                                            }
                                        }
                                        .padding(.horizontal)
                                        
                                    } else {
                                        if covidData.statusCode2 == 404 {
                                            Text("Estado não encontrado ou não possui dados históricos do município")
                                                .fontWeight(.bold)
                                                .multilineTextAlignment(.center)
                                        } else {
                                            ProgressView()
                                        }
                                    }
                                }
                                .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
                                
                            }
                            .clipShape(Corners(corner: [.topLeft, .topRight], size: CGSize(width: 40, height: 40)))
                            .shadow(radius: 8)
                            .edgesIgnoringSafeArea(.bottom)
                            .offset(y: showGraphic ? (UIDevice.current.name == "iPhone SE (2nd generation)" ? 250 : 400) : 0)
                            .gesture(
                                DragGesture()
                                    .onChanged { self.dragAmount = $0.translation }
                                    .onEnded { value in
                                        if self.dragAmount.height > 150 {
                                            withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 0)){
                                                
                                                self.showGraphic = true
                                                
                                            }
                                        } else if self.dragAmount.height < -50 {
                                            withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 0)){
                                                
                                                self.showGraphic = false

                                            }
                                        }
                                        
                                        }
                            
                            )
                        }
                    }
                    .alert(isPresented: self.$covidData.alert) {
                        Alert(title: Text("Erro"), message: Text("País não encontrado ou sem casos.\nPor Favor escolha outo País !"), dismissButton: .destructive(Text("OK")) {
                            covidData.country = covidData.paisTemp
                            covidData.loadData()
                        })
                    }
                    if covidData.showPicker {
                        Color.black.opacity(0.4).edgesIgnoringSafeArea(.all)
                    }
                    
                    PickerView(covidData: covidData)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
                        .clipShape(Corners(corner: [.topLeft, .topRight], size: CGSize(width: 20, height: 20)))
                        .offset(y: covidData.showPicker ? UIScreen.main.bounds.height / 3 : UIScreen.main.bounds.height)
                        .animation(.default)

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

