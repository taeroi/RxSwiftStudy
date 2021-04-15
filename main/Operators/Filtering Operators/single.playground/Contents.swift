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
 # single
 */

let disposeBag = DisposeBag()
let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

//원본 Observable에서 첫 번째 요소만 방출하거나 조건에 맞는 요소를 방출함

Observable.just(1)
    .single()
    .subscribe{print($0)}
    .disposed(by: disposeBag)
//결과: 첫 번째 요소만 전달된다

Observable.from(numbers)
    .single()
    .subscribe{print($0)}
    .disposed(by: disposeBag)
//결과: sequence에 2개 이상의 요소가 방출되고자 해서 error 발생

//single연산자는 파라미터가 없는 연산자와 predicate를 파라미터로 받는 연산자 이렇게 2가지 종류가 있다

//completed 이벤트가 발생할 때까지 기다리면서 하나의 요소가 방출되는 것을 보장
Observable.from(numbers)
    .single{$0 == 3}
    .subscribe{print($0)}
    .disposed(by: disposeBag)

let subject = PublishSubject<Int>()
subject.single()
    .subscribe{print($0)}
    .disposed(by: disposeBag)

subject.onNext(100)
