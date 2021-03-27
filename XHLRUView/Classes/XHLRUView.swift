//
//  XHLRUView.swift
//  HistoryItem
//
//  Created by 李小华 on 2021/3/26.
//

import UIKit

private let lruMargin: CGFloat = 10.0

@objc public protocol clearBtnDelegate {
    func clearBtnActionClick()
}

@objc public protocol itemClickDelegate {
    func itemClick(_ index: Int)
}

@objc public protocol lruViewDelegate {
    
    func elementClick(_ index: Int)
    
    func clearElements()
}

// 整个LRUView

public class XHLRUView: UIView {
    
    public weak var delegate: lruViewDelegate?
    var historys: [String] = [] {
        willSet {
//            print("打印新值", newValue)
//            print("historys",historys)
        }
        
        didSet {
//            print("打印旧值", oldValue)
//            print("historys",historys)
            lruContView.removeFromSuperview()
            lruContView = XHLRUContentView.init(historys)
            self.addSubview(lruContView)
        }
    }
    var lruContView: XHLRUContentView = XHLRUContentView()
    var lruHeadView: XHLRUHeadView = XHLRUHeadView()
    public override init(frame: CGRect) {
        super.init(frame: frame)
        lruHeadView = XHLRUHeadView.init("历史记录", frame: CGRect.init(x: 0, y: 0, width: self.bounds.size.width, height: 46))
        lruHeadView.delegate = self
        self.addSubview(lruHeadView)
        
        historys = ["nishisbudadh","nishisbudadh","nishisbudadh","nishisbudadh","nishisbudadh","nishisbudadh"]
        lruContView = XHLRUContentView.init(historys)
        lruContView.frame = CGRect.init(x: 0, y: 56, width: self.bounds.size.width, height: 100)
        lruContView.itemBackColor = UIColor.init(red: 236/255.0, green: 236/255.0, blue: 236/255.0, alpha: 1.0)
        lruContView.delegate = self
        self.addSubview(lruContView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension XHLRUView: clearBtnDelegate, itemClickDelegate {
    public func itemClick(_ index: Int) {
        print("点击了第几个按钮",index)
        delegate?.elementClick(index)
    }
    
    public func clearBtnActionClick() {
        historys = []
        delegate?.clearElements()
    }
    
}


// 头部视图
class XHLRUHeadView: UIView {
    
    public var lruViewTitle: String = "历史记录"
    fileprivate weak var delegate: clearBtnDelegate?
    private lazy var searchHistoryLab: UILabel = {
        let label = UILabel.init()
        label.text = lruViewTitle
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.systemGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.frame = CGRect.init(x: lruMargin, y: 8, width: 80, height: 30)
        return label
    }()
    
    private lazy var clealBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle(" 清除记录", for: .normal)
        let image = UIImage.init(named: "clear.png")
        btn.setImage(image, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.systemGray, for: .normal)
        btn.addTarget(self, action: #selector(clearBtnClick), for: .touchUpInside)
        return btn
    }()
    
    @objc func clearBtnClick() {
        if delegate != nil {
            delegate?.clearBtnActionClick()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(_ title: String, frame: CGRect) {
        self.init()
        lruViewTitle = title
//        self.backgroundColor = UIColor.red
        self.frame = frame
        let btn = clealBtn
        btn.frame = CGRect.init(x: self.bounds.size.width - 80 - lruMargin, y: 8, width: 80, height: 30)
        addSubview(searchHistoryLab)
        addSubview(clealBtn)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// 内容视图
public class XHLRUContentView: UIView {
    
    public var itemBackColor: UIColor?
    //    public var itemText: String?
    private var capacity = 0
    private var titles = [String]()
    fileprivate weak var delegate: itemClickDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(_ titles: [String]) {
        self.init()
        self.capacity = titles.count
        self.titles = titles
    }
    
    public override func layoutSubviews() {
        superview?.layoutSubviews()
        self.setUI()
    }
    
    func setUI() {
                
        var currentX: CGFloat = 0
        var currentY: CGFloat = 10.0
        var countRow: Int = 0
        var countCol: Int = 0
        var currentBtnHeight: CGFloat = 30.0
        let viewWidth = self.frame.size.width
        
        for i in 0 ..< capacity {
            let btn = self.buttonWithTitle(title: titles[i])
            btn.tag = 100 + i
            btn.addTarget(self, action: #selector(btnDidClick(_:)), for: .touchUpInside)
            var btnWidth = btn.bounds.size.width
            let btnHeight = btn.bounds.size.height
            currentBtnHeight = btnHeight
            if btnWidth > viewWidth - 2 * lruMargin {// 单个按钮超过父视图宽度
                btnWidth = viewWidth - 2 * lruMargin
                btn.frame.size.width = viewWidth - 2 * lruMargin
            }
            
            if (btnWidth + currentX + lruMargin * 2) > viewWidth  {// 超出屏幕宽度换行
                countRow += 1
                let originY = currentY + btnHeight + lruMargin
                btn.frame.origin.x = lruMargin
                btn.frame.origin.y = originY
                currentX = btnWidth + lruMargin
                currentY = originY
            } else {
                btn.frame.origin.x = countCol == 0 ? lruMargin : currentX + lruMargin
                btn.frame.origin.y = currentY
                currentX = btn.frame.origin.x + btnWidth
                countCol += 1
            }
            
            self.addSubview(btn)
        }
        self.frame.size.height = currentY + lruMargin + currentBtnHeight
    }
    
    func buttonWithTitle(title: String) -> UIButton {
        let btn = UIButton.init(type: .custom)
        btn.setTitle("   \(title)   ", for: .normal)
        btn.setTitleColor(UIColor.systemGray, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.backgroundColor = itemBackColor
        btn.sizeToFit()
        btn.layoutIfNeeded()
        btn.layer.cornerRadius = 8
        btn.layer.masksToBounds = true
        return btn
    }
    
    @objc func btnDidClick(_ btn: UIButton) {
        delegate?.itemClick(btn.tag - 100)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

