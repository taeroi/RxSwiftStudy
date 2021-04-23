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
import NSObject_Rx

enum ApiError: Error {
    case badUrl
    case invalidResponse
    case failed(Int)
    case invalidData
}

//Rx를 사용하여 네트워크를 구현하는 방법
//1. Observable 직접 생성
//2. RxCocoa를 통해 구현
//3. github에 있는 라이브러리로 활용

class RxCocoaURLSessionViewController: UIViewController {
    
    @IBOutlet weak var listTableView: UITableView!
    
    let list = BehaviorSubject(value: [Book]())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        list
            .bind(to: listTableView.rx.items(cellIdentifier: "cell")) { row, element, cell in
                cell.textLabel?.text = element.title
                cell.detailTextLabel?.text = element.desc
            }
            .disposed(by: rx.disposeBag)
        
        fetchBookList()
    }
    
    
    func fetchBookList() {
        
        //RxCocoa를 통해 구현
        //이렇게 하면 문자열을 방출하는 observable이 data method가 리턴하는 ovservable로 대체. 서버에서 전달된 데이터가 데이터 형식으로 방출됨
        let response =  Observable.just(booksUrlStr)
            .map{URL(string: $0)!}
            .map{URLRequest(url:$0)}
            .flatMap{URLSession.shared.rx.data(request: $0)}
            .map(BookList.parse(data:))
            .asDriver(onErrorJustReturn: [])

//        let response = Observable<[Book]>.create{ observer in
//
//            guard let url = URL(string: booksUrlStr) else {
//                //error 발생시 error 전달하고 종료되게 구현
//                observer.onError(ApiError.badUrl)
//                return Disposables.create()
//            }
//
//            let session = URLSession.shared
//
//            let task = session.dataTask(with: url) { [weak self] (data, response, error) in
//
//                if let error = error {
//                    observer.onError(error)
//                    return
//                }
//
//                guard let httpResponse = response as? HTTPURLResponse else {
////                    print("Invalid Response")
//                    observer.onError(ApiError.invalidResponse)
//                    return
//                }
//
//                guard (200...299).contains(httpResponse.statusCode) else {
////                    print(httpResponse.statusCode)
//                    observer.onError(ApiError.failed(httpResponse.statusCode))
//                    return
//                }
//
//                guard let data = data else {
////                    fatalError("Invalid Data")
//                    observer.onError(ApiError.invalidData)
//                    return
//                }
//
//                //여기서는 결과를 속성에 저장하는 것이 아니라 next이벤트를 방출하는 코드를 구현
//                do {
//                    let decoder = JSONDecoder()
//                    let bookList = try decoder.decode(BookList.self, from: data)
//
//                    if bookList.code == 200 {
//                        observer.onNext(bookList.list)
//                    } else {
//                        observer.onNext([])
//                    }
//                    observer.onCompleted()
//                } catch {
////                    print(error)
//                    observer.onError(error)
//                }
//            }
//            task.resume()
//
//            return Disposables.create{
//                task.cancel()
//            }
//        }
//        .asDriver(onErrorJustReturn: [])
//
//        response
//            .drive(list)
//            .disposed(by: rx.disposeBag)
//
//        response
//            .map{ _ in false }
//            .startWith(true)
//            .drive(UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
//            .disposed(by: rx.disposeBag)
    }
}
