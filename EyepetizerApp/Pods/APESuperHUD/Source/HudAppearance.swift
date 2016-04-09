// HUDAppearance.swift
//
// The MIT License (MIT)
//
// Copyright (c) 2016 apegroup
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit

public enum BlurEffect {
    
    case None
    case Dark
    case Light
    case ExtraLight
}

public struct HUDAppearance {

    public var textColor = UIColor.blackColor()
    public var backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
    public var foregroundColor = UIColor.whiteColor()
    public var iconColor = UIColor.grayColor()
    public var loadingActivityIndicatorColor = UIColor.grayColor()
    public var backgroundBlurEffect: BlurEffect = .None
    public var cornerRadius: Double = 10
    public var shadow: Bool = true
    public var animateInTime: NSTimeInterval = 0.4
    public var animateOutTime: NSTimeInterval = 0.4
    public var defaultDurationTime: Double = 2.0
    public var cancelableOnTouch = false
    public var fontName: String = "Helvetica"
    public var fontSize: CGFloat = 13
    public var hudSquareSize: CGFloat = 144
    public var iconWidth: CGFloat = 48
    public var iconHeight: CGFloat = 48
    
}
