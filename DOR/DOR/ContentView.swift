//
//  ContentView.swift
//  DOR
//
//  Created by 황상환 on 1/17/25.
//

import SwiftUI
import PhotosUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct ContentView: View {
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var reportText = ""
    @State private var showCamera = false
    @State private var isSubmitting = false
    @State private var submissionMessage: String?
    
    private let networkManager = NetworkManager()
    private let fixedArray = [0, 1, 2, 3, 4] // 거리 인덱스
    
    var body: some View {
        VStack(spacing: 20) {
            
            Spacer()
            
            // 카메라 버튼
            Button(action: {
                showCamera = true
            }) {
                VStack {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.blue)
                        .padding(.bottom, 5)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.blue.opacity(0.3), lineWidth: 2)
                    .background(Color.white)
            )
            .padding(.horizontal)
            
            // 이미지 미리보기
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }
            
            // 신고 내용
            TextEditor(text: $reportText)
                .frame(height: 100)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
                .padding(.horizontal)
                .overlay(
                    Group {
                        if reportText.isEmpty {
                            Text("신고 내용을 입력해주세요")
                                .foregroundColor(Color.gray.opacity(0.5))
                                .padding(.horizontal)
                                .padding(.top, 8)
                        }
                    },
                    alignment: .topLeading
                )
            
            // 전송하기
            Button(action: {
                submitReport()
            }) {
                Text("신고하기")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .disabled(isSubmitting)
            
            Spacer()
            
            // 결과 메시지
            if let message = submissionMessage {
                Text(message)
                    .foregroundColor(.green)
                    .padding()
            }
        }
        .padding(.top, 20)
        .sheet(isPresented: $showCamera) {
            ImagePicker(image: $selectedImage, sourceType: .camera)
        }
        .onTapGesture {
           UIApplication.shared.endEditing()
       }
    }
    
    private func submitReport() {
        UIApplication.shared.endEditing()
        
        guard !reportText.isEmpty else {
            submissionMessage = "신고 내용을 입력해주세요."
            return
        }
        
        isSubmitting = true
        submissionMessage = nil
        
        let imageData = selectedImage?.jpegData(compressionQuality: 0.8)
        networkManager.submitReport(text: reportText, image: imageData, array: fixedArray) { result in
            DispatchQueue.main.async {
                isSubmitting = false
                switch result {
                case .success:
                    submissionMessage = "신고가 성공적으로 접수되었습니다."
                    reportText = ""
                    selectedImage = nil
                case .failure(let error):
                    submissionMessage = "신고에 실패했습니다: \(error.localizedDescription)"
                }
            }
        }
    }

}


// 이미지피커
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    let sourceType: UIImagePickerController.SourceType
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

// Preview Provider
struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

#Preview {
    ContentView()
}
