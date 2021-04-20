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
 # retry
 */
//observable에서 error가 발생하면 구독을 해제하고 새로운 구독을 시작한다
//새로운 observable을 구독하기 때문에 sequence는 새로 시작함

let bag = DisposeBag()

enum MyError: Error {
   case error
}

var attempts = 1

let source = Observable<Int>.create { observer in
   let currentAttempts = attempts
   print("#\(currentAttempts) START")
   
   if attempts < 3 {
      observer.onError(MyError.error)
      attempts += 1
   }
   
   observer.onNext(1)
   observer.onNext(2)
   observer.onCompleted()
         
   return Disposables.create {
      print("#\(currentAttempts) END")
   }
}

source
    .retry(7)    //없으면 시작하고 error만 전달하고 종료
   .subscribe { print($0) }
   .disposed(by: bag)

//retry 연산자를 붙힌 후 실행해보면 말그대로 조건이 될 때까지 재시도한다는 의미(최대 재시도 횟수를 만들고 구현해야 무한 루프에 빠지지 않음)
//최대 재시도 횟수를 만들 때는 +1을 해서 파라미터로 전달해야 우리가 원하는 재시도 값을 얻을 수 있음

