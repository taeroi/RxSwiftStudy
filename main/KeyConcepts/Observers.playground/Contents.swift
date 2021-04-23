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
 # Observers
 */
//실제로 이벤트가 전달되는 시점은 observer가 구독을 하는 시점
//subscribe 메소드는 observer와 observable을 연결한다 -> rx에서 가장 주요하고 필수적인 작업

let o1 = Observable<Int>.create { (observer) -> Disposable in
    observer.on(.next(0))
    observer.onNext(1)

    observer.onCompleted()

    return Disposables.create()
}
//let o1 = Observable.from([0,1])

o1.subscribe {
    //observable은 여러 이벤트를 한 번에 전달하지 않음
    //start #1 end / start #2 end -> 이런 식으로 이벤트가 전달된다
    print("==start==")
    print($0)

    //데이텀만 꺼내고 싶다면 element를 이용한 옵셔널 바인딩이 필요함
    if let elem = $0.element {
        print(elem)
    }
    print("==end==")
}

//실제 이벤트가 전달되는 시점은 구독자가 생기는 시점. 클로저로 연결됨
o1.subscribe(onNext: {elem in
    print("elem:",elem)
})











