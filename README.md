## WCLWaterFallLayout

![aaaa](https://github.com/631106979/WCLWaterFallLayout/blob/master/WCLWaterFallLayout.gif?raw=true)

## 简介

用swift写的简单的瀑布流布局，用于UICollectionView，支持拖拽布局~

## 使用

```swift
let layout = WCLWaterFallLayout.init(lineSpacing: 11, columnSpacing: 11, sectionInsets: UIEdgeInsetsMake(0, 16, 10, 16))
layout.delegate = self
contentCV = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
```

或者使用拖拽布局

![bbbb](http://imwcl.oss-cn-shanghai.aliyuncs.com/github/WCLWaterFallLayout/2860B3D7-CC8B-4D15-90E4-1AA14D1B4703.png)

```swift
@objc protocol WCLWaterFallLayoutDelegate {
    //waterFall的列数
    func columnOfWaterFall(_ collectionView: UICollectionView) -> Int
    //每个item的高度
    func waterFall(_ collectionView: UICollectionView, layout waterFallLayout: WCLWaterFallLayout, heightForItemAt indexPath: IndexPath) -> CGFloat
}
```

## 属性列表

```swift
    //代理
    weak var delegate: WCLWaterFallLayoutDelegate?
    //行间距
    @IBInspectable var lineSpacing: CGFloat   = 0
    //列间距
    @IBInspectable var columnSpacing: CGFloat = 0
    //section的top
    @IBInspectable var sectionTop: CGFloat    = 0 {
        willSet {
            sectionInsets.top = newValue
        }
    }
    //section的Bottom
    @IBInspectable var sectionBottom: CGFloat  = 0 {
        willSet {
            sectionInsets.bottom = newValue
        }
    }
    //section的left
    @IBInspectable var sectionLeft: CGFloat   = 0 {
        willSet {
            sectionInsets.left = newValue
        }
    }
    //section的right
    @IBInspectable var sectionRight: CGFloat  = 0 {
        willSet {
            sectionInsets.right = newValue
        }
    }
    //section的Insets
    @IBInspectable var sectionInsets: UIEdgeInsets      = UIEdgeInsets.zero
```



