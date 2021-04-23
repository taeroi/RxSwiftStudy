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
 # Disposables
 */
//disposable은 리소스 해제나 실행 취소에 사용됨
//observable이 error나 completed를 전달하면 리소스를 자동으로 해지한다

let subscirption1 = Observable.from([1,2,3])
    .subscribe(
        onNext:{ elem in
            print("Next",elem)
        },
        onError: {error in
            print("Error", error)
        },
        onCompleted: {
            print("Completed")
        },
        onDisposed: {
            print("Disposed")
        })

subscirption1.dispose()

//위에서 하는 것보다 이렇게 DisposeBag()을 사용하는 방식을 권장함
//ARC에서 auto release pool과 같은 개념으로 생각하면 됨
var bag = DisposeBag()

Observable.from([1,2,3])
    .subscribe {
        print($0)
    }
    .disposed(by: bag)

let subscription2 = Observable<Int>.interval(.seconds(1),
                                             scheduler: MainScheduler.instance)
    .subscribe(onNext:{ elem in
        print("Next",elem)
    },
    onError: {error in
        print("Error", error)
    },
    onCompleted: {
        print("Completed")
    },
    onDisposed: {
        print("Disposed")
    })

//3초 뒤에 dispose 메소드를 호출
//호출될 때 하는 즉시 모든 리소스가 해제되기 때문에 더이상 이벤트가 전달되지 않음
DispatchQueue.main.asyncAfter(deadline: .now() + 3){
    
    subscription2.dispose()
    
}













