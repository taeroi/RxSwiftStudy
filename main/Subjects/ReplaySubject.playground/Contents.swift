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
//두 개 이상의 event를 저장해두고 새로운 구독자에게 전달하고자 할 때 사용

let disposeBag = DisposeBag()

enum MyError: Error {
   case error
}

//이전 Subjects와는 다르게 create메서드로 생성한다 (버퍼사이즈 생성 - 3개의 이벤트를 전달할 수 있는 저장소)
let rs = ReplaySubject<Int>.create(bufferSize: 3)

(1...10).forEach {rs.onNext($0)}

rs.subscribe {print("Observer 1>>", $0)}
    .disposed(by: disposeBag)
//버퍼에 마지막에 전달된 3개가 저장되므로 next 이벤트에는 8,9,10이 저장되고 observer로 전달

rs.subscribe {print("Observer 2>>",$0)}
    .disposed(by: disposeBag)

rs.onNext(11)

//새로운 구독자 생성
rs.subscribe {print("Observer 3>>",$0)}
    .disposed(by: disposeBag)
// 출력결과는 next 이벤트로 받은것 + 버퍼에 마지막에 전달된 것 -> 따라서 9,10,11이 버퍼에 저장되고 전달됨

// completed,error는 모든 구독자에게 전달되고 새로운 구독자의 이벤트 실행 후 종료됨
rs.onCompleted()

//버퍼에 저장되어 있는 이벤트를 전달하고 종료
rs.subscribe {print("Observer 4>>",$0)}
    .disposed(by: disposeBag)
