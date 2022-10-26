//
//  PostViewController.swift
//  FlickerLong
//
//  Created by LAP15335 on 19/10/2022.
//

import UIKit

class PostViewController: UIViewController, ListAlbumViewControllerDelegate {
    
    var listImage : [UIImage]!
    var collectionView : UICollectionView!
    var postView : PostView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "New Post"
        
        postView = PostView(viewController: self)
        postView.initView()
        postView.initConstraint()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PickerImageCell.self, forCellWithReuseIdentifier: "photoCell")
        
        setUpNavigation()
    }
    
    func setUpNavigation(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .plain, target: self, action: #selector(postButton))
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    @objc func postButton(){
        let imageData = listImage[0].jpegData(compressionQuality: 0.1) ?? Data()
        
        let imgStr = imageData.base64EncodedString()
        //send request to server
        guard let url = URL(string: "https://up.flickr.com/services/upload/") else{
            print("Invalid URL Uploading")
            return
        }
        //create parameters
        let paramStr = "photo=\(imgStr)"
        let paramData = paramStr.data(using: .utf8) ?? Data()
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = paramData
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        //send the request
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data else{
                print("Invalid data")
                return
            }
            let responseStr : String = String(data: data, encoding: .utf8) ?? "No response"
            print(responseStr)
        }
    
//        public func uploadPhotosURLs1(lobjImageToUpload:UIImage)
//        {
//          let secret =  FlickrManager.sharedInstance.strAuthSecret
//          //where secret is 7e5cfde9b0023627
//          let api_key = FlickrManager.sharedInstance.strApiKey
//          let auth_token = FlickrManager.sharedInstance.strAuthToken
//
//          let imageData = UIImageJPEGRepresentation(lobjImageToUpload, 1)
//
//          let uploadSig = "\(secret)_key\(api_key)_token\(auth_token)"
//          let request = NSMutableURLRequest()
//          let url = "http://api.flickr.com/services/upload/"
//          request.url = URL(string: url)!
//          request.httpMethod = "POST"
//
//
//          let boundary = String("---------------------------7d44e178b0434")
//          request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//
//          let body:NSMutableData = NSMutableData()
//          body.append("\r\n--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
//
//          body.append("Content-Disposition: form-data; name=\"api_key\"\r\n\r\n".data(using: String.Encoding.utf8)!)
//          body.append("\(api_key)\r\n".data(using: String.Encoding.utf8)!)
//          body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
//          body.append("Content-Disposition: form-data; name=\"auth_token\"\r\n\r\n".data(using: String.Encoding.utf8)!)
//          body.append("\(auth_token)\r\n".data(using: String.Encoding.utf8)!)
//
//          body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
//          body.append("Content-Disposition: form-data; name=\"api_sig\"\r\n\r\n".data(using: String.Encoding.utf8)!)
//          body.append("\(uploadSig)\r\n".data(using: String.Encoding.utf8)!)
//          body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
//          body.append(String("Content-Disposition: form-data; name=\"photo\"; filename=\"photo.jpg\"\r\n").data(using: String.Encoding.utf8)!)
//          body.append("Content-Type: image/jpeg\r\n\r\n".data(using: String.Encoding.utf8)!)
//
//          body.append(imageData!)
//          body.append("\r\n--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
//          request.httpBody = body as Data
//
//          let session = URLSession.shared
//
//          let task = session.dataTask(with: request as URLRequest,
//                                    completionHandler: {(data, response, error) in
//              if let error = error {
//                print(error)
//              }
//              if let data = data{
//                print("data =\(data)")
//              }
//              if let response = response {
//                print("url = \(response.url!)")
//                print("response = \(response)")
//                let httpResponse = response as! HTTPURLResponse
//                print("response code = \(httpResponse.statusCode)")
//                print("DATA = \(data)")
//                //if you response is json do the following
//                do{
//                    let resultJSON = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions())
//                    let arrayJSON = resultJSON as! NSArray
//                    for value in arrayJSON{
//                        let dicValue = value as! NSDictionary
//                        for (key, value) in dicValue {
//                            print("key = \(key)")
//                            print("value = \(value)")
//                        }
//                    }
//
//                }catch _{
//                    print("Received not-well-formatted JSON")
//                }
//            }
//        })
//            task.resume()
//        }
        
    }
    
    @objc func albumDidTapped(){
        let vc = ListAlbumViewController()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func returnChosenAlbum(album: AlbumModel) {
        postView.chooseAlbum(title: album.title)
    }
}

extension PostViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listImage.count > 4 ? 4 : listImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PickerImageCell{
            
            photoCell.config(image: listImage[indexPath.item])
            if(indexPath.item == 3 && listImage.count > 4){
                photoCell.showMoreImage(number: listImage.count - 3)
            }
            cell = photoCell
        }
        
        return cell
    }
    
    
}

extension PostViewController : UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 4 - 6, height: collectionView.frame.size.width / 4 - 6)
    }
}
