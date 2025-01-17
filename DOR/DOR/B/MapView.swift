//
//  MapView.swift
//  DOR
//
//  Created by 황상환 on 1/17/25.
//

import SwiftUI

struct MapView: View {
    @State private var showColoredRoutes: Bool = false
    
    var body: some View {
        ZStack {
            Image("mapView")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            
            GeometryReader { geometry in
                
                // 1번 루트 - 검정선
                Path { path in
                    path.move(to: CGPoint(x: geometry.size.width * 0.48, y: geometry.size.height * 0.34))
                    path.addLine(to: CGPoint(x: geometry.size.width * 0.12, y: geometry.size.height * 0.34))
                    path.addLine(to: CGPoint(x: geometry.size.width * 0.12, y: geometry.size.height * 0.4))
                    path.addLine(to: CGPoint(x: geometry.size.width * 0.3, y: geometry.size.height * 0.4))
                    path.addLine(to: CGPoint(x: geometry.size.width * 0.3, y: geometry.size.height * 0.48))
                    path.addLine(to: CGPoint(x: geometry.size.width * 0.38, y: geometry.size.height * 0.48))
                }
                .stroke(Color.black, lineWidth: 5)
                
                // 1번 루트 - 빨간선
                Path { path in
                    path.move(to: CGPoint(x: geometry.size.width * 0.2, y: geometry.size.height * 0.34))
                    path.addLine(to: CGPoint(x: geometry.size.width * 0.4, y: geometry.size.height * 0.34))
                }
                .stroke(Color.red, lineWidth: 10)
                .opacity(showColoredRoutes ? 1 : 0)
                .animation(.easeInOut(duration: 0.5), value: showColoredRoutes)
                
                // 1번 루트 - 빨간선
                Path { path in
                    path.move(to: CGPoint(x: geometry.size.width * 0.15, y: geometry.size.height * 0.4))
                    path.addLine(to: CGPoint(x: geometry.size.width * 0.28, y: geometry.size.height * 0.4))
                }
                .stroke(Color.red, lineWidth: 10)
                .opacity(showColoredRoutes ? 1 : 0)
                .animation(.easeInOut(duration: 0.5), value: showColoredRoutes)
                
                // 2번루트 - 파란선
                Path { path in
                    path.move(to: CGPoint(x: geometry.size.width * 0.5, y: geometry.size.height * 0.34))
                    path.addLine(to: CGPoint(x: geometry.size.width * 0.9, y: geometry.size.height * 0.34))
                    path.addLine(to: CGPoint(x: geometry.size.width * 0.9, y: geometry.size.height * 0.4))
                    path.addLine(to: CGPoint(x: geometry.size.width * 0.317, y: geometry.size.height * 0.4))
                    path.addLine(to: CGPoint(x: geometry.size.width * 0.317, y: geometry.size.height * 0.475))
                    path.addLine(to: CGPoint(x: geometry.size.width * 0.39, y: geometry.size.height * 0.475))
                }
                .stroke(Color.blue, lineWidth: 5)
                
                // 2번 루트 - 주황선
                Path { path in
                    path.move(to: CGPoint(x: geometry.size.width * 0.55, y: geometry.size.height * 0.338))
                    path.addLine(to: CGPoint(x: geometry.size.width * 0.8, y: geometry.size.height * 0.338))
                }
                .stroke(Color.orange, lineWidth: 10)
                .opacity(showColoredRoutes ? 1 : 0)
                .animation(.easeInOut(duration: 0.5), value: showColoredRoutes)
                
                // 2번 루트 - 노란선
                Path { path in
                    path.move(to: CGPoint(x: geometry.size.width * 0.4, y: geometry.size.height * 0.4))
                    path.addLine(to: CGPoint(x: geometry.size.width * 0.7, y: geometry.size.height * 0.4))
                }
                .stroke(Color.yellow, lineWidth: 10)
                .opacity(showColoredRoutes ? 1 : 0)
                .animation(.easeInOut(duration: 0.5), value: showColoredRoutes)
            }
            
            VStack {
                Spacer()
                
                Button(action: {
                    showColoredRoutes.toggle()
                }) {
                    Text("경로 확인하기")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.bottom, 50)
            }
        }
    }
}

#Preview {
    MapView()
}
