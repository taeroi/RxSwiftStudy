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

/*:
 # AsyncSubject
 */

let bag = DisposeBag()

enum MyError: Error {
   case error
}

//이벤트를 전달하는 시점에서 차이가 있음
//subject로 completed가 전달되기 전까지 구독자로 전달하지 않는다
//completed 이벤트가 전달되면 그전까지 전달된 가장 최근의 next이벤트를 구독자로 전달한다

let subject = AsyncSubject<Int>()
subject
    .subscribe{print($0)}
    .disposed(by: bag)

subject.onNext(1)
//아직 completed 이벤트가 전달되지 않았으므로 구독자에게 이벤트가 전달되지 않는다

subject.onNext(2)
subject.onNext(3)
//마찬가지로 아직 completed 이벤트가 전달되지 않았으므로 구독자에게 이벤트가 전달되지 않는다

subject.onCompleted()
//completed 이벤트가 실행된 시점을 기준으로 마지막 next이벤트(3)만 전달하고 종료된다

//subject.onError(MyError.error)
// error 이벤트가 전달되면 아무 이벤트도 구독자로 전달하지 않고 종료
