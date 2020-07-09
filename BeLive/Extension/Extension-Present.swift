//
//  Extension-Present.swift
//  Growdex
//
//  Created by TEZWEZ on 2019/11/22.
//  Copyright © 2019 YUXI. All rights reserved.
//

/*
众所周知方法交换一般都在单例中进行，但是 OC中用来保证代码块只执行一次的dispatch_once在swfit中已经被废弃了,取而代之的是使用static let,let本身就带有线程安全性质的.
+load(): app启动的时候会加载所有的类,此时就会调用每个类的load方法.
+initialize(): 第一次初始化这个类的时候会被调用.

然而在目前的swift版本中这两个方法都不可用了,那现在我们要在这个阶段搞事情该怎么做? 例如method swizzling.
JORDAN SMITH大神给出了一种很巧解决方案.UIApplication有一个next属性,它会在applicationDidFinishLaunching之前被调用,这个时候通过runtime获取到所有类的列表,然后向所有遵循SelfAware协议的类发送消息.
*/
//extension UIApplication {
//    private static let runOnce: Void = {
//        NothingToSeeHere.harmlessFunction()
//    }()
//    override open var next: UIResponder? {
//        // Called before applicationDidFinishLaunching
//        UIApplication.runOnce
//        return super.next
//    }
//}
//class NothingToSeeHere {
//    static func harmlessFunction() {
//        let typeCount = Int(objc_getClassList(nil, 0))
//        let types = UnsafeMutablePointer<AnyClass>.allocate(capacity: typeCount)
//        let autoreleasingTypes = AutoreleasingUnsafeMutablePointer<AnyClass>(types)
//        objc_getClassList(autoreleasingTypes, Int32(typeCount))
//        for index in 0 ..< typeCount {
//            (types[index] as? SelfAware.Type)?.awake()
//        }
//        types.deallocate()
//    }
//}
//
//protocol SelfAware:class {
//    static func awake()
//    static func swizzlingForClass(_ forClass:AnyClass,originalSelector:Selector,swizzledSelector:Selector)
//}
//
//extension SelfAware{
//    static func swizzlingForClass(_ forClass:AnyClass,originalSelector:Selector,swizzledSelector:Selector){
//        let originalMethod = class_getInstanceMethod(forClass, originalSelector)
//        let swizzledMethod = class_getInstanceMethod(forClass, swizzledSelector)
//        guard (originalMethod != nil && swizzledMethod != nil) else {
//           return
//        }
//        if class_addMethod(forClass, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!)) {
//           class_replaceMethod(forClass, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
//        } else {
//           method_exchangeImplementations(originalMethod!, swizzledMethod!)
//        }
//    }
//}
//
//extension UIViewController:SelfAware {
//    static func awake() {
//        presentSwizzledMethod
//    }
//    private static let presentSwizzledMethod:Void = {
//        let originalSelector = #selector(present(_:animated:completion:))
//        let swizzledSelector = #selector(cl_present(_:animation:completion:))
//        swizzlingForClass(UIViewController.self, originalSelector: originalSelector, swizzledSelector: swizzledSelector)
//    }()
//    
//    @objc func cl_present(_ controlelr:UIViewController,animation:Bool,completion: (() -> Void)? = nil) {
//        print("swizzled_present")
//        
//        controlelr.modalPresentationStyle = UIModalPresentationStyle.fullScreen
//        self.cl_present(controlelr,animation:true,completion:nil)
//    }
//}
