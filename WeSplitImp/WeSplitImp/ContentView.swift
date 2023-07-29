//
//  ContentView.swift
//  WeSplitImp
//
//  Created by Zhanerke Ussen on 18/06/2023.
//

import SwiftUI

struct ContentView: View {
    @FocusState private var amountIsFocused: Bool
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    private let tipPercentages = [10, 15, 20, 25, 0]
    private let formatter: FloatingPointFormatStyle<Double>.Currency = .currency(code: Locale.current.currencyCode ?? "USD")
    
    private var grandTotal: Double {
        let tipSelection = Double(tipPercentage)
        let tipValue = checkAmount / 100 * tipSelection
        
        return checkAmount + tipValue
    }
    private var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeople + 2)
        let amountPerPerson = grandTotal / peopleCount

        return amountPerPerson
    }

    var body: some View {
        VStack {
            NavigationView {
                Form {
                    Section {
                        TextField("Amount", value: $checkAmount, format: formatter)
                            .keyboardType(.decimalPad)
                            .focused($amountIsFocused)
                        
                        Picker("Number of people", selection: $numberOfPeople) {
                            ForEach(2..<100) {
                                Text("\($0) people")
                            }
                        }
                    }
                    
                    Section {
                        Picker("Tip percentage", selection: $tipPercentage) {
                            ForEach(tipPercentages, id: \.self) {
                                Text($0, format: .percent)
                            }
                        }.pickerStyle(.segmented)
                    } header: {
                        Text("How much tip do you want to leave?")
                    }
                    
                    Section {
                        Text(grandTotal, format: formatter)
                            .foregroundColor(tipPercentage==0 ? .red : .black)
                    } header: {
                        Text("Total amount")
                    }
                    Section {
                        Text(totalPerPerson, format: formatter)
                    } header: {
                        Text("Amount per person")
                    }
                }.navigationTitle("WeSplit").navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("Done") {
                                amountIsFocused = false
                            }
                        }
                    }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
