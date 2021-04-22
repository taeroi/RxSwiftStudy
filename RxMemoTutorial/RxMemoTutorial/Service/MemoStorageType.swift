//
//  MemoStorageType.swift
//  RxMemoTutorial
//
//  Created by 태로고침 on 2021/04/22.
//

import Foundation
import RxSwift

// 기본적인 CRUD를 처리하는 메서드를 생성
protocol MemoStorageType {
    
    //구독자가 원하는 방식으로 처리하게 됨, 근데 작업결과가 필요없는 경우도 있을 것이기 때문에 discardableResult를 추가
    @discardableResult
    func createMemo(content:String) -> Observable<Memo>
    
    @discardableResult
    func memoList() -> Observable<[Memo]>
    
    @discardableResult
    func update(memo: Memo, content: String) -> Observable<Memo>
    
    @discardableResult
    func delete(memo: Memo) -> Observable<Memo>
}
