//
//  MemoComposeViewController.swift
//  RxMemoTutorial
//
//  Created by 태로고침 on 2021/04/22.
//

import UIKit
import RxSwift
import RxCocoa
import Action
import NSObject_Rx

class MemoComposeViewController: UIViewController, ViewModelBindableType {
    
    var viewModel: MemoComposeViewModel!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func bindViewModel() {
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx_disposeBag)
        
        viewModel.initialText
            .drive(contentTextView.rx.text)
            .disposed(by: rx_disposeBag)
        
        cancelButton.rx.action = viewModel.cancelAction
        
        //더블 탭을 막기 위하여 throttle 사용
        saveButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .withLatestFrom(contentTextView.rx.text.orEmpty)
            .bind(to: viewModel.saveAction.inputs)
            .disposed(by: rx_disposeBag)
        
        //Keyboard Notification - rx로 구현
        let willShowObservable = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .map{ ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as?
                    NSValue)?.cgRectValue.height ?? 0}
        
        let willHideObservable = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .map{noti -> CGFloat in 0}
        
        let keyboardObservable = Observable.merge(willShowObservable,willHideObservable)
            .share()
        
        keyboardObservable
//            .map{[unowned self] height -> UIEdgeInsets in
//                var inset = self.contentTextView.contentInset
//                inset.bottom = height
//                return inset
//            }
            //toContentInset이라는 custom operator로 대체
            .toContentInset(of: contentTextView)
            
//            .subscribe(onNext: {[weak self] height in
//                guard let strongSelf = self else { return }
//
//                var inset = strongSelf.contentTextView.contentInset
//                inset.bottom = height
//
//                var scrollInset = strongSelf.contentTextView.scrollIndicatorInsets
//                scrollInset.bottom = height
//
//                UIView.animate(withDuration: 0.3) {
//                    strongSelf.contentTextView.contentInset = inset
//                }
//            })
            .bind(to: contentTextView.rx.contentInset)
            .disposed(by: rx_disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contentTextView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if contentTextView.isFirstResponder {
            contentTextView.resignFirstResponder()
        }
    }
    
}

//custom observable type 설정
extension ObservableType where Element == CGFloat {
    func toContentInset(of textView: UITextView) -> Observable<UIEdgeInsets> {
        return map {height in
            var inset = textView.contentInset
            inset.bottom = height
            return inset
        }
    }
}

extension Reactive where Base: UITextView {
    var contentInset: Binder<UIEdgeInsets> {
        return Binder(self.base) { textView, inset in
            textView.contentInset = inset
        }
    }
}
