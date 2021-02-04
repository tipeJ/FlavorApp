# FlavorApp

## What is this?

FlavorApp is a cross-platform application designed to display tasty flavor combinations. The application contains recommendations for (almost) every flavor in existence.

Future features will include seasonal information and multi-flavor searching.

## How do I use it?

1.  Install the software by following the link to Google Play Store or by downloading the installer in the releases page.
2.  Search the main screen for the flavor you need, either by scrolling or using the search functionality.
3.  The flavor details screen will display the most recommended flavour at the top of the list, leaving the less common recommendations at the bottom. You can change this sorting to alphabetical.

 You can flag the flavor as **favourite** by clicking the bookmark icon at the top of the details page, which adds the flavor to the favourites list, which can be accessed via the bottom navigation bar.

 ## Availablility

 The application is not yet available on google play. However, it can be downloaded via the release page. While dart technically supports IOS and MacOS, this application will most likely not be available for either platform any time soon, as I lack both apple hardware and the will to run OSX in a VM.

 Currently tested and built on linux. Windows has been tested, but not built.

 ## Screenshots

 ![List Page](screenshots/list.png)
 ![Details Page](screenshots/list.png)
 ![List Page](screenshots/list.png)

 ## Building from source

 Download this git repo (obviously), create a folder within called _assets_, in which you should add a .json file named _flavordata_. This file must contain the details of every flavor you want to include in a list format. The details of the parser can be found by looking at the code in the models directory. You can supply this information by yourself, or by [running a parser](https://github.com/tipeJ/FlavorExtractor). The choice is yours.
