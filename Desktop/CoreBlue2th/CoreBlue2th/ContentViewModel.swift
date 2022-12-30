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
        print("did connect")
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("could not connect")
    }
}
