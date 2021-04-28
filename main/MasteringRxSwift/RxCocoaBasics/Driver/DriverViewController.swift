//
//  Copyright (c) 2019 KxCoding <kky0317@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit
import RxSwift
import RxCocoa


//UI 처리에 특화된 observable, Error는 전달하지 않음
//UI binding을 처리할 때는 driver를 적극적으로 활용하는 것이 코드가 간결해짐

enum ValidationError: Error {
   case notANumber
}

class DriverViewController: UIViewController {
   
   let bag = DisposeBag()
   
   @IBOutlet weak var inputField: UITextField!
   
   @IBOutlet weak var resultLabel: UILabel!
   
   @IBOutlet weak var sendButton: UIButton!
   
   override func viewDidLoad() {
      super.viewDidLoad()
    
    let result = inputField.rx.text.asDriver()
        .flatMapLatest{
            validateText($0)
                //error가 전달되는 시점에 사용될 기본값이나 recovery Observable을 사용할 수 있음
                .asDriver(onErrorJustReturn: false)
        }
      
    //crash가 나는 상황을 해결
//      let result = inputField.rx.text
//        .flatMapLatest {
//            validateText($0)
//                .observeOn(MainScheduler.instance)
//                .catchErrorJustReturn(false) }
//        .share()

      result
         .map { $0 ? "Ok" : "Error" }
        .drive(resultLabel.rx.text)
        //driver를 사용했을 때는 bind메소드 대신 drive메소드를 사용
//         .bind(to: resultLabel.rx.text)
         .disposed(by: bag)

      result
         .map { $0 ? UIColor.blue : UIColor.red }
        .drive(resultLabel.rx.backgroundColor)
//         .bind(to: resultLabel.rx.backgroundColor)
         .disposed(by: bag)

      result
        .drive(sendButton.rx.isEnabled)
//         .bind(to: sendButton.rx.isEnabled)
         .disposed(by: bag)
      
   }
}


func validateText(_ value: String?) -> Observable<Bool> {
   return Observable<Bool>.create { observer in
      print("== \(value ?? "") Sequence Start ==")
      
      defer {
         print("== \(value ?? "") Sequence End ==")
      }
      
      guard let str = value, let _ = Double(str) else {
         observer.onError(ValidationError.notANumber)
         return Disposables.create()
      }
      
      observer.onNext(true)
      observer.onCompleted()
      
      return Disposables.create()
   }
}
