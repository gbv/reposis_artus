<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:mods="http://www.loc.gov/mods/v3"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                exclude-result-prefixes="mods xlink">

    <xsl:import href="xslImport:badges:badges/mir-badges-section.xsl"/>
    <xsl:include href="resource:xsl/badges/mir-badges-utils.xsl"/>
    <xsl:param name="CurrentLang"/>
    <xsl:variable name="tooltip-sections"
                  select="substring-before(document('i18n:component.mods.metaData.dictionary.artus_sections')/i18n/text(), ':')"/>


    <xsl:template match="doc" mode="badge">
        <xsl:apply-imports/>
            <xsl:if test="str[@name='artus.sections']">
                <xsl:for-each select="str[@name='artus.sections']/text()">
                    <xsl:call-template name="output-sections-badge">
                        <xsl:with-param name="categid" select="."/>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:if>
    </xsl:template>

    <xsl:template name="output-sections-badge">
        <xsl:param name="categid"/>
        <xsl:variable name="label"
                      select="document(concat('classification:metadata:-1:children:artus_sections', ':', $categid))
                //category/label[@xml:lang=$CurrentLang]/@text"/>
        <xsl:call-template name="output-badge">
            <xsl:with-param name="class" select="'text-bg-secondary'"/>
            <xsl:with-param name="label" select="$label"/>
            <xsl:with-param name="link" select="concat($ServletsBaseURL,
                              'solr/find?condQuery=*&amp;fq=artus.sections:%22',$categid, '%22')"/>
            <xsl:with-param name="tooltip" select="$tooltip-sections"/>
        </xsl:call-template>
    </xsl:template>
</xsl:stylesheet>
