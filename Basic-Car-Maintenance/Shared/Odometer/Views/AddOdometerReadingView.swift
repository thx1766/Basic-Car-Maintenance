//
//  AddOdometerReadingView.swift
//  Basic-Car-Maintenance
//
//  Created by Nate Schaffner on 10/15/23.
//

import SwiftUI

struct AddOdometerReadingView: View {
    
    let vehicles: [Vehicle]
    let addTapped: (OdometerReading) -> Void

    @State private var date = Date()
    @State private var selectedVehicle: Vehicle?
    @State private var selectedVehicleId: String?
    @State private var isMetric = false
    @State private var distance = 0
    @State private var switchUnitModalIsPresented = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {

            Form {
                Section {
                    VStack {
                        HStack {
                            TextField("Distance", value: $distance, format: .number)
                            Picker(selection: $isMetric) {
                                Text("Miles").tag(false)
                                Text("Kilometers").tag(true)
                            } label: {
                                Text("Preferred units",
                                     comment: "Odometer reading units picker label")
                            }
                            .pickerStyle(.segmented)
                        }
                    }
                }
                
                Section {
                    Picker(selection: $selectedVehicleId) {
                        ForEach(vehicles) {
                            Text($0.name).tag($0.id)
                        }
                    } label: {
                        Text("Select a vehicle",
                             comment: "Odometer reading vehicle picker label")
                    }
                    .pickerStyle(.menu)
                } header: {
                    Text("Vehicle", comment: "Odometer Reading Vehicle Picker Label")
                }
                
                DatePicker(selection: $date, displayedComponents: .date) {
                    Text("Date",
                         comment: "Date picker label")
                }
                .dynamicTypeSize(...DynamicTypeSize.accessibility2)
            }
            .onAppear {
                if !vehicles.isEmpty {
                    selectedVehicle = vehicles[0]
                    selectedVehicleId = vehicles[0].id
                }
            }
            .navigationTitle(Text("Add Reading",
                                  comment: "Nagivation title for Add Odometer view"))
            .toolbar {
                ToolbarItem {
                    Button {
                        selectedVehicle = vehicles.first(where: {$0.id == selectedVehicleId})
                        if let selectedVehicle {
                            let reading = OdometerReading(date: date,
                                                          distance: distance,
                                                          isMetric: isMetric,
                                                          vehicle: selectedVehicle)
                            addTapped(reading)
                            dismiss()
                        }
                    } label: {
                        Text("Add",
                             comment: "Label for button to add data")
                    }
                    .disabled(distance < 0)
                }
            }
        }
    }
}

#Preview {
    AddOdometerReadingView(vehicles: sampleVehicles) { _ in }
}

let sampleVehicle = [
    Vehicle(name: "Nate Forester", make: "Subaru", model: "Forester"),
    Vehicle(name: "Dani Impreza", make: "Subaru", model: "Impreza")
]
