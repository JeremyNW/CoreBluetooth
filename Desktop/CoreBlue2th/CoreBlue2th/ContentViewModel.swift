//
//  ContentViewModel.swift
//  CoreBlue2th
//
//  Created by Jeremy Warren on 12/28/22.
//

import Foundation
import CoreBluetooth

class ContentViewModel: NSObject, ObservableObject {
  
    private var centralManager: CBCentralManager?
    @Published var peripherals: [CBPeripheral] = []
    private var selectedPeripheral: CBPeripheral?
    
    
    override init() {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: .main)
        
    }

    func didSelectPeripheral(_ peripheral: CBPeripheral) {
        self.selectedPeripheral = peripheral
        centralManager?.connect(peripheral)
        centralManager?.stopScan()
    }
    
}

extension ContentViewModel: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            self.centralManager?.scanForPeripherals(withServices: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !peripherals.contains(peripheral) {
            self.peripherals.append(peripheral)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        print("did connect")
        peripheral.discoverServices(nil)
        
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("could not connect")
    }
}

extension ContentViewModel: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }

        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
                print(service)
               // Iterate over the characteristics and print their UUIDs
               for characteristic in characteristics {
                   print(characteristic)
               }
    }
}
