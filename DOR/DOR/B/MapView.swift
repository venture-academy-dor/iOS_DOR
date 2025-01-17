//
//  MapView.swift
//  DOR
//
//  Created by 황상환 on 1/17/25.
//

import SwiftUI

struct ModalContentView: View {
    @State private var reportImage: UIImage?
    @State private var isLoading = true
    let reportId: Int
    let onDismiss: () -> Void
    private let networkManager = NetworkManager()
    @State private var content: String = ""
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
            } else {
                if let image = reportImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 400, height: 400)
                }
                
                Text("신고 내용")
                    .font(.title3)
                    .padding()
                
                Text(content)
                    .padding()
                
                Button("닫기") {
                    onDismiss()
                }
                .padding()
            }
        }
        .onAppear {
            loadReportDetail()
        }
    }
    
    private func loadReportDetail() {
        networkManager.fetchReportDetail(id: reportId) { result in
            switch result {
            case .success(let detail):
                loadImage(from: detail.imageUrl) { image in
                    DispatchQueue.main.async {
                        self.reportImage = image
                        self.content = detail.content
                        self.isLoading = false
                    }
                }
            case .failure(let error):
                print("Error fetching report detail: \(error)")
                self.isLoading = false
            }
        }
    }
    
    private func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error loading image: \(error)")
                completion(nil)
                return
            }
            
            if let data = data {
                completion(UIImage(data: data))
            } else {
                completion(nil)
            }
        }.resume()
    }
}

struct MapView: View {
    @State private var showColoredRoutes: Bool = false
    @State private var showModal: Bool = false
    @State private var modalContent: String = ""
    @State private var dangerLevel: Int = 0 // 서버에서 받을 위험도 레벨 (0-4)
    
    // 위험도 레벨에 따른 색상 반환
    private func getDangerColor(_ level: Int) -> Color {
        switch level {
        case 0:
            return Color.yellow
        case 1:
            return Color(hex: "FFBC2D")  // 약간 위험 (진한 노랑)
        case 2:
            return Color.orange
        case 3:
            return Color(hex: "FF6333")  // 심각 위험 (진한 주황)
        case 4:
            return Color.red         // 가장 위험 (빨강)
        default:
            return Color.green      // 기본값
        }
    }
    
    private func showModalWithContent(reportId: Int) {
        showModal = true
        modalContent = String(reportId)  // reportId를 저장
    }
    
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
                .stroke(showColoredRoutes ? getDangerColor(dangerLevel) : Color.green, lineWidth: 10)
                .onTapGesture {
                    showModalWithContent(reportId: 1)
                }
                
                // 1번 루트 - 빨간선
                Path { path in
                    path.move(to: CGPoint(x: geometry.size.width * 0.15, y: geometry.size.height * 0.4))
                    path.addLine(to: CGPoint(x: geometry.size.width * 0.28, y: geometry.size.height * 0.4))
                }
                .stroke(Color.red, lineWidth: 10)

                
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

                
                // 2번 루트 - 노란선
                Path { path in
                    path.move(to: CGPoint(x: geometry.size.width * 0.4, y: geometry.size.height * 0.4))
                    path.addLine(to: CGPoint(x: geometry.size.width * 0.7, y: geometry.size.height * 0.4))
                }
                .stroke(Color.yellow, lineWidth: 10)

            }
            
            VStack {
                Spacer()
                
                Button(action: {
                    // 네트워크 매니저 인스턴스 생성
                    let networkManager = NetworkManager()
                    
                    // 서버에서 위험도 레벨 가져오기
                    networkManager.fetchDangerLevel { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let level):
                                self.dangerLevel = level
                                self.showColoredRoutes.toggle()
                            case .failure(let error):
                                print("Error fetching danger level: \(error)")
                            }
                        }
                    }
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
        .sheet(isPresented: $showModal) {
            ModalContentView(reportId: Int(modalContent) ?? 1, onDismiss: {
                showModal = false
            })
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    MapView()
}
