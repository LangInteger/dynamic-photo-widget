//
//  LangWidgetBundle.swift
//  LangWidget
//
//  Created by liu lang on 2023/8/14.
//

import WidgetKit
import SwiftUI

@main
struct LangWidgetBundle: WidgetBundle {
    var body: some Widget {
        URLCachedImageWidget()
        LangWidgetLiveActivity()
    }
}
