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
 # generate
 */

let disposeBag = DisposeBag()
let red = "🔴"
let blue = "🔵"

//4개의 파라미터를 받는다
// initialState - 시작값을 입력(가장 먼저 방출되는 값)
// condition - 여기서 true를 리턴하는 경우에만 방출
// iterate - 값을 바꾸는 파라미터를 입력(보통 증가, 감소의 파라미터를 입력)

Observable.generate(initialState: 0, condition: {$0 <= 10}, iterate: {$0 + 2})
    .subscribe{ print($0) }
    .disposed(by: disposeBag)

Observable.generate(initialState: 10, condition: {$0 >= 0 }, iterate: {$0 - 2})
    .subscribe{print($0)}
    .disposed(by: disposeBag)

Observable.generate(initialState: red, condition: {$0.count < 15},
                    iterate: {$0.count.isMultiple(of: 2) ? $0 + red : $0 + blue})
    .subscribe{ball in print(ball)}
    .disposed(by: disposeBag)



