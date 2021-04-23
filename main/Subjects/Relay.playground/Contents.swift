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
import RxCocoa

/*:
 # Relay
 */

let bag = DisposeBag()

//두가지 relay를 제공한다
//relay는 subject를 래핑하고 있다 (publishRelay, BehaviorRelay)

//가장 큰 차이는 relay는 구독자로 Next이벤트만 전달함(Completed,Error는 전달되지 않음) -> so, UI를 만들때 주로 사용
//앞에서 공부한 subject와 달리 구독자가 disposed 되기 전까지 종료되지 않는다 - so, 주로 UI 이벤트를 처리하는데 사용된다
//RxCocoa 프레임워크를 통해 제공된다

let prelay = PublishRelay<Int>()
prelay.subscribe{print("1:",$0)}
    .disposed(by: bag)

//relay는 next가 아닌 accept메소드로 이벤트를 전달한다
prelay.accept(1)


let brelay = BehaviorRelay(value: 1)
brelay.accept(2)

brelay.subscribe{print("2:",$0)}
.disposed(by: bag)

// 3을 저장하면 바로 구독자에게 전달됨
// 만약 값을 바꾸고 싶다면 accept 이벤트를 사용해야 한다
brelay.accept(3)

// behaviorRelay는 value를 파라미터로 받는데 이는 바꾸지 못하고 읽기 전용
print("저장되어 있는 값: \(brelay.value)")
