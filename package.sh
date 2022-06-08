#!/bin/sh

if [ "$#" -lt 1 ]; then
  echo "Usage: " >&2
  echo "$0 package_name" >&2
  exit 1
fi

package_name=$1

package_group="my_packages"



folder=build

rm -Rf build

mkdir -p $folder/jcr_root
mkdir -p $folder/META-INF/vault/definition

echo "Manifest-Version: 1.0
Content-Package-Id: my_packages:simple
Content-Package-Type: mixed" => $folder/META-INF/MANIFEST.MF

echo '<?xml version="1.0" encoding="UTF-8"?>
<jcr:root xmlns:sling="http://sling.apache.org/jcr/sling/1.0" xmlns:jcr="http://www.jcp.org/jcr/1.0" xmlns:rep="internal"
    jcr:mixinTypes="[rep:AccessControllable,rep:RepoAccessControllable]"
    jcr:primaryType="rep:root"
    sling:resourceType="sling:redirect"
    sling:target="/index.html"/>' => $folder/jcr_root/.content.xml


echo '<vaultfs version="1.1">
    <aggregates>
        <aggregate type="file" title="File Aggregate"/>
        <aggregate type="filefolder" title="File/Folder Aggregate"/>
        <aggregate type="nodetype" title="Node Type Aggregate" />
        <aggregate type="full" title="Full Coverage Aggregate">
            <matches>
                <include nodeType="rep:AccessControl" respectSupertype="true" />
                <include nodeType="rep:Policy" respectSupertype="true" />
                <include nodeType="cq:Widget" respectSupertype="true" />
                <include nodeType="cq:EditConfig" respectSupertype="true" />
                <include nodeType="cq:WorkflowModel" respectSupertype="true" />
                <include nodeType="vlt:FullCoverage" respectSupertype="true" />
                <include nodeType="mix:language" respectSupertype="true" />
                <include nodeType="sling:OsgiConfig" respectSupertype="true" />
            </matches>
        </aggregate>
        <aggregate type="generic" title="Folder Aggregate">
            <matches>
                <include nodeType="nt:folder" respectSupertype="true" />
            </matches>
            <contains>
                <exclude isNode="true" />
            </contains>
        </aggregate>
        <aggregate type="generic" title="Default Aggregator" isDefault="true">
            <matches>
            </matches>
            <contains>
                <exclude nodeType="nt:hierarchyNode" respectSupertype="true" />
            </contains>
        </aggregate>

    </aggregates>
    <handlers>
        <handler type="folder"/>
        <handler type="file"/>
        <handler type="nodetype"/>
        <handler type="generic"/>
    </handlers>
</vaultfs>' > $folder/META-INF/vault/config.xml


echo '<?xml version="1.0" encoding="UTF-8"?>
<workspaceFilter version="1.0"/>' > $folder/META-INF/vault/filter.xml

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<jcr:root xmlns:vlt=\"http://www.day.com/jcr/vault/1.0\" xmlns:jcr=\"http://www.jcp.org/jcr/1.0\"
    jcr:created=\"{Date}2022-06-08T17:05:30.406+02:00\"
    jcr:createdBy=\"admin\"
    jcr:lastModified=\"{Date}2022-06-08T17:05:30.406+02:00\"
    jcr:lastModifiedBy=\"admin\"
    jcr:primaryType=\"vlt:PackageDefinition\"
    buildCount=\"1\"
    group=\"${package_group}\"
    lastUnwrapped=\"{Date}2022-06-08T17:05:30.406+02:00\"
    lastUnwrappedBy=\"admin\"
    lastWrapped=\"{Date}2022-06-08T17:05:30.406+02:00\"
    lastWrappedBy=\"admin\"
    name=\"${package_name}\"
    version=\"\"/>" > $folder/META-INF/vault/definition/.content.xml



echo "<'rep'='internal'>

[rep:RepoAccessControllable]
  mixin
  + rep:repoPolicy (rep:Policy) protected ignore" > $folder/META-INF/vault/nodetypes.cnd

  echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE properties SYSTEM \"http://java.sun.com/dtd/properties.dtd\">
<properties>
<comment>FileVault Package Properties</comment>
<entry key=\"packageType\">mixed</entry>
<entry key=\"lastWrappedBy\">admin</entry>
<entry key=\"packageFormatVersion\">2</entry>
<entry key=\"group\">${package_group}</entry>
<entry key=\"created\">2022-06-08T17:05:30.444+02:00</entry>
<entry key=\"lastModifiedBy\">admin</entry>
<entry key=\"buildCount\">1</entry>
<entry key=\"lastWrapped\">2022-06-08T17:05:30.406+02:00</entry>
<entry key=\"version\"></entry>
<entry key=\"dependencies\"></entry>
<entry key=\"createdBy\">admin</entry>
<entry key=\"name\">${package_name}</entry>
<entry key=\"lastModified\">2022-06-08T17:05:30.406+02:00</entry>
</properties>
" > $folder/META-INF/vault/properties.xml


