//
//  InfoViewController.swift
//  Strum
//
//  Created by Charles Fries on 12/7/16.
//  Copyright © 2016 Figure Inc. All rights reserved.
//

import UIKit

class Info: UITableViewController
{
    override func viewDidAppear(_ animated: Bool)
    {
        UIApplication.shared.statusBarStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.section == 0
        {
            if indexPath.row == 0
            {
                
            }
            else if indexPath.row == 1
            {
                UIApplication.shared.openURL(URL(string: "http://usefigure.com/faq")!)
            }
            else if indexPath.row == 2
            {
                UIApplication.shared.openURL(URL(string: "mailto:support@usefigure.com")!)
            }
        }
        else if indexPath.section == 1
        {
            if indexPath.row == 0
            {
                UIApplication.shared.openURL(URL(string: "http://usefigure.com/strum")!)
            }
            else if indexPath.row == 1
            {
                UIApplication.shared.openURL(URL(string: "http://usefigure.com")!)
            }
            else if indexPath.row == 2
            {
                
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func done()
    {
        dismiss(animated: true, completion: nil)
    }
}
