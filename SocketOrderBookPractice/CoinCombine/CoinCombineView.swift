//
//  CoinCombineView.swift
//  SeSACCombineConcurrency
//
//  Created by Greed on 5/9/24.
//

import SwiftUI
import WidgetKit

//LLVM > LLDB
/*
 1. LSLP
 2. 1차 2차 여행 tmdb 과제 - 컬러 ui 업데이트 > "포폴 +1"
 3. 출시 프로젝트 업데이트 privacy manifest + 위젯
 4. 깃허브 잔디는 항상 잘 채우기
 5. 블로그 미뤄뒀던 거 조금씩 작성
 6. readme..... 쓰기... 하나라도 제대로 써보기 >> dm
 
 */

struct CoinCombineView: View {
    
    @StateObject var viewModel = CoinCombineViewModel_v2()
    
    private var columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 2)
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.output.market, id: \.market) { item in
                        RowView(data: item)
                            .onTapGesture {
                                print(UserDefaults.groupShared.string(forKey: "KoreanName") ?? "데이터 없음")
                                
                                UserDefaults.groupShared.set(item.koreanName, forKey: "KoreanName")
                                UserDefaults.groupShared.set(item.market, forKey: "Market")
                                
                                WidgetCenter.shared.reloadTimelines(ofKind: "GreedStaticWidget")
                                
                                print(UserDefaults.groupShared.string(forKey: "KoreanName") ?? "데이터 없음")
                            }
                    }
                }
            } //ScrollView
            .task {
                viewModel.action(.viewOnAppear)
            }

        } //NavigationStack
    }
    
}

#Preview {
    CoinCombineView()
}
