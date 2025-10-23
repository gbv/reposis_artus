
# artus

## Installation Instructions

* run `mvn clean install`
* copy jar to ~/.mycore/(dev-)mir/lib/

## Development

You can add these to your ~/.mycore/(dev-)mir/.mycore.properties
```
MCR.Developer.Resource.Override=/path/to/reposis_artus/src/main/resources
MCR.LayoutService.LastModifiedCheckPeriod=0
MCR.UseXSLTemplateCache=false
MCR.SASS.DeveloperMode=true
```

For SOLR
in [$MIR-HOME]/data/solr/configsets/mycore_main/conf/managed-schema add the following field:

```
<field name="artus.sections" type="string" indexed="true" stored="true" multiValued="false"/>
```