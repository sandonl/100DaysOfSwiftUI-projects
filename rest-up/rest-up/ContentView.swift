//
//  ContentView.swift
//  rest-up
//
//  Created by Sandon Lai on 28/2/21.
//

import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    init () {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                
                Color(red: 42/250, green: 157/255, blue: 143/255)
                
                Rectangle().foregroundColor(Color(red: 7/250, green: 59/250, blue: 76/250))
                    .rotationEffect(Angle(degrees: 80))
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    .offset(y: 420)
                    
                VStack (spacing: 20){
                    VStack {
                        Spacer()
                        // Date Picker and time
                        Text("When do you want to wake up?")
                            .font(.headline)

                        DatePicker("Please enter a time",
                                   selection: $wakeUp,
                                   displayedComponents:
                                    .hourAndMinute)
                            .colorInvert()
                            .labelsHidden()
                            .datePickerStyle(WheelDatePickerStyle())
                    }
                    
                    VStack (spacing: 30) {
                        Text("Desired amount of sleep")
                            .font(.headline)
                        
                        Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                            Text("\(sleepAmount, specifier: "%g") hours")
                        }.frame(width: 200, height: 10, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    }
                    
                    VStack (spacing: 30){
                        Group {
                            Text("Daily coffee intake")
                                .font(.headline)
                            
                            Stepper(value: $coffeeAmount, in: 1...20) {
                                if coffeeAmount == 1 {
                                    Text("1 Cup")
                                } else {
                                    Text("\(coffeeAmount) Cups")
                                }
                            }.frame(width: 180, height: 10, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)

                        }
                        // Challenge: Remove the Button and display as text
                        HorizontalText(text: "Your recommended bedtime is: ", textResult: calculateBedTime())
                        
                        // MARK: - Challenge to remove the button and display as a binding
//                        Button(action: calculateBedTime) {
//                            Text("Calculate")
//                        }.font(.title2)
//                        .foregroundColor(.white)
//                        .padding()
//                        .background(Color.init(red: 233/255, green: 196/255, blue: 106/255))
//                        .cornerRadius(20)
                    }
                    Spacer()
                }
                
                    // Colors for the design
                    .foregroundColor(Color.init(red: 241/255, green: 250/255, blue: 238/255))
//                    .alert(isPresented: $showingAlert) {
//                        Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: (.default(Text("OK"))))
//                }
            }
            .navigationBarTitle(Text("Rest Up"))
            .ignoresSafeArea()

        }
    }
    
    // Converts the default wake up time to 7:00
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    func calculateBedTime() -> String {
        // Created from CoreML
        // Model utilises four variables in wake, estimatedSleep, coffee and actualSleep to make predictions
        let model = SleepCalculator()
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
//            alertMessage = formatter.string(from: sleepTime)
//            alertTitle = "Your ideal bedtime is..."
            return formatter.string(from: sleepTime)
        } catch {
//            alertTitle = "Error"
//            alertMessage = "Sorry, there was a problem calculating your bedtime."
            return "Sorry, there was a problem calculating your bedtime."
        }
        
//        showingAlert = true
    }
}

struct HorizontalText: View {
    var text: String
    var textResult: String
    
    var body: some View {
        HStack {
            Text(text)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .frame(width: 200, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
            Text(textResult)
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
