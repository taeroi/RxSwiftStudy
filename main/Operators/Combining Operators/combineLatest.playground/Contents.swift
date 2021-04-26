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
 # combineLatest
 */

let bag = DisposeBag()

enum MyError: Error {
   case error
}

let greetings = BehaviorSubject<String>(value: "")
let languages = BehaviorSubject<String>(value: "")

//공식 홈페이지의 마블다이어그램을 보며 공부하면 이해가 쉬울것

Observable.combineLatest(greetings,languages){ lhs, rhs -> String in
    return "\(lhs) \(rhs)"
}
.subscribe{print($0)}
.disposed(by: bag)


greetings.onNext("Hello")
languages.onNext("World!")

greetings.onNext("Hi")
languages.onNext("SwiftUI!")

greetings.onCompleted()
languages.onNext("RxSwift")

//이 시점에 구독자에게 completed가 전달됨
//만약 error가 전달되면 구독자에게 그 즉시 전달된다
languages.onCompleted()
