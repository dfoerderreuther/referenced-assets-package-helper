#!/bin/sh

if [ "$#" -lt 2 ]; then
  echo "Usage: " >&2
  echo "$0 pathToSearchIn packagename" >&2
  exit 1
fi

searchpath=$1
packagename=$2
# create empty package definition
./package.sh $packagename

tmpfile=_added_filter.xml
folder=build

# grep for well formated asset paths in $searchpath. Regex is pretty strict as some special characters may brake the definition in filter.xml.
grep -irohE '\"/content/dam/[a-zA-Z0-9\/_-]*\.(jpg|jpeg|png|pdf|mp4|svg)\"' $searchpath > $tmpfile

lines=$(wc -l < $tmpfile | tr -d ' ')

# reformat path list to xml
sed -i '' -e 's/^"/<filter root="/' $tmpfile
sed -i '' -e 's/"$/" \/>/' $tmpfile

# build filter.xml
echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > $folder/META-INF/vault/filter.xml
echo "<workspaceFilter version=\"1.0\">" >> $folder/META-INF/vault/filter.xml
cat $tmpfile >> $folder/META-INF/vault/filter.xml
echo "</workspaceFilter>" >> $folder/META-INF/vault/filter.xml

rm $tmpfile

# zip up package
cd $folder
zip -qr ../$packagename.zip .
cd ..

echo "Created empty package with name $packagename.zip"
echo "The package contains a filter with $lines well formated asset paths that could be collected from "
echo $searchpath
echo ""
echo "Upload $packagename.zip to an AEM instance that contains the required assets and press 'build'. "
echo "Download the package and bring it to the instance with the missing assets."
