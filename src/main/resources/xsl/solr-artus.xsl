<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mods="http://www.loc.gov/mods/v3" xmlns:mcrxml="xalan://org.mycore.common.xml.MCRXMLFunctions"
                xmlns:xalan="http://xml.apache.org/xalan"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                exclude-result-prefixes="mods xlink"
>
    <xsl:import href="xslImport:solr-document:mir-solr.xsl" />
    <xsl:include href="mods-utils.xsl" />

    <xsl:template match="mycoreobject[contains(@ID,'_mods_')]">
        <xsl:apply-imports />
        <xsl:apply-templates select="metadata/def.modsContainer/modsContainer/mods:mods" mode="artus"/>
        <field name="hasFiles">
            <xsl:value-of select="count(structure/derobjects/derobject)&gt;0" />
        </field>
    </xsl:template>


    <xsl:template match="mods:mods" mode="artus">
        <xsl:for-each select="mods:classification[
        @authorityURI='https://arthurianbibliography.info/classifications/artus_sections']">
            <field name="artus.sections">
                <xsl:value-of select="substring-after(@valueURI, '#')" />
            </field>
        </xsl:for-each>
        <xsl:for-each select="mods:classification[
        @authorityURI='https://arthurianbibliography.info/classifications/artus_parts']">
            <field name="artus.parts">
                <xsl:value-of select="substring-after(@valueURI, '#')" />
            </field>
        </xsl:for-each>

    </xsl:template>

</xsl:stylesheet>
