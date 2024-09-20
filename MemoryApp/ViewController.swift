import UIKit
import AudioToolbox
private let reuseIdentifier = "Cell"


class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(mainCollectionView)
        

        self.loadData()
        
        
//        self.startTimer()
    }
    
    var colorArray = NSMutableArray()
    var numberArray = NSMutableArray()
    var copynumberArray = NSArray()
    
    lazy var textField: UITextField = {
        let tf = UITextField.init()
        tf.backgroundColor = .white
        tf.textAlignment = .center
        return tf
    }()
    
    
    // MARK: - Netdata
    
    func loadData() {
        isRemeber = false
        textField.text = ""
        markIndex = Int.random(in: 0...level*level - 1)
        cellW = (view.bounds.width - space*2 - itemSpace*Double(level - 1))/Double(level)
        colorArray.removeAllObjects()
        numberArray.removeAllObjects()
        for _ in 0...level*level - 1 {
            numberArray.add(String.init(format: "%ld", Int.random(in: 0...level*level - 1)))
        }
        print(numberArray)
        
        copynumberArray = numberArray.shuffled() as NSArray
        numberArray = NSMutableArray.init(array: copynumberArray)
        markColor = randomColor()
        print(numberArray)

        self.mainCollectionView.reloadData()
    }
    
    
    // MARK: - collectionview
    
    lazy var mainCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        let collview = UICollectionView.init(frame: view.bounds, collectionViewLayout: layout)
        collview.delegate = self
        collview.dataSource = self
        collview.backgroundColor = UIColor.white
//        collview.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
//        collview.register(BaseCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collview.register(UINib.init(nibName: "BaseOneCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "BaseOneCollectionViewCell")
        collview.isScrollEnabled = false
        return collview
        
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return numberArray.count

        }
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BaseOneCollectionViewCell", for: indexPath) as! BaseOneCollectionViewCell
        cell.L.text = String.init(format: "%@", numberArray[indexPath.row] as! String)
        cell.L.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        cell.L.textColor = UIColor.black

        cell.backgroundColor = markColor
        if cell.L.text == "?" {
            cell.L.textColor = UIColor.red
        }
        
        
        if indexPath.section == 1 {
            textField.frame = cell.bounds
            textField.placeholder = String.init(format: "level : %ld", level - 1)
            textField.keyboardType = .numberPad
            textField.isUserInteractionEnabled = false
            if isRemeber {
                textField.placeholder = "? = "
                textField.isUserInteractionEnabled = true
            }
            
            textField.backgroundColor = .systemGray5
            cell.contentView.addSubview(textField)
        }else if indexPath.section == 2{
            cell.L.font = UIFont.systemFont(ofSize: 25, weight: .bold)

            cell.L.text = "Got it"
            if isRemeber {
                cell.L.text = "Submit"

            }
            cell.L.textColor = .black
        }
        
        return cell
    }
    
    
    // MARK: - UICollectionViewFlowLayout
    
    var level : Int = 2
    let itemSpace = 5.0
    let space = 50.0
    var cellW = 0.0
    var markIndex = 0
    var markColor :UIColor?
    var isRemeber = false
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            return CGSize.init(width: cellW, height: cellW)
        }
        
        return CGSize.init(width: mainCollectionView.bounds.size.width - 100, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpace
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpace
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let scaleWH = view.bounds.size.width/view.bounds.size.height
        if section == 0 {
            return UIEdgeInsets.init(top: scaleWH > 0.5 ? 50 : 120, left: 50, bottom: 0, right: 50)
        }
        
        return UIEdgeInsets.init(top: 0, left: space, bottom: 25, right: space)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 1 {
          return  CGSize.init(width: mainCollectionView.bounds.size.width, height: 50)
        }
        return CGSizeZero
    }
    
    var markL = UILabel()
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
//        if isFinish == false{
            UIView .animate(withDuration: 0.5, delay: 0.0, options: .curveLinear) {
                collectionView.transform3D = CATransform3DMakeRotation(.pi , 0, 1, 0)

            } completion: { (make) in
                collectionView.transform = .identity

            }
        
//        }
        
    }
    
   
    var isFinish = false
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        if indexPath.row == markIndex {
//            count = 60
//            isFinish = false
//            level = level + 1
//            print(level)
//            self.loadData()
//            collectionView.reloadData()
//        }else{
//            self.stopTimer()
//            self.finishFunc()
//        }
        
        if indexPath.section == 2 {
            
            if isRemeber {
                if textField.text!.count > 0{

                    if textField.text == copynumberArray[markIndex] as? String {
                        level = level + 1
                        self.loadData()
//                        isRemeber = false

                        self.mainCollectionView.reloadData()
                    }else{
                        self.finishFunc()

                    }
                    
                }
            }else{
                isRemeber = !isRemeber
                numberArray.replaceObject(at: markIndex, with: "?")
                collectionView.reloadData()
            }
            
            
        }
        
       
    }
    
    
    func finishFunc()  {
        isRemeber = false
//        self.mainCollectionView.reloadData()
        let alertController = UIAlertController.init(title: "Challenge failure", message: String.init(format: "Highest Score %ld", level - 2 ), preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Restart", style: .default, handler: {
            action in
            self.level = 2
            self.isRemeber = false
            self.loadData()
            self.mainCollectionView.reloadData()
            
//            self.startTimer()
        })
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
        
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))

    }
    
    func randomColor() -> UIColor {
        let color = UIColor.init(red: randomNumber()/255.0, green: randomNumber()/255.0, blue: randomNumber()/255.0, alpha: 1)
        return color
    }
    
    var itemColor = UIColor.init()
    func randomNumber() -> CGFloat{
        let random = arc4random() % 100 + 150
        return CGFloat(random)
    }

    
      var timer: Timer?
      var count: Int = 5 {
          didSet {
//              print("剩余时间: \(count)秒")
              
              markL.text = String.init(format: "Level : %ld     Time : %ld", level,count)

              if count < 0 {
                  stopTimer()

                  self.finishFunc()
                  print("倒计时结束！")
              }
          }
      }
   
      func startTimer() {
          self.stopTimer()
          count = 60
          timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
              self?.count -= 1
          }
      }
   
      func stopTimer() {
          timer?.invalidate()
          timer = nil
      }
    
    
    
}
