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
import CoreLocation
import RxSwift
import RxCocoa
import MapKit

//delegate pattern은 rx와 같이 사용할 수 있지만 RxSwift와는 어울리지 않음

class DelegateProxyViewController: UIViewController {
    
    let bag = DisposeBag()
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        locationManager.rx.didUpdateLocations
            .subscribe(onNext: {locations in
                print(locations)
            })
            .disposed(by: bag)
        
        locationManager.rx.didUpdateLocations
            .map{$0[0]}
            .bind(to: mapView.rx.center)
            .disposed(by: bag)
        
    }
}


extension Reactive where Base: MKMapView {
    public var center: Binder<CLLocation> {
        return Binder(self.base) { mapView, location in
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
            self.base.setRegion(region, animated: true)
        }
    }
}

extension CLLocationManager: HasDelegate {
    public typealias Delegate = CLLocationManagerDelegate
}


//첫 번째 파라미터는 확장할 클래스,
//두 번째 파라미터는 연관된 delegate protocol,
//delegate proxy type protocol을 채택, 연관된 delegate protocol도 채택
class RxCLLocationManagerDelegateProxy: DelegateProxy<CLLocationManager, CLLocationManagerDelegate>, DelegateProxyType, CLLocationManagerDelegate {
    //확장 대상에 접근(weak로 접근해야 retain cycle이 생기지 않음)
    weak private(set) var locationManager: CLLocationManager?
    
    init(locationManager: CLLocationManager){
        self.locationManager = locationManager
        super.init(parentObject: locationManager, delegateProxy: RxCLLocationManagerDelegateProxy.self)
    }
    
    //closure에서 delegate의 proxy instance를 리턴해야 함
    static func registerKnownImplementations() {
        self.register{
            RxCLLocationManagerDelegateProxy(locationManager: $0)
        }
    }
}

extension Reactive where Base: CLLocationManager {
    
    // 위에 만든 생성자를 사용할 수도 있지만 사용하게 되면 인스턴스가 2개 이상 생성되는 문제가 생김, 그러면 delegate proxy가 예상과 다르게 작동함
    // so, proxy for 메소드를 사용해야 한다
    var delegate: DelegateProxy<CLLocationManager, CLLocationManagerDelegate> {
        return RxCLLocationManagerDelegateProxy.proxy(for: base)
    }
    
    //이제 delegate에서 메소드가 호출되면 observable을 통해 위치정보를 방출하는 코드를 작성
    var didUpdateLocations: Observable<[CLLocation]> {
        return delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didUpdateLocations:)))
            .map{ parameters in
                return parameters[1] as! [CLLocation]
            }
    }
}
