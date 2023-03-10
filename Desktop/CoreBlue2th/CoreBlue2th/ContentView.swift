//
//  ContentView.swift
//  CoreBlue2th
//
//  Created by Jeremy Warren on 12/28/22.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @ObservedObject private var contentVM = ContentViewModel()
    @State private var audioPlayer: AVAudioPlayer!
    @State private var isConnecting = false
    
    var body: some View {
        NavigationView {
            VStack {
                List(contentVM.peripherals, id: \.self) { peripheral in
                    Text(peripheral.name ?? "Unnamed Device")
                        .onTapGesture {
                            contentVM.didSelectPeripheral(peripheral)
                          
                        }
            }
                Button {
                    self.audioPlayer.play()
                } label: {
                    Text("Mambo #5")
                }
            }
            .onAppear {
                
                let audioPath = Bundle.main.path(forResource: "Mambo6", ofType: "mp3")!
                let url = URL(string: audioPath)!
                do {
                    
                    try self.audioPlayer = AVAudioPlayer(contentsOf: url)
                } catch {
                    print(error.localizedDescription, error)
                }
            }
        }
        .navigationTitle("Bluetooth")
    }
    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
