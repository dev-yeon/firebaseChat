//
//  MainView.swift
//  FirebaseChat
//
//  Created by yeon on 10/7/23.
//

import SwiftUI
//뷰 모델이 데이터와 논리, 비즈니스 로직을 갖고있음 
class MainViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
}

struct MainView: View {
    @StateObject var viewModel = MainViewModel()
    
    var body: some View {
        if viewModel.isLoggedIn {
            HomeView(viewModel: viewModel)
        } else {
            LoginJoinView(viewModel: viewModel)
        }
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

/*
 @StateObject - MainView
  자기(안)에서 사용할때는 StateObject 를 사용해서 뷰모델을 가져와서 링크를 하면 됨,
 
 @ObservedObject - LoginJoinView, - HomeView
 LoginJoinView,HomeView 입장에서는 자기가 뷰 모델을 가지고있는것이 아니니까,
 Observed - 감시, 감지하고있는 (참조되고있는) 오브젝트이기 때문에,
 내 안에 가지고 있지 않고, 바깥에 있는걸 참조해서, 지속적으로 감시(감지)하고있는 오브젝트다
 그래서 ObservedObject 를 이용해서, 부 모델에 대한 데이터의 참조가 가능하다.
 
 
 */
