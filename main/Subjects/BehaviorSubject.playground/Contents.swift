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
 # BehaviorSubject
 */
//publish subject와 유사하게 동작하지만 생성하는 방식에서 차이가 있음


let disposeBag = DisposeBag()

enum MyError: Error {
   case error
}

// publish subject는 내부에 이벤트가 저장되지 않은 상태로 저장.
//때문에 subject로 이벤트가 전달되기 전까지 구독자로 이벤트가 전달되지 않는다
let p = PublishSubject<Int>()
p.subscribe{print("PublishedSubject >>",$0)}
    .disposed(by: disposeBag)

//BehaviorSubject는 한 개의 value를 전달한다
//내부에 next 이벤트가 저장되고 새로운 구독자가 추가되면 저장된 next 이벤트가 바로 전달된다
let b = BehaviorSubject<Int>(value: 0) //이렇게 파라미터로 하나의 값을 전달한다
b.subscribe{print("BehaviorSubject >>",$0)}
    .disposed(by: disposeBag)

//observer로 next 이벤트로 전달된다
b.onNext(1)

//이 시점에서 새로운 observer가 추가되면 behavior는 어떤 이벤트를 전달할까?
//새로운 구독자가 추가되면 기존에 저장되어 있던 이벤트를 전달한다
//결과적으로 가장 최신 next 이벤트를 observer로 전달한다
b.subscribe{print("BehaviorSubject2 >>",$0)}
    .disposed(by: disposeBag)

b.onCompleted()
//b.onError(MyError.error)

//더이상 next이벤트를 전달하지 않고 completed 즉시 전달되고 종료된다(error 이벤트도 마찬가지)
b.subscribe{print("BehaviorSubject3 >>",$0)}
    .disposed(by: disposeBag)
