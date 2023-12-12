//
//  BluetoothServices.swift
//  GISTracker
//
//  Created by imac-3282 on 2023/11/22.
//

import Foundation
import CoreBluetooth

class BluetoothServices: NSObject {
    static let shared = BluetoothServices()
    
    var central: CBCentralManager?
    var peripheral: CBPeripheralManager?
    
    var BLEPeripherals: [CBPeripheral] = []
    
    var GISPeripheral: CBPeripheral?
    var GISService: CBService?
    var GISReadCharacteristic: CBCharacteristic?
    var GISWriteCharacteristic: CBCharacteristic?
    
    weak var delegate: BluetoothSrvicesDelegate?
    
    private override init() {
        super.init()
        
        let quene = DispatchQueue.global()
        central = CBCentralManager(delegate: self, queue: quene)
    }
    
    func startScan() {
        central?.scanForPeripherals(withServices: nil)
    }
    
    func stopScan() {
        central?.stopScan()
    }
    
    func connectPeripheral(peripheral: CBPeripheral) {
        central?.connect(peripheral)
    }
    
    func disconnectPeripheral(peripheral: CBPeripheral) {
        central?.cancelPeripheralConnection(peripheral)
    }
}

extension BluetoothServices: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("unknown")
        case .resetting:
            print("resetting")
        case .unsupported:
            print("unsupported")
        case .unauthorized:
            print("unauthorized")
        case .poweredOff:
            print("poweredOff")
        case .poweredOn:
            print("poweredOn")
        @unknown default:
            print("藍芽裝置未知狀態")
        }
        
        startScan()
    }
    
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {
        for BLEPeripheral in BLEPeripherals {
            if peripheral.name == BLEPeripheral.name {
                return
            }
        }
        
        if let name = peripheral.name {
            BLEPeripherals.append(peripheral)
            print(name)
        }
        
        if peripheral.name == "TaiRa_BLE Serial_1" {
            GISPeripheral = peripheral
        }
        
        delegate?.getBLEPeripherals(peripherals: BLEPeripherals)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    
    func writeValue(type: CBCharacteristicWriteType, data: Data) {
        guard let peripheral = GISPeripheral,
              let characteristic = GISWriteCharacteristic else {
                  return
              }
        peripheral.writeValue(data, for: characteristic, type: type)
    }
}

extension BluetoothServices: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                if service.uuid.isEqual(CBUUID(string: "0003CDD0-0000-1000-8000-00805F9B0131")) {
                    print(service)
                    GISService = service
                    peripheral.discoverCharacteristics(nil, for: service)
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                if characteristic.uuid.isEqual(CBUUID(string: "0003CDD1-0000-1000-8000-00805F9B0131")) {
                    print(characteristic)
                    GISReadCharacteristic = characteristic
                    peripheral.readValue(for: characteristic)
                    peripheral.setNotifyValue(true, for: characteristic)
                } else if characteristic.uuid.isEqual(CBUUID(string: "0003CDD2-0000-1000-8000-00805F9B0131")) {
                    GISWriteCharacteristic = characteristic
                    print(characteristic)
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral,
                    didUpdateValueFor characteristic: CBCharacteristic,
                    error: Error?) {
        var characteristicASCIIValue = String()
        guard characteristic == GISReadCharacteristic,
              let characteristicValue = characteristic.value,
              let ASCIIstring = String(data: characteristicValue,
                                       encoding: String.Encoding.ascii) else {
            return
        }
        characteristicASCIIValue = ASCIIstring
        print(characteristicASCIIValue)
    }
    
    func peripheral(_ peripheral: CBPeripheral, 
                    didUpdateNotificationStateFor characteristic: CBCharacteristic, 
                    error: Error?) {
    }
    
    func peripheral(_ peripheral: CBPeripheral,
                    didDiscoverDescriptorsFor characteristic: CBCharacteristic,
                    error: Error?) {
        if let descriptors = characteristic.descriptors {
            print(descriptors)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral,
                    didUpdateValueFor descriptor: CBDescriptor,
                    error: Error?) {
        
    }
    
    func peripheral(_ peripheral: CBPeripheral,
                    didWriteValueFor characteristic: CBCharacteristic,
                    error: Error?) {
        print(error)
    }
}

extension BluetoothServices: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .unknown:
            print("unknown")
        case .resetting:
            print("resetting")
        case .unsupported:
            print("unsupported")
        case .unauthorized:
            print("unauthorized")
        case .poweredOff:
            print("poweredOff")
        case .poweredOn:
            print("poweredOn")
        @unknown default:
            print("藍芽裝置未知狀態")
        }
    }
}

protocol BluetoothSrvicesDelegate: NSObjectProtocol {
    func getBLEPeripherals(peripherals: [CBPeripheral])
}
