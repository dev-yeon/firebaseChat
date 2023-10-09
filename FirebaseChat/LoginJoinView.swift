//  LoginJoinView.swift

import SwiftUI

struct LoginJoinView: View {
    @ObservedObject var viewModel: MainViewModel
    @State var isLoginMode = false
    
    @State var email = ""
    @State var password = ""
    
    @State var profileImage: UIImage?
    @State var isShowingImagePicker =  false // 이미지 피커뷰가 보일꺼냐말꺼냐 선택하는 변수,
    @State var selectedImage: UIImage? // 이미지가 선택되었을때의 이미지 객체
    // 프로파일 이미지 객체와 선택된 이미지 객체를 따로따로 갖고 있어야지
    // 이미지 피커뷰에서 가져온 이미지와 실제 세팅 된 이미지를 구분 할 수가 있다.
    

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    
                    if isLoginMode {
                        //로그인화면
                        //입력란
                        Group {
                            TextField("이메일", text: $email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                            SecureField("암호", text: $password)
                        }
                        .padding(12)
                        .background(Color.white)
                        
                        MyButton(title: "로그인", color: .blue) {
                            loginUserAction()
                        }
                        
                        MyButton(title: "회원가입", color: Color(.init(red: 0.5, green: 0.2, blue: 0.9, alpha: 1.0))) {
                            isLoginMode.toggle()
                        }
                    } else {
                        //회원가입 화면
                        
                        //프로필 이미지 설정
                        Button {
                            isShowingImagePicker.toggle()
                        } label: {
                            VStack {
                                // 이미지를 설정할 때의 화면,profileImage 가 if let (구문) 을 통해서, nil 이 아닐때,
                                if let profileImage = self.profileImage {
                                    Image(uiImage: profileImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 64, height: 64)
                                        .cornerRadius(32) // 64의 절반 값이라 원을 만들어주는거임
                                    // 설정된 이미지를 보여주게 됨
                                } else {
                                    // nil 일때 띄울 이미지
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 32))
                                        .padding()
                                        .foregroundColor(Color(.label))
                                }
                            }
                            .overlay(RoundedRectangle(cornerRadius: 64)
                                .stroke(Color.gray, lineWidth: 3)) //선택되면 바뀌어짐 
                        }
                        .sheet(isPresented: $isShowingImagePicker) {
                            ImagePickerView(selectedImage: $profileImage)
                            //isShowingImagePicker 의 변수가 true 이면, 이미지 뷰를 프로파일이미지- selectedImage 에 연결해주는 코드
                        }
                        //입력란
                        Group {
                            TextField("이메일", text: $email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                            SecureField("암호", text: $password)
                        }
                        .padding(12)
                        .background(Color.white)
                        
                        MyButton(title: "회원가입", color: .blue) {
                            print("Button Tapped!")
                        }
                        
                        MyButton(title: "로그인", color: Color(.init(red: 0.5, green: 0.2, blue: 0.9, alpha: 1.0))) {
                            isLoginMode.toggle()
                        }
                    }
                    
                }//VStack
                .padding(16)
            }//ScrollView
            .navigationBarTitle(isLoginMode ? "로그인" : "회원가입")
            .background(Color(.init(gray: 0.1, alpha: 0.1))
                .ignoresSafeArea())
        }//NavigationView
    }//body
    
    func loginUserAction() {
        FirebaseUtil.shared.auth.signIn(withEmail: email, password: password) {authResult, error in
            if let error = error {
                print("로그인 중 오류 발생 : \(error.localizedDescription)")
                return
            }
            // 로그인 성공
            print("로그인한 사용자: \(authResult?.user.email ?? "")")
                        print("로그인한 사용자: \(authResult?.user.uid ?? "" )")
            
            // 다른 뷰로 이동하는 등 추가 작업 수행
        }
    }
    
}//View

struct MyButton: View {
    let title: String // 타이틀
    let color: Color
    let action: () -> Void // 액션 클로저
    
    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                Spacer()
            }
            .background(color)
            .cornerRadius(5)
        }
    }
}

struct LoginJoinView_Previews: PreviewProvider {
    static var previews: some View {
        LoginJoinView(viewModel: MainViewModel())
    }
}
