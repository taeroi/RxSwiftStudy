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
 # PublishSubject
 */
//subject를 이해하기 위해서 Observable과 Observer에 대한 정확한 이해가 필수적
//subject는 다른 observable의 이벤트를 받아서 구독자에게 전달할 수 있다
//observable인 동시에 observer가 되는 셈이다

//publishRelay는 publishSubject를 랩핑한 것
//behaviorRelay
//realy는 일반적인 subeject와 달리 next이벤트만 받음 나머지는 받지 않음-> 주로 종료없이 계속 전달되는 event sequence를 전달할 때 사용됨

let disposeBag = DisposeBag()

enum MyError: Error {
   case error
}

//pubishSubject는 subject를 observer에게 전달되는 가장 기본적인 subject이다

//생성자를 만들때는 파라미터를 전달하지 않는다(내부에 아무런 이벤트가 저장되어 있지 않음)
let subject = PublishSubject<String>()

//subject 역시 observer이기 때문에 onNext이벤트를 전달할 수 있음
subject.onNext("Hello") // 여기까지만 하면 구독하는 옵저버가 없기 때문에 세팅만 된 것

let o1 = subject.subscribe{ print(">>1", $0)}
o1.disposed(by: disposeBag)
//여기까지는 아무런 콘솔도 찍히지 않음 why? publish subject는 구독 이후에 전달되는 새로운 이벤트만 구독자로 전달하기 때문
//so 이전에 전달한 것은 전달되지 않음

subject.onNext("RxSwift")
//구독 이후에 전달되는 이 이벤트는 출력된다.
//결과: >>1 next(RxSwift)

let o2 = subject.subscribe{ print(">>2",$0)}
o2.disposed(by: disposeBag)
subject.onNext("Subject")
// 두 구독자에게 모두 전달됨

//두 구독자에게 모두 completed가 전달됨(error도 마찬가지)
subject.onCompleted()
//subject.onError(MyError.error)

//새로운 구독자에게도 completed가 바로 전달됨(error도 마찬가지)
//더이상 next이벤트가 전달되지 않기 때문에 바로 completed를 전달하여 종료한다
let o3 = subject.subscribe{print(">>3", $0)}
o3.disposed(by: disposeBag)

//-> 이벤트가 바로 사라지는 것이 문제라면 behaivor subject를 이용하면 된다
