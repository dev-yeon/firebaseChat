//  LoginJoinView.swift

import SwiftUI

struct LoginJoinView: View {
    @ObservedObject var viewModel: MainViewModel
    @State var isLoginMode = false
    @State var email = ""
    @State var password = ""
    @State var profileImage: UIImage?

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
                            print("Button Tapped!")
                        }
                        
                        MyButton(title: "회원가입", color: Color(.init(red: 0.5, green: 0.2, blue: 0.9, alpha: 1.0))) {
                            isLoginMode.toggle()
                        }
                    } else {
                        //회원가입 화면
                        
                        //프로필 이미지 설정
                        Button {
                            print("Button Tapped!")
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
                                    
                                }else{
                                    // nil 일때 띄울 이미지
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 32))
                                        .padding()
                                        .foregroundColor(Color(.label))
                                }
                            }
                            .overlay(RoundedRectangle(cornerRadius: 64)
                                .stroke(Color.black, lineWidth: 3))
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
    }//View
    
}

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
