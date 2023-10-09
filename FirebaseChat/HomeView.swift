//
//  HomeView.swift
//  FirebaseChat
//
//  Created by yeon on 10/7/23.
//

import SwiftUI

struct HomeView: View {
    // 홈 뷰 쪽에서 매개변수로 viewModle을 집어넣게 된다.
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        // 화면전환을 위한 구조체,
        NavigationStack {
            VStack {
                //홈 화면 UI 구성
                Text("홈 뷰")
                Divider()
                Button("로그아웃") {
                    viewModel.isLoggedIn = false
                }
            }
        }
    }
}
//뷰 모델이 지정되어야 하는데, 지정되지 않아 생기는 오류
struct HomeView_previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: MainViewModel())
    }
}
