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

/*:
 # withLatestFrom
 */

let bag = DisposeBag()

enum MyError: Error {
   case error
}

let trigger = PublishSubject<Void>()
let data = PublishSubject<String>()

//호출: Trigger observable
//파라미터: Data observable

trigger.withLatestFrom(data)
    .subscribe{print($0)}
    .disposed(by: bag)

// 아직 trigger subject가 next이벤트를 전달하지 않았기 때문에 data subject의 next이벤트는 전달되지 않는다
data.onNext("Hello")

trigger.onNext(())
trigger.onNext(())

//마지막으로 전달된 next이벤트가 구독자에게 전달됨
data.onCompleted()
trigger.onNext(())

//더이상 전달되지 않고 구독자에게 바로 전달됨
data.onError(MyError.error)
trigger.onNext(())

//직접 구독자에게 전달되고 종료됨
trigger.onCompleted()
