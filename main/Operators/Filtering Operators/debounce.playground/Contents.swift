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
 # debounce
 */

// throttle연산자와의 공통점: 짧은 시간동안 반복적으로 방출되는 이벤트를 제외함
// 동작은 굉장히 다르므로 주의

//파라미터로 타이머와 스케줄러를 받는다

let disposeBag = DisposeBag()

let buttonTap = Observable<String>.create { observer in
   DispatchQueue.global().async {
      for i in 1...10 {
         observer.onNext("Tap \(i)")
         Thread.sleep(forTimeInterval: 0.3)
      }
    //0.3초마다 next이벤트가 10번 전달되고
      
      Thread.sleep(forTimeInterval: 1)
      //1초 쉬었다가
    
      for i in 11...20 {
         observer.onNext("Tap \(i)")
         Thread.sleep(forTimeInterval: 0.5)
      }
    //0.5초마다 next이벤트를 10번 전달한다
      
      observer.onCompleted()
   }
   
   return Disposables.create {
      
   }
}

//타이머가 만료되기까지 대기한다 이때 전달되는 next이벤트는 전달되지 않는다.
//1초 쉬는 시간과 타이머가 시간적으로 동일하기 때문에 마지막으로 전달된 10,20이 전달된다
buttonTap
    .debounce(.milliseconds(1000), scheduler: MainScheduler.instance)
   .subscribe { print($0) }
   .disposed(by: disposeBag)


