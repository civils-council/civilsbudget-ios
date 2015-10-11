#!/bin/sh

pod _0.39.0.beta.5_ install --no-integrate

sed -i '' 's|${SRCROOT}/Pods|${SRCROOT}/Civilbudget/Classes/Externals/Pods/Pods|g' './Pods/Target Support Files/Pods-Civilbudget/Pods-Civilbudget.debug.xcconfig'
sed -i '' 's|${SRCROOT}/Pods|${SRCROOT}/Civilbudget/Classes/Externals/Pods/Pods|g' './Pods/Target Support Files/Pods-Civilbudget/Pods-Civilbudget.release.xcconfig'
echo 'Replacing $PODS_ROOT in xcconfig files'
