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

//binding은 여러가지 의미로 사용되지만 여기서는 데이터를 UI로 구현하는 것이 목표
//binding에는 데이터 생산자(observable)와 소비자(UI component)가 있음
//데이터 생산자 -> 데이터 소비자
//next이벤트, completed만 보내고 error는 전달되지 않음(Binder는 메인 스레드에서 실행되는데 error가 전달되게 되면 앱이 크래쉬나기 때문)

class BindingRxCocoaViewController: UIViewController {
    
    @IBOutlet weak var valueLabel: UILabel!
    
    @IBOutlet weak var valueField: UITextField!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        valueLabel.text = ""
        valueField.becomeFirstResponder()
        
//        valueField.rx.text
//            .observeOn(MainScheduler.instance)
//            .subscribe(onNext: {[weak self] str  in
//                DispatchQueue.main.async {  //UI component이기 때문에 main thread에서 실행되기 때문에 background thread로 실행되는 것에 대해 문제가 생길 수도 있음 -> 1.gcd로 해결 2.observeOn으로 해결
//                self?.valueLabel.text = str
//                }
//            })
//            .disposed(by: disposeBag)
        
        //bind연산자를 통해 이렇게 손쉽게 사용할 수 있음
        //observable이 방출한 이벤트를 observer에게 전달함
        //여기서는 결과적으로 valueField에 있는 text와 valueLabel의 text가 바인딩되어 결과적으로 UI에 항상 같은 값으로 나타남
        valueField.rx.text
            .bind(to: valueLabel.rx.text)
            .disposed(by: disposeBag)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        valueField.resignFirstResponder()
    }
}
