### Step 1: Install AutoHotkey

First, you need to install the AutoHotkey program itself. We are using version 2.0, as the script is written for this version.

- Go to the official AutoHotkey website: [https://www.autohotkey.com/](https://www.autohotkey.com/)
    
- Click the **"Download"** button and then select **"Download v2.0"**.
    
- Run the downloaded installer and follow the on-screen prompts to install it. The default settings are fine.
    

### Step 2: Set Up the Virtual Desktop Library

To create reliable virtual desktop shortcuts, you need a powerful library that can interact with Windows.

1. Create a dedicated library folder: In your AutoHotkey scripts folder, create a new folder named Lib. The path should be something like:
    
    C:\Users\MaruthiSharma\Documents\AutoHotkey\Lib
    
2. **Download the library file:**
    
    - Go to the `VD.ahk` GitHub page: [https://github.com/FuPeiJiang/VD.ahk/tree/v2_port](https://github.com/FuPeiJiang/VD.ahk/tree/v2_port)
        
    - Click the file named `VD.ahk`.
        
    - Click the "Raw" button and save the file into your new `Lib` folder, ensuring the name is exactly `VD.ahk`.
        

### Step 3: Create Your Main Shortcut Script

This is the script that you will run. It will use the library you just downloaded.

1. Open a text editor (like Notepad).
2. Copy the script in this repo
3. Save the file in your AutoHotkey folder (outside of the `Lib` folder) with the name `Desktop.ahk`.
    

### Step 4: Run the Script for the First Time

You can now run your script. The `&` command we used in PowerShell is the most reliable method:

1. Open PowerShell.
    
2. Enter the following command and press Enter:
    
    & "C:\Program Files\AutoHotkey\v2\AutoHotKey.exe" "C:\Users\MaruthiSharma\Documents\AutoHotkey\Desktop.ahk"
    
3. Check your system tray (the area next to the clock) for a green "H" icon, which indicates the script is running.
    

### Step 5: Test Your New Shortcuts

The shortcuts are now active.

- Press **`Alt + Shift + D`** to create a new virtual desktop and switch to it.
- Press **`Alt + 1`** to go to the first desktop.
- Press **`Alt + 2`** to go to the second desktop.
- Press **`Alt + 3`** to go to the third desktop, and so on.
    

### Step 6: Make the Script Start Automatically

To ensure the script runs every time you log in, place a shortcut to it in the Windows Startup folder.

1. Press **`Win + R`** to open the Run dialog.
2. Type `shell:startup` and press Enter. This will open your Startup folder.
3. Navigate to your script file `C:\Users\MaruthiSharma\Documents\AutoHotkey\Desktop.ahk`.
4. Right-click the file and select **"Show more options" > "Create shortcut"**.
5. Cut the newly created shortcut file and paste it into the Startup folder you opened.
    

You are all set! Your custom virtual desktop shortcuts will now work every time you log in to Windows.

I also used claude code to retain apps in primary desktop while switching 
