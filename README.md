# Team Peer Feedback Application
DECO3801 Project created by The Super 6!!!!!!

This codebase can be deployed as an application to any of the following platforms
- Web
- Android
- iOS
- Windows
- macOS
- Linux

A web version of the application is currently active [here](https://deco3801-thesupersix.uqcloud.net)

## Installation & Setup
To compile and run the codebase you must have the Flutter development environment installed. 

Instructions on how to install and setup this environment can be found on the Flutter documentation website [here](https://docs.flutter.dev/get-started/install). 
Steps 1 and 2 must be completed before cloning the codebase. Visual Studio Code is the recommended editor to use.

Once the environment is setup, clone the repository by running

&emsp; `git clone https://github.com/eamonsuo/TheSuper6_TeamPeerFeedback.git`

Once the codebase has been cloned (or if you have downloaded it), it can be opened in your chosen editor.

On first opening the codebase, you need to install the required packages. This can be done by navigation to the terminal and running

&emsp; `cd [path to project]\TheSuper6_TeamPeerFeedback`

&emsp; `flutter pub get`

This will install the required dependencies.

In order to run the codebase, navigate to the `main.dart` file located in `lib/` and click run and debug. 
The platform on which the application is compiled can be changed as well. Instructions on how to do it for some editors can be found [here](https://docs.flutter.dev/get-started/test-drive?tab=vscode)

## Additional Files & Data

#### Server Side Files
Additional files were written (in PHP) to access data from the remote MySQL database. 
These files are stored on our team's UQZone server but copies were included in the DECO3801 submission in the folder Additional_Files.

#### Data Used For Application
The data used for this application was constructed by our team to best detail the application's features.
The data is stored in a MySQL database which is hosted on our team's UQZone server.

A copy of the data (in PDF form) was included in the DECO3801 submission in the folder Additional_Files.
This data was current as of the submission date (19/10/2022)

## External Resources Used
The code written for the server side REST API and the code written in lib/databaseElements was inspired by code written by Vipin Vijayan (2019). 

The video tutorial the code was found through can be accessed on [Youtube here](https://www.youtube.com/watch?v=F4Q6lEhmwCY).

## Summary of Software Used
- Flutter framework, utilising the Dart language to develop the application
- PHP to write a REST API which accesses the database
- A remote MySQL database to store the application's data
- UQZone cloud server to allow remote access to data and to host website deployment

## Authors
Application designed by: Miguel Dewi Castro & Luke Cronin

Application developed by: Levi Stubbs, Hayden Padget, Jack Jobling & Eamon Suosaari
