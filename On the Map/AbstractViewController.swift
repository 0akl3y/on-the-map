//
//  AbstractViewController.swift
//  On the Map
//
//  Created by Johannes Eichler on 18.06.15.
//  Copyright (c) 2015 Eichler. All rights reserved.
//
// This VC actually serves as an abstract class for OTM VC with common behavior

import UIKit

class AbstractViewController: UIViewController {
    
    var cache:CachedResponses {
        get{ return CachedResponses.cachedResponses() }
    }
    
    var errorMessageVC: StatusViewController?
    
    //The reload indicator serves as spinner for bar button items
    var reloadIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    
    func addStatusView(){
        
        //add a status view that displays errorMessages and a large loading indicator
        
        self.errorMessageVC = StatusViewController()

        self.addChildViewController(self.errorMessageVC!)
        self.view.addSubview(self.errorMessageVC!.view)
        self.errorMessageVC!.didMoveToParentViewController(self)
        
    }
    
    
    func displayErrorMessage(error:NSError){

        self.errorMessageVC!.error = error
        self.errorMessageVC!.showLoginErrorMessage()    
    
    }
    
    
    func startReloadIndicator(forButton:UIBarButtonItem?){
        
        if(forButton != nil){
            
            // Based on an idea from Anoop Vaidya
            // http://stackoverflow.com/questions/14318368/uibarbuttonitem-how-can-i-find-its-frame
            
            if var barButtonView = forButton?.valueForKey("view") as? UIView{
                
                // the reload indicator needs to be centered as there is an ugly offset that moves it to the left at start
                self.reloadIndicator.frame = barButtonView.frame
            
            }
            
            forButton!.customView = reloadIndicator
            
            self.reloadIndicator.color = UIColor.blueColor()
            self.reloadIndicator.startAnimating()
        
        }
    
    }
    
    func stopReloadIndicator(forButton:UIBarButtonItem?){
        
        if(forButton != nil){
            
            self.reloadIndicator.stopAnimating()
            forButton!.customView = nil            
        }
    }
    
    
    func performLogout(){
        
        let FBSession = FBSDKLoginManager()
        FBSession.logOut()
        FBSDKAccessToken.setCurrentAccessToken(nil)
        
        self.cache.userData = nil
        self.dismissViewControllerAnimated(true, completion: nil)
    
    }

    

}