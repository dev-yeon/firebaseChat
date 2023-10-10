//  LoginJoinView.swift

import SwiftUI

struct LoginJoinView: View {
    @ObservedObject var viewModel: MainViewModel
    @State var isLoginMode = true
    
    @State var email = ""
    @State var password = ""
    
    @State var profileImage: UIImage?
    @State var isShowingImagePicker =  false // 이미지 피커뷰가 보일꺼냐말꺼냐 선택하는 변수,
    @State var selectedImage: UIImage? // 이미지가 선택되었을때의 이미지 객체
    // 프로파일 이미지 객체와 선택된 이미지 객체를 따로따로 갖고 있어야지
    // 이미지 피커뷰에서 가져온 이미지와 실제 세팅 된 이미지를 구분 할 수가 있다.
    
    @State private var isShowAlert = false
    
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
                                if let profileImage = self.profileImage {
                                    Image(uiImage: profileImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 64, height: 64)
                                        .cornerRadius(32) 
                                    // 64의 절반 값이라 원을 만들어주는거임 설정된 이미지를 보여주게 됨
                                } else {
                                    // nil 일때 띄울 이미지
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 32))
                                        .padding()
                                        .foregroundColor(Color(.label))
                                }
                            }
                            .overlay(RoundedRectangle(cornerRadius: 64)
                                .stroke(Color.gray, lineWidth: 3))
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
                            registerUserAction()
                            print("회원가입 Button Tapped!")
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
            //isPresented
            .alert(isPresented: $isShowAlert) {
                Alert(title: Text("FirebaseChat"), message: Text("프로필 사진이 설정되지 않았습니다."), dismissButton: .default(Text("확인")))
                
                
            }
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
            viewModel.isLoggedIn.toggle()
            // 로그인 하면 홈뷰로 이동하도록,
        }
    }
    
    func registerUserAction() {
        guard let _ = profileImage else {
            print("이미지 선택 안됨")
            self.isShowAlert.toggle()
            return
        }
        
        FirebaseUtil.shared.auth.createUser(withEmail: email, password: password) { authResult, error in if let error = error {
            print("회원가입 중 오류 발생 : \(error.localizedDescription)")
            return
        }
            // 회원가입 성공
            print("회원가입한 사용자: \(authResult?.user.email ?? "")")
            
            // 프로필 이미지 업로드, 다른 뷰로 이동하는 등 추가 작업 수행
            self.uploadImage()
        }
    }
    
    func uploadImage() {
        // 이미지가 선택되어있지 않다면 (nil 이라면, alert를 띄우고, return을 한다.)
        guard let safeProfileImage = profileImage else {
            print("이미지 선택 안됨")
            return
        }
        //파이어베이스 스토리지에 업로드 하려면, 인증된사용자 여야함.
        guard let uid = FirebaseUtil.shared.auth.currentUser?.uid else {
            print("로그인 안됨")
            return
        }
        //스토리지에 저장할 경로 : images 폴더 밑에 uuid 하나 생성하고, jpg 형태로 생성하고프다.
        let imagePath = "images/\(UUID().uuidString).jpg"
        
        uploadImageToStorage(safeProfileImage, path: imagePath) {
            result in
            switch result {
            case .success(let downloadURL):
                print("이미지 업로드 성공: \(downloadURL)")
                // 회원정보 DB에 수록 :  인증 (uid, 이메일, 프로필이미지 경로)
                self.storeUserInformation(profileImageUrl: downloadURL)
            case .failure(let error):
                print("이미지 업로드 실패: \(error.localizedDescription)")
            }
        }
        //이미지 업로드 메소드
        //uploadImageToStorage()
    }
    func storeUserInformation(profileImageUrl: String?) {
        guard let profileImageUrl = profileImageUrl else {
            print("프로필 이미지 경로가 nil입니다.")
            return
        }
        guard let uid = FirebaseUtil.shared.auth.currentUser?.uid else {
            print("로그인 안됨")
            return
        }
        // 현재 로그인한 사용자 계정을 가져오기
        // uid - email - profileimageURL 을 결합한 dictionary 객체를 하나 만들고.
        let userEmail = FirebaseUtil.shared.auth.currentUser?.email ?? ""
        let userInfo: [String: Any] = [
            "uid": uid,
            "email": userEmail,
            "profileImageUrl": profileImageUrl
        ]
        // 컬렉션에 지정, Document(ID)는 UID로 지정, setData 함수를 통해서, Push 해서
        // 데이터를 집어넣도록 하겠다.
        // push 할때 들어가는 파라미터 데이터는 Dictionary (타입) 객체가 될 것이다.
        FirebaseUtil.shared.firestore.collection("users").document(uid).setData(userInfo) { error in
            if let error = error {
            //예외처리 클로저로 ㅃㅐ기
                print("회원 정보 저장 중 오류 발생: \(error.localizedDescription)")
            } else {
                print("회원 정보 저장 성공")
                isLoginMode.toggle()
                //성공후에는 로그인 화면으로 전환하도록 해준다.
            }
        }
    }
    func uploadImageToStorage(_ image: UIImage, path: String, completion: @escaping (Result<String, Error>) -> Void) {
        // 1. 이미지를 Data로 변환
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(.failure(NSError(domain: "ImageConversion", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data"])))
            return
        }
        
        // 2. Firebase 스토리지 참조 생성
        let storageRef = FirebaseUtil.shared.storage.reference().child(path)
        
        // 3. 이미지 데이터 업로드
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                // 오류 발생 시
                completion(.failure(error))
                return
            }
            
            // 4. 다운로드 URL 가져오기
            storageRef.downloadURL { url, error in
                if let error = error {
                    // 오류 발생 시
                    completion(.failure(error))
                    return
                }
               
                if let url = url {
                    completion(.success(url.absoluteString))
                } else {
                    completion(.failure(NSError(domain: "DownloadURL", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get download URL"])))
                }
            }
        }
    }
}//struct LoginJoinView

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
