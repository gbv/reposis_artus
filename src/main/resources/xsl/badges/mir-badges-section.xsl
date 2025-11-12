<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:mods="http://www.loc.gov/mods/v3"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                exclude-result-prefixes="mods xlink">

    <xsl:import href="xslImport:badges:badges/mir-badges-section.xsl"/>
    <xsl:include href="resource:xsl/badges/mir-badges-style-template.xsl"/>

    <xsl:variable name="tooltip-sections"
                  select="substring-before(document('i18n:component.mods.metaData.dictionary.artus_sections')/i18n/text(), ':')"/>

    <xsl:template match="doc" mode="resultList">
        <xsl:apply-imports/>
        <xsl:if test="str[@name='artus_sections']">
        <xsl:for-each select="str[@name='artus_sections']/text()">
            <xsl:variable name="label">
                <xsl:variable name="displayname" select="document(concat('callJava:org.mycore.common.xml.MCRXMLFunctions:getDisplayName:artus_sections:', .))"/>
                <xsl:choose>
                <xsl:when
                        test="string-length($displayname) > 30">
                    <xsl:value-of select="."/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$displayname"/>
                </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="categid" select="."/>
            <xsl:call-template name="output-badge">
                <xsl:with-param name="of-type" select="'hit_section'"/>
                <xsl:with-param name="badge-type" select="'badge-secondary'"/>
                <xsl:with-param name="link"
                                select="concat($ServletsBaseURL, 'solr/find?condQuery=*&amp;fq=', 'artus_sections', ':','%22', $categid, '%22')"/>
                <xsl:with-param name="label"
                                select="$label"/>
                <xsl:with-param name="tooltip" select="$tooltip-sections"/>
            </xsl:call-template>
        </xsl:for-each>
        </xsl:if>
    </xsl:template>


    <xsl:template match="mycoreobject" mode="mycoreobject-badge">
        <xsl:apply-imports/>
        <xsl:for-each select="//mods:mods/mods:classification[
        @authorityURI='https://arthurianbibliography.info/classifications/artus_sections']">
            <xsl:variable name="categid" select="substring-after(@valueURI, '#')"/>
            <xsl:variable name="class">
                <xsl:value-of select="substring-after(@valueURI, '#')" />
            </xsl:variable>
            <xsl:variable name="label"
                          select="document(concat('classification:metadata:-1:children:artus_sections', ':', $categid))
                //category/label[@xml:lang=$CurrentLang]/@text"/>

            <!-- Generate the badge -->
            <xsl:call-template name="output-badge">
                <xsl:with-param name="of-type" select="'hit_section'"/>
                <xsl:with-param name="badge-type" select="'badge-secondary'"/>
                <xsl:with-param name="label" select="$label"/>
                <xsl:with-param name="link"
                                select="concat($ServletsBaseURL,
                               'solr/find?condQuery=*&amp;fq=artus_sections:%22',
                               $categid, '%22')"/>
                <xsl:with-param name="tooltip" select="$tooltip-sections"/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
