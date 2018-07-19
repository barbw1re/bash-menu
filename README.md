# Bash Menu

Bash Menu is a Bash script to easily allow you to add a menu to your own scripts.

You can add an interactive menu like the following to your own scripts with just a few simple steps:

![Bash Menu](https://raw.githubusercontent.com/barbw1re/bash-menu/bash-menu-meta/bash-menu.png)


## Features

The Bash Menu will clear the screen and display a menu as shown above. You can select the menu item currently highlighted by pressing Enter. You can navigate the options using the following methods:

* Up and Down arrow keys will move to previous and next menu item.
* Pressing Up on the top menu item will move to the last menu item (and Down on the last will move you to the first item).
* Pressing Esc will jump you to the last menu item (a convenience as we assume the last item is the Exit menu item).
* Pressing Esc while on the last menu item will run that action, the same as pressing Enter on it (I like to double press Esc to quickly exit).
* Entering the first letter/number (case-insensitive) of a menu item will jump you to that item - if you have multiple menu items starting with the same letter, it will jump you to the first occurrence.


## Prerequisites

This script, unsurprisingly based on the name, requires to be run in a Bash shell and will terminate when run by `/bin/sh` or `/bin/dash` (for example).

What I like to do at the top of my scripts is to ensure this by adding the code:

```
# Ensure we are running under bash
if [ "$BASH_SOURCE" = "" ]; then
    /bin/bash "$0"
    exit 0
fi
```

The `bash-menu.sh` script includes (and needs) the `bash-draw.sh` script and requires it to be located in the same directory as `bash-menu.sh`. These scripts do not need to be in the same directory as your main script, however, so it is perfectly fine to source the `bash-menu.sh` script into your scripts from any location.


## Usage

See the `demo.sh` script for an introduction to how to incorporate Bash Menu in your own scripts, but the quick steps would be:


### Step 1. Download the Bash Menu scripts

Download `bash-menu.sh` and `bash-draw.sh` and put them somewhere (in the same directory as each other).


### Step 2. Import Bash Menu into your own script

Somewhere in your own Bash script, before you want to use or configure a menu, you should import the `bash-menu.sh` script, either via (assuming the same directory as your script):

```
source bash-menu.sh
```

or simply:

```
. bash-menu.sh
```


### Step 3. Create handlers for each menu item

Create a handler function for each menu item.

When the corresponding menu item is selected, the screen will be cleared and the function called. The function is provided no parameters and should return either `1` or `0`.

* **1** indicates that the menu should resume
* **0** indicates that the menu should quit


### Step 4. Setup menu items

Two arrays need to be populated for the menu; one containing the menu item labels, and the other containing the associated handler functions as created in the previous step.

```
menuItems=(
    "1. Item 1"
    "2. Item 2"
    "Q. Exit  "
)
menuActions=(
    actionA
    actionB
    actionExit
)
```

**NOTE**: If the menu item labels are different lengths, the menu highlighting of the active menu item will look a bit odd, so it is best to ensure they are the same length by adding spaces to the end as needed.

**NOTE**: It is your responsibility to ensure there are the same number of menu item labels and actions.


### Step 5. Override menu configuration as needed

There are a few variables used by Bash Menu which you can override and affect how the menu is displayed. These can also be found at the top of `bash-menu.sh`.

**Layout**

* menuTop - The top row of menu (defaults to row 2, ie 1 blank line at the top).
* menuLeft - The left column where the menu item label text should start (defaults to column 15).
* menuWidth - The width of the menu box - not including the left margin, but including the border (defaults to 42 columns).
* menuMargin - The left gap before drawing the menu border (defaults to column 4)

**Colours**
(See top of `bash-draw.sh` for available colours)

* menuColour - The colour of menu text (defaults to $DRAW_COL_WHITE).
* menuHighlight - The highlight colour for menu (defaults to $DRAW_COL_GREEN).

**Labels**

* menuTitle - Title of menu.
* menuFooter - Text to display at bottom of menu


### Step 6. Display the Menu

Now that everything is setup - displaying the menu is as simple as adding the following to your script:

```
menuInit
menuLoop
```


The `menuLoop` function will continue until a menu item is selected which returns `0` - at which time the screen is cleared and control returns to the next line in your script.


## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/barbw1re/bash-menu/tags).


## Authors

* **Kris Johnson** - *Initial work* - [barbw1re](https://github.com/barbw1re)

See also the list of [contributors](https://github.com/barbw1re/bash-menu/contributors) who participated in this project.


## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.


## Acknowledgments

Bash Menu was only made possible (or at least, was made with less wheel re-inventing) by the knowledge provided at [top-scripts blog](http://top-scripts.blogspot.com/2011/01/blog-post.html).

