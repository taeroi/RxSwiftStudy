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
 # ReplaySubject
 */

let disposeBag = DisposeBag()

enum MyError: Error {
   case error
}

//이전 Subjects와는 다르게 create로 생성한다 (버퍼사이즈 생성)
let rs = ReplaySubject<Int>.create(bufferSize: 3)

(1...10).forEach {rs.onNext($0)}

rs.subscribe {print("Observer 1>>", $0)}
    .disposed(by: disposeBag)
// 출력결과는 버퍼에 마지막에 전달된 3개가 저장되므로 next 이벤트에는 8,9,10이 저장됨

rs.subscribe {print("Observer 2>>",$0)}
    .disposed(by: disposeBag)

rs.onNext(11)

//새로운 구독자 생성
rs.subscribe {print("Observer 3>>",$0)}
    .disposed(by: disposeBag)
// 출력결과는 next 이벤트로 받은것 + 버퍼에 마지막에 전달된 것

// completed,error 이벤트는 새로운 구독자의 이벤트 실행 후 종료됨
rs.onCompleted()


rs.subscribe {print("Observer 4>>",$0)}
    .disposed(by: disposeBag)
