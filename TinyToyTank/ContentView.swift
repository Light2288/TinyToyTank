//
//  ContentView.swift
//  TinyToyTank
//
//  Created by Davide Aliti on 25/05/23.
//

import SwiftUI
import RealityKit

class ViewModel: ObservableObject {
    var onTankLeftNotification: () -> Void = { }
    var onTankRightNotification: () -> Void = { }
    var onTankForwardNotification: () -> Void = { }
    var onTurretLeftNotification: () -> Void = { }
    var onTurretRightNotification: () -> Void = { }
    var onCannonFireNotification: () -> Void = { }
    var isActionPlaying: Bool = false
}

struct ContentView : View {
    @StateObject var vm = ViewModel()
    
    var body: some View {
        ZStack {
            ARViewContainer(vm: vm).edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                HStack {
                    Button {
                        vm.onTurretLeftNotification()
                    } label: {
                        Image("TurretLeft")
                            .resizable()
                            .frame(width: 80, height: 80, alignment: .center)
                    }
                    Button {
                        vm.onCannonFireNotification()
                    } label: {
                        Image("CannonFire")
                            .resizable()
                            .frame(width: 80, height: 80, alignment: .center)
                    }
                    Button {
                        vm.onTurretRightNotification()
                    } label: {
                        Image("TurretRight")
                            .resizable()
                            .frame(width: 80, height: 80, alignment: .center)
                    }
                }
                HStack {
                    Button {
                        vm.onTankLeftNotification()
                    } label: {
                        Image("TankLeft")
                            .resizable()
                            .frame(width: 80, height: 80, alignment: .center)
                    }
                    Button {
                        vm.onTankForwardNotification()
                    } label: {
                        Image("TankForward")
                            .resizable()
                            .frame(width: 80, height: 80, alignment: .center)
                    }
                    Button {
                        vm.onTankRightNotification()
                    } label: {
                        Image("TankRight")
                            .resizable()
                            .frame(width: 80, height: 80, alignment: .center)
                    }
                }
            }
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    let vm: ViewModel
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        
        let tankAnchor = try! TinyToyTank.load_TinyToyTank()
        
        tankAnchor.cannon?.setParent(tankAnchor.tank, preservingWorldTransform: true)
        
        tankAnchor.actions.actionComplete.onAction = { _ in
            vm.isActionPlaying = false
        }
        
        vm.onTankRightNotification = {
            guard !vm.isActionPlaying else { return }
            vm.isActionPlaying = true
            tankAnchor.notifications.tankRight.post()
        }
        vm.onTankLeftNotification = {
            guard !vm.isActionPlaying else { return }
            vm.isActionPlaying = true
            tankAnchor.notifications.tankLeft.post()
        }
        vm.onTankForwardNotification = {
            guard !vm.isActionPlaying else { return }
            vm.isActionPlaying = true
            tankAnchor.notifications.tankForward.post()
        }
        vm.onTurretRightNotification = {
            guard !vm.isActionPlaying else { return }
            vm.isActionPlaying = true
            tankAnchor.notifications.turretRight.post()
        }
        vm.onTurretLeftNotification = {
            guard !vm.isActionPlaying else { return }
            vm.isActionPlaying = true
            tankAnchor.notifications.turretLeft.post()
        }
        vm.onCannonFireNotification = {
            guard !vm.isActionPlaying else { return }
            vm.isActionPlaying = true
            tankAnchor.notifications.cannonFire.post()
        }
        
        arView.scene.anchors.append(tankAnchor)
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
