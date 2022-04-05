//
//  RKView.swift
//  
//
//  Created by Chris Scalcucci on 3/21/22.
//

import UIKit
import RxSwift
import RxCocoa

open class RKView<VM: RKViewModel> : UIView {
    public private(set) var viewModel : VM? {
        didSet {
            if let _ = viewModel {
                setupViewBindings()
            } else {
                disposeBag = DisposeBag()
            }
        }
    }

    public private(set) var disposeBag = DisposeBag()

    public class func create<T: RKView>(vm: VM) -> T {
        let v = T()
        v.setModel(vm)
        return v
    }

    public func setModel(_ vm: VM) {
        _ = self
        self.viewModel = vm
    }

    public func detachModel() {
        _ = self
        self.viewModel = nil
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)

        commonInit()
    }

    open func commonInit() {
    }

    open func setupViewBindings() {

    }
}


