//
//  ViewController.swift
//  ChatBotApp
//
//  Created by Oneview Infosys on 04/02/19.
//  Copyright © 2019 Oneview Infosys. All rights reserved.
//

import UIKit
import ApiAI
import AVFoundation

class ChatBotVC: UIViewController {
    @IBOutlet weak var chatBotBGImg: UIImageView!
    @IBOutlet weak var chatBotView: UIView!
    @IBOutlet weak var chatBotTableView: UITableView!
    @IBOutlet weak var yourMessageTextField: UITextField!
    let speechSynthesizer = AVSpeechSynthesizer()
    var array = [[String:String]]()
    var tempArray = [[String:String]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        chatBotTableView.dataSource = self
        chatBotTableView.delegate = self
        chatBotTableView.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi))
        chatBotTableView.rowHeight = UITableView.automaticDimension
        chatBotTableView.estimatedRowHeight = UITableView.automaticDimension
        
        guard let image = UIImage(named: "chat_bubble_sent") else { return }
        chatBotBGImg.image = image
            .resizableImage(withCapInsets:
                UIEdgeInsets(top: 17, left: 21, bottom: 17, right: 21),
                            resizingMode: .stretch)
            .withRenderingMode(.alwaysTemplate)
        chatBotBGImg.tintColor = UIColor(named: "chat_bubble_color_sent")
        chatBotBGImg.tintColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        
        
        
        if !UIAccessibility.isReduceTransparencyEnabled {
            view.backgroundColor = .clear
            
            let blurEffect = UIBlurEffect(style: .dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            //view.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
            view.insertSubview(blurEffectView, at: 0)
        } else {
            view.backgroundColor = .black
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            if self.chatBotView.isHidden == true{
                self.chatBotView.isHidden = false
            }
        }, completion: nil)
    }

    func speechAndText(text: String) {
        let speechUtterance = AVSpeechUtterance(string: text)
        speechSynthesizer.speak(speechUtterance)
    }

    @IBAction func chatBotButtonTapped(_ sender: Any) {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            if self.chatBotView.isHidden == false{
                self.chatBotView.isHidden = true
            }
        }, completion: { (finished: Bool) -> () in
            ChatbotManager.sharedInstance.returnToWindowOfAppDelegate()
        })
    }
    @IBAction func sendButtonTapped(_ sender: Any) {
        let request = ApiAI.shared().textRequest()
        
        if let text = self.yourMessageTextField.text, text != "" {
            request?.query = text
            let dict = ["mymsg":text]
            tempArray.append(dict)
            self.array = self.tempArray.reversed()
            chatBotTableView.reloadData()
        } else {
            return
        }
        
        request?.setMappedCompletionBlockSuccess({ (request, response) in
            let response = response as! AIResponse
            if let textResponse = response.result.fulfillment.speech {
                self.speechAndText(text: textResponse)
                let dict = ["chatbotmsg":textResponse]
                self.tempArray.append(dict)
                self.array = self.tempArray.reversed()
                self.chatBotTableView.reloadData()
            }
        }, failure: { (request, error) in
            print(error!)
        })
        
        ApiAI.shared().enqueue(request)
        yourMessageTextField.text = ""
    }
}
extension ChatBotVC : UITableViewDataSource,UITableViewDelegate{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell") as? MessageCell
            else{
                return UITableViewCell()
        }
        //cell.configureCell(goal: goal)
        cell.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi))
        if let msg = array[indexPath.row]["mymsg"]{
            cell.messageBGImageView.image = UIImage(named: "chat_bubble_sent")?
                .resizableImage(withCapInsets:
                    UIEdgeInsets(top: 17, left: 21, bottom: 17, right: 21),
                                resizingMode: .stretch)
                .withRenderingMode(.alwaysTemplate)
            cell.messageBGImageView.tintColor = UIColor(named: "chat_bubble_color_sent")
            cell.messageBGImageView.tintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        cell.messageLabel.text = msg
            return cell
        }else if let msg = array[indexPath.row]["chatbotmsg"]{
            cell.messageBGImageView.image = UIImage(named: "chat_bubble_received")?
                .resizableImage(withCapInsets:
                    UIEdgeInsets(top: 17, left: 21, bottom: 17, right: 21),
                                resizingMode: .stretch)
                .withRenderingMode(.alwaysTemplate)
            cell.messageBGImageView.tintColor = UIColor(named: "chat_bubble_color_sent")
            cell.messageBGImageView.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            cell.messageLabel.text = msg
            return cell
        }
        return cell
        
    }
    
}
extension ChatBotVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.yourMessageTextField.text = ""
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        array.append(textField.text!)
//        chatBotTableView.reloadData()
         return true
    }
   }
