//
//  MemoDetailViewModel.swift
//  RxMemoTutorial
//
//  Created by 태로고침 on 2021/04/22.
//

import Foundation
import RxSwift
import RxCocoa
import Action

class MemoDetailViewModel: CommonViewModel {
    let memo: Memo
    
    private var formatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "Ko_kr")
        f.dateStyle = .medium
        f.timeStyle = .medium
        return f
    }()
    
    //메모 내용은 tableview에 표시됨(첫 번째 셀에는 메모 내용, 두 번째 셀에는 날짜가 표시됨)
    //내용을 표현할 때는 observable 바인딩하고 2개이기 때문에 이렇게 문자열 배열을 방출
    //그냥 observable로도 가능한데, why behavior subject? 메모 편집 후 다시 돌아오면 새로운 내용이 보여야 함(갱신되어야 함)
    var contents: BehaviorSubject<[String]>
    
    init(memo: Memo, title: String, sceneCoordinator: SceneCoordinatorType, storage: MemoStorageType) {
        self.memo = memo
        
        contents = BehaviorSubject<[String]>(value: [
            memo.content,
            formatter.string(from: memo.insertDate)
        ])
        
        super.init(title: title, sceneCoordinator: sceneCoordinator, storage: storage)
    }
    
//    lazy var popAction = CocoaAction { [unowned self] in
//        return self.sceneCoordinator.close(animated: true).asObservable().map{_ in}
//    }
    
    func performUpdate(memo: Memo) -> Action<String,Void> {
        return Action { input in
            self.storage.update(memo: memo, content: input)
                .subscribe(onNext: { updated in
                    self.contents.onNext([
                        updated.content,
                        self.formatter.string(from: updated.insertDate)
                    ])
                })
                .disposed(by: self.rx_disposeBag)
            
            return Observable.empty()
        }
    }
    
    func makeEditAction() -> CocoaAction {
        return CocoaAction{ _ in
            let composeViewModel = MemoComposeViewModel(title: "Edit", content: self.memo.content, sceneCoordinator: self.sceneCoordinator, storage: self.storage, saveAction: self.performUpdate(memo: self.memo))
            
            let composeScene = Scene.compose(composeViewModel)
            
            return self.sceneCoordinator.transition(to: composeScene, using: .modal, animated: true)
                .asObservable().map{_ in}
        }
    }
}
