# Civilbudget iOS
This is a client for Civilsbudget service which allows people to vote for civil projects in convenient manner. More information about service you can find [here](https://github.com/civils-council/civilsbudget/blob/master/README.md).
App supports authorization through Ukrainian [BankID](https://bankid.org.ua) user verification system.
# Requirements
* iOS 8.0+
* Xcode 7.0+
* CocoaPods 0.39.0.beta.5+

Please note that app uses CocoaPods with '--no-integrate' switch (without Workspace creation). To install dependencies you should run
```
./podinstall.sh
```
from `./Civilbudget/Classes/Externals/Pods/` folder.
# Notes
Please keep in mind that this project violates KISS principle in favor of application speed on legacy iOS devices (like iPhone 4, 4s, 5, 5s) which are widespread among the target audience of this service.
