//
//  XHLRUView.swift
//  HistoryItem
//
//  Created by 李小华 on 2021/3/26.
//

import UIKit

private let lruMargin: CGFloat = 10.0

@objc public protocol ClearBtnDelegate {
    func clearBtnActionClick()
}

@objc public protocol ItemClickDelegate {
    func itemClick(_ index: Int)
}

@objc public protocol LRUViewDelegate {
    
    func elementClick(_ index: Int)
    
    func clearElements()
}

// 整个LRUView

public class XHLRUView: UIView {
    
    public weak var delegate: LRUViewDelegate?
    public var historys: [NSMutableDictionary] = [] {
        willSet {
//            print("打印新值", newValue)
//            print("historys",historys)
        }
        
        didSet {
//            print("打印旧值", oldValue)
//            print("historys",historys)
            lruContView.removeFromSuperview()
            lruContView = XHLRUContentView.init(historys)
            lruContView.frame = CGRect.init(x: 0, y: 56, width: self.bounds.size.width, height: 250)
            lruContView.delegate = self
            self.addSubview(lruContView)
//            lruContView.setUI()
        }
    }
    var lruContView: XHLRUContentView = XHLRUContentView()
    var lruHeadView: XHLRUHeadView = XHLRUHeadView()
    public override init(frame: CGRect) {
        super.init(frame: frame)
        lruHeadView = XHLRUHeadView.init("历史记录", frame: CGRect.init(x: 0, y: 0, width: self.bounds.size.width, height: 46))
        lruHeadView.delegate = self
        self.addSubview(lruHeadView)
//        let dic = ["fontColor": UIColor.green, "barrage": "你是个什么玩意", "fontName": "AppleSDGothicNeo-Bold", "fontSize": 200, "animationDuration": 10] as NSMutableDictionary
//        historys = [dic]
        lruContView = XHLRUContentView.init(historys)
        lruContView.frame = CGRect.init(x: 0, y: 56, width: self.bounds.size.width, height: 250)
        lruContView.itemBackColor = UIColor.init(red: 236/255.0, green: 236/255.0, blue: 236/255.0, alpha: 1.0)
        lruContView.delegate = self
        self.addSubview(lruContView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension XHLRUView: ClearBtnDelegate, ItemClickDelegate {
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
    fileprivate weak var delegate: ClearBtnDelegate?
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
        
//        let className = "XHLRUView" + "." + "XHLRUView"
//        let cls: AnyClass? = NSClassFromString(className)
//        let bundle = Bundle(for: cls!)
//        let scale = Int(UIScreen.main.scale)
//        let path = bundle.path(forResource: "XHLRUView.bundle/clear@\(scale)x.png", ofType: nil)
//        let image = UIImage.init(contentsOfFile: path!)
        let image = UIImage.getImageFromBundle("clear")
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
    private var items = [NSMutableDictionary]()
    fileprivate weak var delegate: ItemClickDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(_ items: [NSMutableDictionary]) {
        self.init()
        self.items = items
//        self.backgroundColor = UIColor.red
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
        let viewWidth = self.superview!.frame.size.width
        
        for i in 0 ..< items.count {
            let dic = items[i]
            let btn = self.buttonWithTitle(dic)
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
    
    func buttonWithTitle(_ model: NSMutableDictionary) -> UIButton {
        let btn = UIButton.init(type: .custom)
        btn.setTitle("   \(model["barrage"]!)   ", for: .normal)
        btn.setTitleColor(model["fontColor"]! as? UIColor, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.titleLabel?.font = UIFont.init(name: model["fontName"] as! String , size: 14)
        btn.backgroundColor = UIColor.white
        btn.sizeToFit()
        btn.layoutIfNeeded()
        btn.layer.cornerRadius = 8
        btn.layer.masksToBounds = true
        btn.layer.borderColor = (model["fontColor"]! as! UIColor).cgColor
        btn.layer.borderWidth = 0.5
        btn.isEnabled = true
        return btn
    }
    
    @objc func btnDidClick(_ btn: UIButton) {
        print("有没有用");
        delegate?.itemClick(btn.tag - 100)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension UIImage {
    class func getImageFromBundle(_ imageName: String) -> UIImage {
        let className = "XHLRUView" + "." + "XHLRUView"
        let cls: AnyClass? = NSClassFromString(className)
        let bundle = Bundle(for: cls!)
        let scale = Int(UIScreen.main.scale)
        let path = bundle.path(forResource: "XHLRUView.bundle/\(imageName)@\(scale)x.png", ofType: nil)
        guard let image = UIImage.init(contentsOfFile: path!) else { return UIImage() }
        return image
    }
}

