//
//  QLPreviewControllerWrapper.swift
//  Medusa
//
//  Created by zheer barzan on 5/2/25.
//

import QuickLook

 class QuickLookPreviewControllerWrapper: UIViewController {
    let quickLookViewControler = QLPreviewController()
    var quickLookPresented = false

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !quickLookPresented {
            present(quickLookViewControler, animated: false, completion: nil)
            quickLookPresented = true
        }
    }
}
