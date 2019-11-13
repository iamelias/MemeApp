# MemeApp, iOS Developer: Elias H.
Meme creating app. 
**************************


**Overview:**
This app is built using UIKIt to be a meme creating/saving/sharing app. It stores saved/shared Memes in a table view and a collection view, both interchangable by tab. Contains 1 Tab Bar Controller, 2 Navigation Controllers, 1 Table View Controller, 1 Collection View Controller, and 2 View Controllers.

**MemeTableViewController.swift:**
Accesses saved Meme Array in appDelegate.swift. Table row height is set to 90.0. Pushes to MemeDetailViewController when row is selected. Can switch to MemeCollectionViewController through tab on bottom. Presents Modally MemeEditorViewController.swift to add Meme

**MemeCollectionViewController.swift:**
Accesses saved Meme Array in appDelegate.swift. Pushes to MemeDetailViewController when row is selected. Can switch to MemeTableViewController through tab on bottom. Presents Modally MemeEditorViewController.swift to add Meme

**MemeCollectionViewCell.swift:**
Used by MemeCollectionViewController.swift to connect reusable cell

**MemeEditorViewController.swift:**
Meme is created using ImagePickerController and by editing text. Meme is sent/saved using UIActivityViewController, When meme is saved/sent it's properties are stored in a Meme's Struct. Meme's structs properties are accessed and saved in Meme Array in appDelegate.Swift for access by the MemeCollectionViewController.swift and MemeTableViewController.swift. "Cancel" UIButton resets the meme and dismisses the MemeEditorViewController.

**MemeDetailController.swift:**
Shows an enlarged version of the image in the table/collection view. hides tab bar.

**AppDelegate.swift:**
Stores saved and updated memes to be used by MemeCollectionViewController.swift and MemeTableViewController.swift

**info.plist:**
Added Privacy- Photo Library Additions Usage Descriptions, Privacy- Photo Library Usage Description, Privacy- Camera Usage Description so app can work on physical device
