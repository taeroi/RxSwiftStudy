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
 # throttle
 */
//첫번째 파라미터는 주기, 세번째 파라미터는 스케줄러이다


let disposeBag = DisposeBag()

let buttonTap = Observable<String>.create { observer in
   DispatchQueue.global().async {
      for i in 1...10 {
         observer.onNext("Tap \(i)")
         Thread.sleep(forTimeInterval: 0.3)
      }
      
      Thread.sleep(forTimeInterval: 1)
      
      for i in 11...20 {
         observer.onNext("Tap \(i)")
         Thread.sleep(forTimeInterval: 0.5)
      }
      
      observer.onCompleted()
   }
   
   return Disposables.create()
}


buttonTap
    .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
   .subscribe { print($0) }
   .disposed(by: disposeBag)

//throttle: next이벤트를 지정된 주기마다 구독자에게 전달(보통 delegate패턴에 이용)
//next: 이벤트가 전달된 다음, 지정된 시간이 경과할 때까지 다른 이벤트가 전달되지 않는다면 마지막으로 방출된 이벤트를 구독자에게 전달(주로 검색기능을 다룰때 사용, 검색창(사용자가 짧은 시간동안 검색을 한다고 했을 때 계속 네트워크와 연결하면 불필요한 리소스 낭비가 크다 so, 이때 이걸 많이 쓴다 )
//: [Next](@next)
