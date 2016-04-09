//
//  EYEEYEPlayerController.swift
//  EyepetizerApp
//
//  Created by 梁亦明 on 16/3/29.
//  Copyright © 2016年 xiaoming. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class EYEPlayerController: UIViewController {
    
    //MARK: --------------------------- Life Cycle --------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 添加界面
        self.view.addSubview(playView)
        
        //旋转屏幕，但是只旋转当前的View
        UIApplication.sharedApplication().setStatusBarOrientation(
            .LandscapeRight, animated: false)
        self.view.transform = CGAffineTransformMakeRotation(CGFloat(M_PI/2))
        let frame = UIScreen.mainScreen().bounds
        self.view.bounds = CGRect(x: 0, y: 0, width: frame.size.height, height: frame.size.width)
        
        // 初始化playerLayer
        
        self.playerLayer = AVPlayerLayer(player: self.player)
        self.playerLayer.frame = self.playView.bounds
        // AVLayerVideoGravityResize,       // 非均匀模式。两个维度完全填充至整个视图区域
        // AVLayerVideoGravityResizeAspect,  // 等比例填充，直到一个维度到达区域边界
        // AVLayerVideoGravityResizeAspectFill, // 等比例填充，直到填充满整个视图区域，其中一个维度的部分区域会被裁剪
        // 此处根据视频填充模式设置
        self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect
        // 添加playerLayer到self.layer
        self.playView.layer.insertSublayer(self.playerLayer, atIndex: 0)
        // 添加观察者。通知
        addObserverAndNotifacation()
        // 计时器
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(EYEPlayerController.playerTimerAction), userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(self.timer, forMode: NSRunLoopCommonModes)
        
        // 开始播放
        self.player.play()
        self.playView.startButton.selected = true
        
        self.playView.indicatorView.startAnimating()
    }
    
    convenience init(url : String, title : String) {
        self.init()
        self.url = url
        self.videoTitle = title
        // 播放状态
        self.state = .PlayerStateStopped
        
        // 初始化playerItem
        self.playerItem  = AVPlayerItem(URL: NSURL(string: url)!)
        self.player.replaceCurrentItemWithPlayerItem(self.playerItem)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    deinit {
        self.unregisterNotifacation()
        print("播放器销毁")
    }
    //MARK: --------------------------- Event or Action --------------------------
    private func addObserverAndNotifacation() {
        // AVPlayer播放完成通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EYEPlayerController.moviePlayDidEnd(_:)), name: AVPlayerItemDidPlayToEndTimeNotification, object: self.player.currentItem)
        // app退到后台
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EYEPlayerController.appDidEnterBackground), name: UIApplicationWillResignActiveNotification, object: nil)
        // app进入前台
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EYEPlayerController.appDidEnterPlayGround), name: UIApplicationDidBecomeActiveNotification, object: nil)
        // slider开始滑动事件
        self.playView.sliderView.addTarget(self, action: #selector(EYEPlayerController.progressSliderTouchBegan(_:)), forControlEvents: .TouchDown)
        // slider滑动中事件
        self.playView.sliderView.addTarget(self, action: #selector(EYEPlayerController.progressSliderValueChanged(_:)), forControlEvents: .ValueChanged)
        // slider结束滑动事件
        self.playView.sliderView.addTarget(self, action: #selector(EYEPlayerController.progressSliderTouchEnded(_:)), forControlEvents: [.TouchUpInside, .TouchCancel, .TouchUpOutside])
        // 播放按钮点击事件
        self.playView.startButton.addTarget(self, action: #selector(EYEPlayerController.startAction(_:)), forControlEvents: .TouchUpInside)
        // 返回按钮点击事件
        self.playView.backBtn.addTarget(self, action: #selector(EYEPlayerController.backButtonAction), forControlEvents: .TouchUpInside)
        
        // 监听播放状态
        self.player.currentItem?.addObserver(self, forKeyPath: "status", options: .New, context: nil)
        // 监听loadedTimeRanges属性
        self.player.currentItem?.addObserver(self, forKeyPath: "loadedTimeRanges", options: .New, context: nil)
        // Will warn you when your buffer is empty
        self.player.currentItem?.addObserver(self, forKeyPath: "playbackBufferEmpty", options: .New, context: nil)
        // Will warn you when your buffer is good to go again.
        self.player.currentItem?.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: .New, context: nil)
        
    }
    
    /**
     取消注册通知和观察者
     */
    private func unregisterNotifacation() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        // 移除观察者
        self.player.currentItem?.removeObserver(self, forKeyPath: "status")
        self.player.currentItem?.removeObserver(self, forKeyPath: "loadedTimeRanges")
        self.player.currentItem?.removeObserver(self, forKeyPath: "playbackBufferEmpty")
        self.player.currentItem?.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp")
    }
    
    /**
     *  播放、暂停
     *
     *  @param button UIButton
     */
    @objc private func startAction(button : UIButton) {
        button.selected = !button.selected
        self.isPauseByUser = !button.selected
        if button.selected {
            self.player.play()
            self.state = .PlayerStatePlaying
        } else {
            self.player.pause()
            self.state = .PlayerStatePause
        }
    }
    
    /**
     播放完成
     */
    @objc private func moviePlayDidEnd(notification: NSNotification) {
        self.state = .PlayerStateStopped
        self.playView.startButton.selected = false
    }
    
    /**
     *  slider开始滑动事件
     */
    
    @objc private func progressSliderTouchBegan(slide : UISlider) {
        if self.player.status == .ReadyToPlay {
            // 暂停timer
            self.timer.fireDate = NSDate.distantFuture()
        }
    }
    /**
     *  slider滑动中事件
     */
    @objc private func progressSliderValueChanged(slider : UISlider) {
        //拖动改变视频播放进度
        if self.player.status == .ReadyToPlay {
            var style = ""
            let value = slider.value - sliderLastValue
            if value > 0 {
                style = ">>"
            } else if value < 0{
                style = "<<"
            }
            
            sliderLastValue = slider.value
            self.player.pause()
            //计算出拖动的当前秒数
            let total = Float(self.playerItem.duration.value) / Float(playerItem.duration.timescale)
            let dragedSeconds = Int64(floorf(total*slider.value))
            //转换成CMTime才能给player来控制播放进度
            let dragedCMTime = CMTimeMake(dragedSeconds, 1)
            // 当前时长进度progress
            let proMin = Int64(CMTimeGetSeconds(dragedCMTime)) / 60
            let proSec = Int64(CMTimeGetSeconds(dragedCMTime)) % 60
            // duration 总时长
            let durMin = self.playerItem.duration.value / Int64(self.playerItem.duration.timescale) / 60
            let durSec = self.playerItem.duration.value / Int64(self.playerItem.duration.timescale) % 60
            
            let currentTime = String(format: "%02zd:%02zd", proMin,proSec)
            let totalTime = String(format: "%02zd:%02zd", durMin, durSec)
            
            if durSec > 0 {
                // 当总时长>0时候才能拖动slider
                self.playView.startLabel.text = currentTime
                self.playView.horizontalLabel.hidden = false
                self.playView.horizontalLabel.text = String(format:"%@ %@ / %@", style, currentTime, totalTime)
            } else {
                // 此时设置slider值为0
                slider.value = 0
            }
        } else {
            // player状态加载失败
            // 此时设置slider值为0
            slider.value = 0
        }
    }
    
    /**
     slider结束滑动事件
     */
    @objc private func progressSliderTouchEnded(slider : UISlider) {
        if self.player.status == .ReadyToPlay {
            // 继续开启timer
            self.timer.fireDate = NSDate()
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.playView.horizontalLabel.hidden = true
            }
            // 结束滑动时候把开始播放按钮改为播放状态
            self.playView.startButton.selected = true
            self.isPauseByUser = false
            
            //计算出拖动的当前秒数
            let total = Float(self.playerItem.duration.value) / Float(playerItem.duration.timescale)
            let dragedSeconds = Int64(floorf(total*slider.value))
            //转换成CMTime才能给player来控制播放进度
            let dragedCMTime = CMTimeMake(dragedSeconds, 1)
            
            // 滑动结束视频跳转
            self.player.seekToTime(dragedCMTime, completionHandler: { (finish) in
                // 如果点击了暂停按钮
                if self.isPauseByUser == true {
                    return
                }
                
                self.player.play()
                
                if !self.playerItem.playbackLikelyToKeepUp && !self.isLocalVideo {
                    self.state = .PlayerStateBuffering
                    self.playView.indicatorView.startAnimating()
                }
            })
        }
    }
    
    /**
     点击返回按钮
     */
    @objc private func backButtonAction() {
        self.timer.invalidate()
        self.player.pause()
        
        self.state = .PlayerStateStopped
        self.navigationController?.popViewControllerAnimated(false)
    }
    
    /**
     应用推到后台
     */
    @objc private func appDidEnterBackground() {
        self.player.pause()
        self.state = .PlayerStatePause;
        
//        self.unregisterNotifacation()
    }
    /**
     应用回到前台
     */
    @objc private func appDidEnterPlayGround() {
        self.player.play()
        self.state = .PlayerStatePlaying
//        self.addObserverAndNotifacation()
    }
    
    // KVO监听属性
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if keyPath == "status" {
            if self.player.status == .ReadyToPlay {
                self.playView.indicatorView.stopAnimating()
                self.state = .PlayerStatePlaying
            } else if self.player.status == .Failed {
                self.playView.indicatorView.startAnimating()
            }
        } else if keyPath == "loadedTimeRanges" {
            let timeInterval = availableDuration()
            let duration = self.playerItem.duration
            let totalDuration = CMTimeGetSeconds(duration)
            self.playView.progressView.setProgress(Float(timeInterval) / Float(totalDuration), animated: false)
        } else if keyPath == "playbackBufferEmpty" {
            // 当缓冲是空的时候
            if self.playerItem.playbackBufferEmpty {
                self.state = .PlayerStateBuffering
                self.bufferingSomeSecond()
            }
        } else if keyPath == "playbackLikelyToKeepUp" {
            // 当缓冲好的时候
            
            if self.playerItem.playbackLikelyToKeepUp {
                self.state = .PlayerStatePlaying
            }
        }
        
    }
    
    /**
     计时器
     */
    @objc private func playerTimerAction() {
        
        guard self.playerItem.duration.timescale != 0 else {
            return
        }
        // 总共时长
        self.playView.sliderView.maximumValue = 1
        // 当前进度
        self.playView.sliderView.value = Float (CMTimeGetSeconds(self.playerItem.currentTime())) / (Float(self.playerItem.duration.value) / Float(self.playerItem.duration.timescale))
        // 当前时长进度progress
        let proMin = Int64(CMTimeGetSeconds(self.player.currentTime())) / 60
        let proSec = Int64(CMTimeGetSeconds(self.player.currentTime())) % 60
        // duration 总时长
        let durMin = self.playerItem.duration.value / Int64(self.playerItem.duration.timescale) / 60
        let durSec = self.playerItem.duration.value / Int64(self.playerItem.duration.timescale) % 60
        
        self.playView.startLabel.text = String(format: "%02zd:%02zd", proMin,proSec)
        self.playView.endLabel.text = String(format: "%02zd:%02zd", durMin, durSec)
    }
    
    //MARK: --------------------------- Private --------------------------
    
    /**
     计算缓冲进度
     */
    private func availableDuration() -> NSTimeInterval {
        let loadedTimeRanges = self.player.currentItem?.loadedTimeRanges
        // 获取缓冲区域
        let timeRange = loadedTimeRanges?.first?.CMTimeRangeValue
        let startSeconds = CMTimeGetSeconds(timeRange!.start)
        let durationSeconds = CMTimeGetSeconds(timeRange!.duration)
        // 计算缓冲总进度
        return startSeconds+durationSeconds
    }
    
    /**
     缓冲较差时候回调这里
     */
    private func bufferingSomeSecond() {
        self.playView.indicatorView.startAnimating()
        
        // 如果正在缓存就不往下执行
        guard !isBuffering else {
            return
        }
        
        isBuffering = true
        // 需要先暂停一小会之后再播放，否则网络状况不好的时候时间在走，声音播放不出来
        self.player.pause()
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            // 如果此时用户已经暂停了，则不再需要开启播放了
            guard self.isBuffering == false else {
                self.isBuffering = false
                return
            }
            
            self.player.play()
            // 如果执行了play还是没有播放则说明还没有缓存好，则再次缓存一段时间
            self.isBuffering = false
            if !self.playerItem.playbackLikelyToKeepUp {
                self.bufferingSomeSecond()
            }
        }
        
    }
    
    //MARK: --------------------------- Getter and Setter --------------------------
    private enum PlayerState {
        case PlayerStateBuffering  //缓冲中
        case PlayerStatePlaying    //播放中
        case PlayerStateStopped    //停止播放
        case PlayerStatePause      //暂停播放
    }
    // 界面
    private lazy var playView : EYEPlayerView = {
        var playView : EYEPlayerView = EYEPlayerView.playerView()
        playView.titleLabel.text = self.videoTitle
        playView.frame = self.view.bounds
        return playView
    }()
    // 地址
    private var url : String!
    // 标题
    private var videoTitle : String!
    // 播放状态
    private var state : PlayerState = .PlayerStateBuffering {
        didSet {
            guard state == .PlayerStateBuffering else {
                return
            }
            
            self.playView.indicatorView.stopAnimating()
        }
    }
    
    private lazy var player : AVPlayer = {
        var player: AVPlayer = AVPlayer(playerItem: self.playerItem)
        return player
    }()
    
    private var playerLayer : AVPlayerLayer!
    
    // 播放属性
    private var playerItem : AVPlayerItem!
    // 定时器
    private var timer: NSTimer!
    // 是否被用户暂停
    private var isPauseByUser : Bool! = false
    // slider上次的值
    private var sliderLastValue : Float = 0
    ///** 是否播放本地文件 */
    private var isLocalVideo : Bool! = false
    // 是否正在缓存
    private var isBuffering = false
}
