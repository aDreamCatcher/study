//
//  GraphCapsule.swift
//  Landmarks
//
//  Created by Guiyang Li on 2019/7/25.
//  Copyright © 2019 Xin. All rights reserved.
//

import SwiftUI

struct GraphCapsule: View {
    var index: Int
    var height: Length
    var range: Range<Double>
    var overallRange: Range<Double>

    var heightRatio: Length {
        max(Length(magnitude(of: range) / magnitude(of: overallRange)), 0.15)
    }

    var offsetRatio: Length {
        Length((range.lowerBound - overallRange.lowerBound) / magnitude(of: overallRange))
    }

    var animation: Animation {
        Animation.spring(dampingFraction: 0.5)
            .speed(2)
            .delay(0.03 * Double(index))
    }

    var body: some View {
        Capsule()
            .fill(Color.white)
            .frame(height: height * heightRatio, alignment: .bottom)
            .offset(x: 0, y: height * -offsetRatio)
            .animation(animation)
    }
}

#if DEBUG
struct GraphCapsule_Previews: PreviewProvider {
    static var previews: some View {
        GraphCapsule(index: 0, height: 150, range: 10..<50, overallRange: 0..<100)
    }
}
#endif
