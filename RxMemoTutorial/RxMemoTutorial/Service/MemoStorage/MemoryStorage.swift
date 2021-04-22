//
//  MemoryStorage.swift
//  RxMemoTutorial
//
//  Created by 태로고침 on 2021/04/22.
//

import Foundation
import RxSwift

//메모리에 메모를 저장하는 class
class MemoStorage: MemoStorageType {
    
    private var list = [
        //dummy data
        Memo(content: "Hello, RxSwift", insertDate: Date().addingTimeInterval(-10)),
        Memo(content: "Park Tae Hwan", insertDate: Date().addingTimeInterval(-20))
    ]
    
    private lazy var sectionModel = MemoSectionModel(model: 0, items: list)
    
    //기본값을 list 배열로 선언하기 위해 lazy로 선언, 외부에서 직접 접근할 일이 없기 때문에 private으로 선언
    private lazy var store = BehaviorSubject<[MemoSectionModel]>(value: [sectionModel])
    
    @discardableResult
    func createMemo(content: String) -> Observable<Memo> {
        let memo = Memo(content: content)
        sectionModel.items.insert(memo, at: 0)
        
        store.onNext([sectionModel])
        
        return Observable.just(memo)
    }
    
    @discardableResult
    func memoList() -> Observable<[MemoSectionModel]> {
        return store
    }
    
    @discardableResult
    func update(memo: Memo, content: String) -> Observable<Memo> {
        let updated = Memo(original: memo, updatedContent: content)
        
        if let index = sectionModel.items.firstIndex(where: {$0 == memo}){
            sectionModel.items.remove(at: index)
            sectionModel.items.insert(updated, at: index)
        }
        
        store.onNext([sectionModel])
        
        return Observable.just(updated)
    }
    
    @discardableResult
    func delete(memo: Memo) -> Observable<Memo> {
        if let index = sectionModel.items.firstIndex(where: {$0 == memo}) {
            sectionModel.items.remove(at: index)
        }
        
        store.onNext([sectionModel])
        
        return Observable.just(memo)
    }
    
    
}
