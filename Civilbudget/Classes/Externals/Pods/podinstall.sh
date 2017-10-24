#!/bin/sh

pod _1.1.0_ install

echo 'Replacing $PODS_ROOT in xcconfig files'
sed -i '' 's|${SRCROOT}/Pods|${SRCROOT}/Civilbudget/Classes/Externals/Pods/Pods|g' './Pods/Target Support Files/Pods-Civilbudget/Pods-Civilbudget.debug.xcconfig'
sed -i '' 's|${SRCROOT}/Pods|${SRCROOT}/Civilbudget/Classes/Externals/Pods/Pods|g' './Pods/Target Support Files/Pods-Civilbudget/Pods-Civilbudget.release.xcconfig'

echo 'Removing xcworkspace file'
rm -rf Civilbudget.xcworkspace