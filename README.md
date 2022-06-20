# Referenced assets package helper

This script is searching (grep) for referenced assets in a downloaded and unpacked AEM package. A new and empty package with the references to the assets in filter.xml will be created. The new package can be uploaded and built on an AEM server to collect the assets in the package.

## Use case: 

You received a package from your customer that only contains pages from /content/... Required assets are not part of the package. The entire /content/dam folder is to large to pack. 

## Usage

### 1. Create empty package:

First parameter is path to an AEM page of an extracted AEM package. Second parameter is the name of a new package which eventually will contain the missing assets.

./run.sh ../path/to/crx_root/content/we-retail/us/en/experience we-retail-en-experience-assets

Result: 

we-retail-en-experience-assets.zip with all grepped asset paths from ../path/to/crx_root/content/we-retail/us/en/experience in filter.xml

### 2. Build package

Upload we-retail-en-experience-assets.zip to the AEM instance that contains the referenced assets. Press "build" to load the assets into the package.

### 3. Download package

Download the package we-retail-en-experience-assets.zip which now contains the assets.

## Remarks

Tested on Mac only. Parts of the bash scripts - especially the grep command in run.sh line 18 - may require changes on other platforms.