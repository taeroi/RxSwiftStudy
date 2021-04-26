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
 # Scheduler
 */

//스레드 처리 할때는 gcd 필요 -> rx에서는 스케줄러를 사용
//context를 추상화 하는 것. row level이 될 수도, dispatch queue가 될 수도 있다

//네트워크 같은거 -> gcd에서는 global로 사용, rx에서는 background에서 사용
//내부적으로 gcd와 비슷하게 사용

//별도로 지정하지 않으면 serial scheduler가 됨
//종류는 serial, concurrent가 있음

//이외에도 unit TEST에 사용되는 test scheduler를 사용할 수도 있음

// 첫 번째는 Observable이 사용되는 시점을 파악하는 것
//

let bag = DisposeBag()

let backgroundScheduler = ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global())

Observable.of(1, 2, 3, 4, 5, 6, 7, 8, 9)
   .filter { num -> Bool in
      print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> filter")
      return num.isMultiple(of: 2)
   }
    .observeOn(backgroundScheduler)
    // 이렇게 observeOn메서드로 지정하고 보면 map 연산자는 background thread에서 돌아감
   .map { num -> Int in
      print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> map")
      return num * 2
   }
    // 이 상태에서 실행하면 observable이 어떤 요소를 생성하고 방출하는지 알 수만 있다, 콘솔에는 찍히지 않음

    .subscribeOn(MainScheduler.instance) //main scheduler는 instance 속성으로 쉽게 얻을 수 있음 (observable이 시작되는 시점에 어떤 스케줄러를 사용할지 지정하는 것 - subscribe 연산자에는 영향을 주지 않음)
    .observeOn(MainScheduler.instance) //main scheduler에서 실행하기 위해서 observeOn 연산자로 main scheduler를 지정한다
    .subscribe{
        print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> subscribe")
        print($0)
    }
    .disposed(by: bag)
// 이렇게 해야 observable이 생성되고 실행됨
// 모든 코드는 main thread에서 실행
