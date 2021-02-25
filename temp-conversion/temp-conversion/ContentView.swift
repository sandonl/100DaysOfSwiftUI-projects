//
//  ContentView.swift
//  temp-conversion
//
//  Created by Sandon Lai on 24/2/21.
//

import SwiftUI

struct ContentView: View {
    
    @State private var inputTemp = ""
    @State private var conversionFrom = 0
    @State private var conversionTo = 0
       
    let conversion = ["Celsius", "Farenheit", "Kelvin"]
    
    var outputTemp: Double {
        // We use kTemp as a base temperature before converting to other cases
        let temp = Double(inputTemp) ?? 0
        let selectedUnit = conversion[conversionFrom]
        let convertedUnit = conversion[conversionTo]
        var kTemp = 0.0
        var finalTemp = 0.0
        
        switch selectedUnit {
        case "Celsius" :
            kTemp = temp + 273.15
        case "Farenheit":
            kTemp = (temp - 32) * (5/9) + 273.15
        default:
            kTemp = temp
        }
        
        switch convertedUnit  {
        case "Celsius":
            finalTemp = kTemp - 273.15
        case "Farenheit":
            finalTemp = (kTemp - 273.15) * 9/5 + 32
        default:
            finalTemp = kTemp
        }
        
        return finalTemp
    }
    
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Input temperature: ", text: $inputTemp)
                    Picker("Convert from:", selection: $conversionFrom) {
                        ForEach(0 ..< conversion.count) {
                            Text("\(conversion[$0])")
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
                
                Section {
                    Picker("Convert to:", selection: $conversionTo) {
                        ForEach(0 ..< conversion.count) {
                            Text("\(conversion[$0])")
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    Text("Output temperature: \(outputTemp, specifier: "%.2f")")
                }
                
                
            }
            .navigationTitle("Temp-Converter")
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
