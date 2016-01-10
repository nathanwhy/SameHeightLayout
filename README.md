# SameHeightLayout
Every row has the same height

![](snapshot.png)

```Swift
class SameHeightLayout: UICollectionViewLayout {
      
    var cellPadding: CGFloat = 0
    var delegate: SameHeightLayoutDelegate!
    var numberOfColumns = 1
    var maxNumberAtLine = 3
    
    ...
}
```
