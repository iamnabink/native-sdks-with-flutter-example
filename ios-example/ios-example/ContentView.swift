//
//  ContentView.swift
//  ios-example
//
//  Created by Nabraj Khadka on 18/01/2026.
//

import SwiftUI
import UIKit
import Flutter

struct ContentView: View {
    @Environment(\.appDelegate) var appDelegate
    @State private var count = 0
    @State private var methodChannel: FlutterMethodChannel?
    
    var body: some View {
        VStack {
            Text("Current counter: \(count)")
                .font(.title)
                .padding()
            
            Button("Open Flutter View") {
                openFlutterView()
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .padding()
        .onAppear {
            setupMethodChannel()
        }
    }
    
    func setupMethodChannel() {
        let delegate = appDelegate ?? (UIApplication.shared.delegate as? AppDelegate)
        guard let delegate = delegate,
              let flutterEngine = delegate.flutterEngine else {
            print("Flutter engine not available")
            return
        }
        
        methodChannel = FlutterMethodChannel(name: "dev.flutter.example/counter",
                                             binaryMessenger: flutterEngine.binaryMessenger)
        methodChannel?.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            switch(call.method) {
            case "incrementCounter":
                count += 1
                reportCounter()
            case "requestCounter":
                reportCounter()
            default:
                print("Unrecognized method name: \(call.method)")
            }
        })
    }
    
    func reportCounter() {
        methodChannel?.invokeMethod("reportCounter", arguments: count)
    }
    
    func openFlutterView() {
        let delegate = appDelegate ?? (UIApplication.shared.delegate as? AppDelegate)
        guard let delegate = delegate,
              let flutterEngine = delegate.flutterEngine else {
            print("Flutter engine not available")
            return
        }
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            print("Could not find root view controller")
            return
        }
        
        let flutterViewController = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
        rootViewController.present(flutterViewController, animated: false, completion: nil)
    }
}

#Preview {
    ContentView()
}
