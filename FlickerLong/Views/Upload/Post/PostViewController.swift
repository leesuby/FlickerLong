//
//  PostViewController.swift
//  FlickerLong
//
//  Created by LAP15335 on 19/10/2022.
//

import UIKit
import objectiveflickr

class PostViewController: UIViewController, ListAlbumViewControllerDelegate, OFFlickrAPIRequestDelegate {
    var listRequest : [OFFlickrAPIRequest] = []
    
    
    func flickrAPIRequest(_ inRequest: OFFlickrAPIRequest!, didCompleteWithResponse inResponseDictionary: [AnyHashable : Any]!) {
        navigationController?.popToRootViewController(animated: true)
        tabBarController?.selectedIndex = 2
    }
    
    func flickrAPIRequest(_ inRequest: OFFlickrAPIRequest!, didFailWithError inError: Error!) {
        print(inError!)
    }
    
    func flickrAPIRequest(_ inRequest: OFFlickrAPIRequest!, imageUploadSentBytes inSentBytes: UInt, totalBytes inTotalBytes: UInt) {
        print(inTotalBytes)
    }
    
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
        // set the delegate, here we assume it's the controller that's creating the request object
        
        
        setUpNavigation()
    }
    
    func setUpNavigation(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .plain, target: self, action: #selector(postButton))
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    @objc func postButton(){
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        let title : String = (self.postView.title.text == "" ? "No Title" : self.postView.title.text)!
        let description : String = (self.postView.description.text == "" ? "No Description" : self.postView.description.text)!
        
        for image in listImage{
            let request : OFFlickrAPIRequest = OFFlickrAPIRequest.init(apiContext: Constant.ObjCContext)
            request.delegate = self
            
            let inputStream : InputStream = InputStream.init(data: image.jpegData(compressionQuality: 0.1)!)
            request.uploadImageStream(inputStream, suggestedFilename: "foo.jpg", mimeType: "image/jpeg", arguments: [
                "is_public" : "1",
                "async" : "1",
                "title" : title,
                "description" : description
            ])
            listRequest.append(request)
        }
    }
    
    public func uploadPhotosURLs1(lobjImageToUpload:UIImage)
    {
        let secret =  Constant.UserSession.userOAuthSecret
        //where secret is 7e5cfde9b0023627
        let api_key = ProcessInfo.processInfo.environment["API_KEY"]!
        let auth_token = Constant.UserSession.userOAuthToken
        
        let imageData = lobjImageToUpload.jpegData(compressionQuality: 1)
        
        let uploadSig = "\(secret)_key\(api_key)_token\(auth_token)"
        let request = NSMutableURLRequest()
        let url = "https://up.flickr.com/services/upload/"
        request.url = URL(string: url)!
        request.httpMethod = "POST"
        
        
        let boundary = String("---------------------------7d44e178b0434")
        request.addValue(" multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let body:NSMutableData = NSMutableData()
        body.append("\r\n--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        
        body.append("Content-Disposition: form-data; name=\"api_key\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("\(api_key)\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition: form-data; name=\"auth_token\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("\(auth_token)\r\n".data(using: String.Encoding.utf8)!)
        
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition: form-data; name=\"api_sig\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("\(uploadSig)\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append(String("Content-Disposition: form-data; name=\"photo\"; filename=\"photo.jpg\"\r\n").data(using: String.Encoding.utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: String.Encoding.utf8)!)
        
        body.append(imageData!)
        body.append("\r\n--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        
        request.httpBody = Data(body.subdata(with: NSRange(location: 0, length: body.length)))
        
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest,
                                    completionHandler: {(data, response, error) in
            if let error = error {
                print(error)
            }
            if let data = data{
                print("data =\(data)")
            }
            if let response = response {
                print("url = \(response.url!)")
                print("response = \(response)")
                let httpResponse = response as! HTTPURLResponse
                print("response code = \(httpResponse.statusCode)")
                print("DATA = \(String(describing: data))")
                //if you response is json do the following
                do{
                    let resultJSON = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions())
                    let arrayJSON = resultJSON as! NSArray
                    for value in arrayJSON{
                        let dicValue = value as! NSDictionary
                        for (key, value) in dicValue {
                            print("key = \(key)")
                            print("value = \(value)")
                        }
                    }
                    
                }catch _{
                    print("Received not-well-formatted JSON")
                }
            }
        })
        task.resume()
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
