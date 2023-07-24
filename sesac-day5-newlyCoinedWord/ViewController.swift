//
//  ViewController.swift
//  sesac-day5-newlyCoinedWord
//
//  Created by 박창현 on 2023.07.24.
//

import UIKit

class ViewController: UIViewController {
    struct dictionary: Codable {
        var title: String
        var disc: String
    }

    @IBOutlet var displayTitle: UILabel!
    @IBOutlet var displayDisc: UILabel!
    @IBOutlet var backgroundImage: UIImageView!
    @IBOutlet var menuView: UIView!
    @IBOutlet var userSearchField: UITextField!
    @IBOutlet var suggestButtonList: [UIButton]! {
        didSet {
            suggestButtonList.sort {
                $0.tag < $1.tag
            }
        }
    }

    var nowWord: Int? = nil
    var idxDict: [String: Int] = [:]
    var wordDict: [dictionary] = []
    var isInit: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        initWord()
        setSuggestWord()
        menuView.layer.cornerRadius = 10
        userSearchField.clearButtonMode = .always
        displayTitle.text = ""
        displayDisc.text = ""
        backgroundImage.image = UIImage(named: "word_logo")
    }

    @IBAction func activeTapGesture(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    @IBAction func touchSuggestButton(_ sender: UIButton) {
        userSearchField.text = sender.currentTitle
        searchAction(sender)
    }

    @IBAction func searchAction(_ sender: Any) {
        view.endEditing(true)
        guard let text = userSearchField.text else {
            sendAlert("공백은 입력할 수 없습니다.")
            return
        }
        switch text.count {
        case 0:
            sendAlert("공백은 입력할 수 없습니다.")
            return
        case 1:
            sendAlert("두글자부터 입력 가능합니다.")
            return
        default: break
        }
        guard let idx = idxDict[text] else {
            sendAlert("검색결과가 없습니다.")
            return
        }
        let now = wordDict[idx]
        displayTitle.text = now.title
        displayDisc.text = now.disc
        setSuggestWord()
        if (isInit) {
            backgroundImage.image = UIImage(named: "background")
            isInit.toggle()
        }
    }

    /**
     * 알림 띄우기 함수
     */
    func sendAlert(_ text: String, title: String = "오류") {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .cancel))
        present(alert, animated: true)
    }

    func setSuggestWord() {
        var range: Set<Int> = []
        let arr = Array(0...wordDict.count - 1).shuffled()
        range = range.union(arr[0...suggestButtonList.count - 1])
        var next = nowWord ?? range.first!
        while range.contains(next) {
            next = arr.randomElement()!
        }
        range.update(with: next)
        for s in suggestButtonList {
            var now = range.removeFirst()
            if (now == nowWord) {
                now = range.removeFirst()
            }
            s.setTitle(wordDict[now].title, for: .normal)
        }
    }

    func initWord() {
        let yamin = ["세종머앟": "세종대왕",
                     "괴꺼솟": "피커솟",
                     "띵작": "명작",
                     "띵언": "명언",
                     "커엽다": "귀엽다",
                     "괄도네넴띤": "팔도비빔면",
                     "머전": "대전",
                     "윾튺브": "유튜브",
                     "댕댕이": "멍멍이",
                     "롬곡": "눈물",
                     "숲튽훈": "김장훈"]
        let abbreviation = ["얼죽아": "얼어 죽어도 아이스 아메리카노. 한겨울에도 차가운 커피를 마시는 것",
                            "복세편살": "복잡한 세상 편하게 살자",
                            "만반잘부": "만나서 반가워, 잘 부탁해",
                            "자만추": "소개팅이 아닌 자연스러운 만남을 추구",
                            "연서복": "막 제대해서 연애에 서툰 복학생",
                            "낄끼빠빠": "낄 때 끼고 빠질 때 빠져라",
                            "인싸": "인사이더 줄임말. 아웃사이더와 반대로 세상에 잘 적응하고 어울리며 살아가는 사람들",
                            "마상": "마음의 상처",
                            "문찐": "문화찐따. 즉 새로운 문화에 적응 못하고 뒤쳐지는 사람",
                            "버카충": "버스카드 충전",
                            "인구론": "인문계의 90프로는 논다"]
        let etcWord = ["무민세대": "한자 무(無) + 영어 mean의 합성어. 자극없고 의미도 없는 무위의 휴식을 꿈꾸는 세대",
                       "뇌피셜": "뇌 + 오피셜의 합성어. 객관적 근거없이 자신의 생각만을 근거로 한 추측이나 주장",
                       "혼바비언": "‘혼밥’ + 특정 출신, 인종 등을 가리키는 영어 ~ian, 혼자 밥 먹는 종족",
                       "빼박캔트": "빼도박도 + 캔트(못한다)와 영어 can’t의 합성어",
                       "아이엠그루트": "영화 <가디언즈 오브 갤럭시>의 캐릭터 그루트가 하는 말. 주로 욕을 해주고 싶은데 이런저런 사정으로 참아야 할 때 대신 사용",
                       "뽀시래기": "부스러기를 이르는 전라도 사투리로 귀엽고 앙증맞은 사람, 동물",
                       "핑프": "핑거 프린세스의 준말로 손가락 하나 움직이지 않는 게으른 사람"]
        for word in yamin {
            let i = wordDict.count
            wordDict.append(dictionary(title: word.key, disc: word.value))
            idxDict[word.key] = i
            idxDict[word.value] = i
        }
        for word in abbreviation {
            let i = wordDict.count
            wordDict.append(dictionary(title: word.key, disc: word.value))
            idxDict[word.key] = i
        }
        for word in etcWord {
            let i = wordDict.count
            wordDict.append(dictionary(title: word.key, disc: word.value))
            idxDict[word.key] = i
        }
    }
}

/*

 */
