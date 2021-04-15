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
 # create
 */

let disposeBag = DisposeBag()

enum MyError: Error {
   case error
}

// 앞서 공부한 연산자는 parameters를 방출하고 completed가 전달되면 중지됨
// Observable이 동작하는 방식을 직접 구현하고자 할 때는 create연산자를 사용하면 됨

Observable<String>.create{ (observer) -> Disposable in
    guard let url = URL(string:"https://www.apple.com")
    else {
        observer.onError(MyError.error)
        return Disposables.create()
        //여기서 Disposable이 아닌 Disposables로 사용해야 함을 꼭 기억
    }
    
    guard let html = try? String(contentsOf: url, encoding: .utf8)
    else {
        observer.onError(MyError.error)
        return Disposables.create()
    }
    //요소를 방출할 때는 onNext 메소드를 사용하고 파라미터로 방출할 요소를 선택
    observer.onNext(html)
    
    //종료시키기 위해서는 completed나 error 이벤트를 호출해야한다
    //so, onNext를 통해 파라미터를 구독자에게 전달하고자 할 때는 completd나 error 이벤트가 발생하기 전에 호출해야 한다
    observer.onCompleted()
    
    return Disposables.create()
}
.subscribe{print($0)}
.disposed(by: disposeBag)






