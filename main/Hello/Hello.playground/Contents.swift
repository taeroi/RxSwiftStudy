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


//Observable, Subject, Drive 개념 중요
//함수 지향 프로그래밍, 프로토콜 지향 프로그래밍의 개념 중요
//Reactive 언어를 Swift로 구현한 것이다.
//github Rx에 있는 내용을 잘 보고 이해하며 스터디
//전통적인 delegate 패턴을 사용하지 않고 사용할 수 있음
//가장 큰 장점은 Rx를 사용하면 직관적이고 단순한 코드로 구현할 수 있다는 것

let disposeBag = DisposeBag()

Observable.just("Hello, RxSwift")
    .subscribe { print($0)}
    .disposed(by: disposeBag)

//a,b를 바꾼다고 a+b가 바뀌지 않는다, 반응형으로 프로그래밍 할 수는 있지만 코드가 복잡해진다
//var a = 1
//var b = 2
//a+b

//a = 12

let a = BehaviorSubject(value: 1)
let b = BehaviorSubject(value: 2)

Observable.combineLatest(a,b) {$0 + $1}
    .subscribe(onNext: {print($0)})
    .disposed(by: disposeBag)

a.onNext(12)

