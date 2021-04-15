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

Observable.from([0,1])

let subscirption1 = Observable.from([1,2,3])
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

subscirption1.dispose()

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

DispatchQueue.main.asyncAfter(deadline: .now() + 3){

 subscription2.dispose()

}













