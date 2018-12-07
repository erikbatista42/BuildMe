//
//  Docs.string.swift
//  BuildMe
//
//  Created by luxury on 11/10/18.
//  Copyright © 2018 luxury. All rights reserved.
//


/*
 PROBLEMS FACED:
 
 1) Ran into bug where I was trying to display the name of the category I was in on navigation bar title
 So, if I clicked on "Craft" (in HomeController), I wanted to display "Craft" in VideosController navigation bar title.
 
 **Thought that was going to work:**
 - I was writing categories[indexPath.row] in cellForItemAt. This didn't work because when the view loaded, it only read the last element.
 
 **Tried:**
 - Messing with protocols and delegates
 - Static variables
 
 <Solution:>
    - Created a static var named 'currentCategory' in VideosController then, I wrote VideosController.currentCategory = categories[indexPath.row] in didSelectItemAt (in HomeController)
    - This worked because it readed the array only when clicked on a specific cell
 
 Current Bugs:
 - ?
 */
