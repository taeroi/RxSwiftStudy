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
 # just
 */

let disposeBag = DisposeBag()
let element = "😀"

// 1개의 항목을 방출하는 Observable을 생성한다
// 1개의 element를 파라미터로 받아서 Observable을 리턴한다

//from 연산자와 조금 헷갈릴 수도 있는데 just연산자는 파라미터를 그대로 방출한다
Observable.just(element)
   .subscribe { event in print(event) }
   .disposed(by: disposeBag)

Observable.just([1, 2, 3])
   .subscribe { event in print(event) }
   .disposed(by: disposeBag)

