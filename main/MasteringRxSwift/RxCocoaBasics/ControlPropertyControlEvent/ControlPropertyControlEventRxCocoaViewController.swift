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

//Traits는 UI에 특화된 observable이다. 데이터 생산자 역할을 한다
//모든 작업은 main thread에서 실행된다
//traits는 error를 전달하지 않는다(UI가 항상 올바른 업데이트가 되게함)
//traits를 구독하는 모든 구독자는 동일한 시퀀스를 공유한다 - 일반 observable에서 share연산자를 사용한 것과 동일한 효과
//traits는 옵션이다(필수는 아님, 코드가 짧아질 수 있음, UI code를 더 좋게 작성할 수 있음)

class ControlPropertyControlEventRxCocoaViewController: UIViewController {
    
    let bag = DisposeBag()
    
    @IBOutlet weak var colorView: UIView!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    @IBOutlet weak var redComponentLabel: UILabel!
    @IBOutlet weak var greenComponentLabel: UILabel!
    @IBOutlet weak var blueComponentLabel: UILabel!
    
    @IBOutlet weak var resetButton: UIButton!
    
    private func updateComponentLabel() {
        redComponentLabel.text = "\(Int(redSlider.value))"
        greenComponentLabel.text = "\(Int(greenSlider.value))"
        blueComponentLabel.text = "\(Int(blueSlider.value))"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // viewDidLoad에서 실행되었기에 main thread에서 실행. 그게 아니더라도 bind는 main thread에서 실행
        redSlider.rx.value
            .map{"\(Int($0))"}
            .bind(to: redComponentLabel.rx.text)
            .disposed(by: bag)
        
        greenSlider.rx.value
            .map{"\(Int($0))"}
            .bind(to: greenComponentLabel.rx.text)
            .disposed(by: bag)
        
        blueSlider.rx.value
            .map{"\(Int($0))"}
            .bind(to: blueComponentLabel.rx.text)
            .disposed(by: bag)
        
        Observable.combineLatest([redSlider.rx.value,
                                  greenSlider.rx.value,
                                  blueSlider.rx.value])
            .map{ UIColor(red: CGFloat($0[0])/255, green: CGFloat($0[1])/255, blue: CGFloat($0[2])/255, alpha: 1.0)}
            .bind(to: colorView.rx.backgroundColor)
            .disposed(by: bag)
        
        resetButton.rx.tap
            .subscribe(onNext: { [weak self] in
                
                //control이벤트는 항상 main thread에서 실행
                self?.colorView.backgroundColor = UIColor.black
                
                self?.redSlider.value = 0
                self?.greenSlider.value = 0
                self?.blueSlider.value = 0
                
                self?.updateComponentLabel()
            })
            .disposed(by: bag)
    }
}
