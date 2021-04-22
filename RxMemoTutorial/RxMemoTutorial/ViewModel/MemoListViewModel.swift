//
//  MemoListViewModel.swift
//  RxMemoTutorial
//
//  Created by 태로고침 on 2021/04/22.
//

import UIKit
import RxSwift
import RxCocoa
import Action
import RxDataSources

typealias MemoSectionModel =  AnimatableSectionModel<Int, Memo>

//View Model에는 두 가지(의존성 주입 생산자, binding에 사용되는 속성과 메서드가 저장
//CommonViewModel 상속
class MemoListViewModel: CommonViewModel {
    //    var memoList: Observable<[Memo]>{
    //        //이 속성은 메모 리스트를 방출해야함
    //        return storage.memoList()
    //    }
    
    let dataSource: RxTableViewSectionedAnimatedDataSource<MemoSectionModel> = {
        let ds = RxTableViewSectionedAnimatedDataSource<MemoSectionModel>(configureCell: {
            (dataSource, tableView, indexPath, memo) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = memo.content
            return cell
        })
        
        ds.canEditRowAtIndexPath = {_, _ in return true}
        return ds
    }()
    
    var memoList: Observable<[MemoSectionModel]>{
        return storage.memoList()
    }
    
    //메모를 생성
    func performUpdate(memo: Memo) -> Action<String,Void> {
        return Action { input in
            return self.storage.update(memo: memo, content: input).map { _ in}
        }
    }
    
    //취소
    func performCancel(memo: Memo) -> CocoaAction {
        return Action{
            return self.storage.delete(memo: memo).map { _ in}
        }
    }
    
    func makeCreateAction() -> CocoaAction {
        return CocoaAction{ _ in
            return self.storage.createMemo(content: "")
                .flatMap{memo -> Observable<Void> in
                    //여기서 viewModel 만들기
                    let composeViewModel = MemoComposeViewModel(title: "New",
                                                                sceneCoordinator: self.sceneCoordinator,
                                                                storage: self.storage,
                                                                saveAction: self.performUpdate(memo: memo),
                                                                cancelAction: self.performCancel(memo: memo))
                    let composeScene = Scene.compose(composeViewModel)
                    //map 연산자로 void 형식을 리턴하는 형식으로 바꿔주어야 함
                    return self.sceneCoordinator.transition(to: composeScene, using: .modal, animated: true).asObservable().map{ _ in}
                }
        }
    }
    
    //메소드로 구현해도 좋지만 이번에는 속성 형태로 구현
    lazy var detailAction: Action<Memo, Void> = {
        return Action { memo in
            let detailViewModel = MemoDetailViewModel(memo: memo,
                                                      title: "Detail",
                                                      sceneCoordinator: self.sceneCoordinator,
                                                      storage: self.storage)
            let detailScene = Scene.detail(detailViewModel)
            
            return self.sceneCoordinator.transition(to: detailScene, using: .push, animated: true).asObservable().map {_ in}
        }
    }()
    
    lazy var deleteAction: Action<Memo, Swift.Never> = {
        return Action {memo in
            return self.storage.delete(memo: memo).ignoreElements()
        }
    }()
    
    //    lazy var popAction = CocoaAction { [unowned self] in
    //        return self.sceneCoordinator.close(animated: true).asObservable().map{_ in}
    //    }
}
