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
 # switchLatest
 */

let bag = DisposeBag()

enum MyError: Error {
   case error
}

let a = PublishSubject<String>()
let b = PublishSubject<String>()

//가장 최근 observable이 방출하는 이벤트를 구독자에게 전달 - 어떤 observable이 가장 최근의 것인지 파악하는 것이 중요

//문자열을 방출하는 observable을 방출하는 subject
let source = PublishSubject<Observable<String>>()

source
    .switchLatest()
    .subscribe{print($0)}
    .disposed(by: bag)

//아직 a,b와 source subject와 연관이 없다 - 구독자로 전달하는게 없다
a.onNext("1")
b.onNext("b")

source.onNext(a)
a.onNext("2")
b.onNext("b")
//b subject는 최신 observalbe이 아니기 때문에 전달되지 않음

//b subject가 최신이 되어서 b subject가 전달됨
source.onNext(b)
a.onNext("3")
b.onNext("c")

//전달되지 않음
//a.onCompleted()
//b.onCompleted()

//source로 completed해야 구독자로 전달됨
//source.onCompleted()

//a로 error를 전달하면 구독자로 전달되지 않음 - 최신 observable이 아니기 때문
a.onError(MyError.error)
b.onError(MyError.error)
