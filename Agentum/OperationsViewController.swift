//
//  OperationsViewController.swift
//  Agentum
//
//  Created by IMAC  on 09.08.15.
//
//

import UIKit
import MobileCoreServices
import MediaPlayer

class OperationsViewController: UIViewController , UITableViewDelegate, UITableViewDataSource,
UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet var table: UITableView!
    
    let textCellIdentifier = "operationCell"
    let textCellIdentifier2 = "operationCell2"
    
    var jobPlanID: Int = 0
    
    var jobTechOpAdapterArray: Array<JobTechOpAdapterModel> = []

    var newMedia: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureTableView()
        
        var jobTechOpReposit = JobTechOpReposit()
        jobTechOpReposit.generateJobTechOpList("\(jobPlanID)")
        jobTechOpAdapterArray =  jobTechOpReposit.jobTechOps
        
        //для эксперимента добавляем еще две операции с видео и формой
        var j1 = JobTechOpAdapterModel()
        j1.verifyWay = "form"
        j1.state = JobTechOpAdapterModel.State.STATE_IN_PROGRESS
        j1.techOpName = "test form operation"
        var j2 = JobTechOpAdapterModel()
        j2.verifyWay = "video"
        j2.state = JobTechOpAdapterModel.State.STATE_IN_PROGRESS
        j2.techOpName = "test video operation"
        
        jobTechOpAdapterArray.append(j1)
        jobTechOpAdapterArray.append(j2)
        
        table.reloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Configures
    
    func configureTableView() {
        table.rowHeight = UITableViewAutomaticDimension
        table.estimatedRowHeight = 160.0
    }

    
    // MARK:  UITableViewDelegate Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return jobTechOpAdapterArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var jtopam = jobTechOpAdapterArray[indexPath.row]
        var cellIdentifier = textCellIdentifier
        
        if(jtopam.countFiles?.intValue > 0){
            cellIdentifier = textCellIdentifier2
        }
        if let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as? OperationViewCell{
            if let name = jtopam.techOpName{
                cell.name.text = name as String
            }
            if let finishedDay = jtopam.FinishedDay{
                cell.date.text = finishedDay as String
            }
            if let status = jtopam.stateTypeValue{
                cell.status.text = status as String
            }
            if let countFile = jtopam.countFiles{
                cell.numberOfFiles.text = "Файлы(\(countFile.intValue))"
            }
            
            //работа с кнопкой 
            //вспомогательная функция, устанавливающая корректную картинку для кнопки
            //в зависимости от типа проверки операции
            func confVerifyWayImageImageCellForVerifyWay(verifyWay: NSString, imageView: UIImageView){
                switch verifyWay{
                case JobTechOpAdapterModel.VerifyWayType.PHOTO as String:
                    imageView.image = UIImage(named: "photo")
                    break
                case JobTechOpAdapterModel.VerifyWayType.VIDEO as String:
                    imageView.image = UIImage(named: "video")
                    break
                case JobTechOpAdapterModel.VerifyWayType.PHOTOFORM as String:
                    imageView.image = UIImage(named: "photo")
                    break
                case JobTechOpAdapterModel.VerifyWayType.FORM as String:
                    imageView.image = UIImage(named: "form")
                    break
                default:
                    imageView.image = UIImage(named: "default")
                    break
                }
            }
            
            if let state = jtopam.state{
                cell.startButton.tag = indexPath.row
                //конфигурируем кнопку в зависимости от состояния операции
                switch state{
                case JobTechOpAdapterModel.State.STATE_DONE:
                    cell.startButton.hidden = true
                    cell.verifyWayImage.hidden = true
                    break
                case JobTechOpAdapterModel.State.STATE_NOT_STARTED:
                    cell.startButton.hidden = false
                    cell.verifyWayImage.hidden = false
                    cell.verifyWayImage.image = UIImage(named: "play")
                    break
                case JobTechOpAdapterModel.State.STATE_IN_PROGRESS:
                    cell.startButton.hidden = false
                    cell.verifyWayImage.hidden = false
                    if let verifyWay = jtopam.verifyWay{
                        confVerifyWayImageImageCellForVerifyWay(verifyWay, cell.verifyWayImage)
                    }
                    break
                default:
                    cell.startButton.hidden = true
                    cell.verifyWayImage.hidden = true
                    break
                }
                
            }
            
            return cell
        }
        
        return UITableViewCell()
    }

    @IBAction func actionPressed(sender: UIButton) {
        //определяем откуда была вызвана кнопка
        let jtopam = jobTechOpAdapterArray[sender.tag]
        if let verifyWay = jtopam.verifyWay{
            switch verifyWay{
            case JobTechOpAdapterModel.VerifyWayType.PHOTO as String:
                self.useCamera(kUTTypeImage as NSString)
                break
            case JobTechOpAdapterModel.VerifyWayType.VIDEO as String:
                self.useCamera(kUTTypeMovie as NSString)
                break
            case JobTechOpAdapterModel.VerifyWayType.PHOTOFORM as String:
                self.useCamera(kUTTypeImage as NSString)
                break
            case JobTechOpAdapterModel.VerifyWayType.FORM as String:
                self.performSegueWithIdentifier("formSegue", sender: self)
                break
            default:
                
                break
            }
        }
    }
    
    // MARK: - Camera
    func useCamera(cameraUseType: NSString) {
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.Camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType =
                UIImagePickerControllerSourceType.Camera
            imagePicker.mediaTypes = [cameraUseType]
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true,
                completion: nil)
            newMedia = true
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        if mediaType == (kUTTypeMovie as! String) {
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            UIImageWriteToSavedPhotosAlbum(image, self, "image:didFinishSavingWithError:contextInfo:", nil)
            
                
        } else if mediaType == (kUTTypeMovie as! String) {
            let videoURL = info[UIImagePickerControllerMediaURL] as! NSURL
            if (newMedia == true) {
                let compatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(videoURL.path)
                if (compatible){
                    UISaveVideoAtPathToSavedPhotosAlbum(videoURL.path, self, "video:didFinishSavingWithError:contextInfo:", nil)
                }
            }
        }
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafePointer<Void>) {
        
        if error != nil {
            let alert = UIAlertController(title: "Save Failed",
                message: "Failed to save image",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            let cancelAction = UIAlertAction(title: "OK",
                style: .Cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true,
                completion: nil)
        }
    }
    
    func video(video: NSURL, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafePointer<Void>) {
        
        if error != nil {
            let alert = UIAlertController(title: "Save Failed",
                message: "Failed to save video",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            let cancelAction = UIAlertAction(title: "OK",
                style: .Cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true,
                completion: nil)
        }
    }

    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
