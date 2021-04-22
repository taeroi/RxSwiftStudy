//
//  MemoListViewModel.swift
//  RxMemoTutorial
//
//  Created by 태로고침 on 2021/04/22.
//

import Foundation
import RxSwift
import RxCocoa

//View Model에는 두 가지(의존성 주입 생산자, binding에 사용되는 속성과 메서드가 저장
//CommonViewModel 상속
class MemoListViewModel: CommonViewModel {
    var memoList: Observable<[Memo]>{
        //이 속성은 메모 리스트를 방출해야함
        return storage.memoList()
    }
}
