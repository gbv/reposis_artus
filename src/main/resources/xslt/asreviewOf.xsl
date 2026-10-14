<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mods="http://www.loc.gov/mods/v3">
  <xsl:template match="mycoreobject">

    <xsl:variable name="reviewedTitle" select="metadata/def.modsContainer/modsContainer/mods:mods/mods:titleInfo/mods:title"/>

    <mycoreobject xmlns:xlink="http://www.w3.org/1999/xlink" >
      <metadata>
        <def.modsContainer class="MCRMetaXML" heritable="false" notinherit="true">
          <modsContainer inherited="0">
            <mods:mods xmlns:mods="http://www.loc.gov/mods/v3">
              <mods:genre authorityURI="http://www.mycore.org/classifications/mir_genres" valueURI="http://www.mycore.org/classifications/mir_genres#article">article</mods:genre>
              <mods:titleInfo>
                <mods:title>
                  <xsl:text>Review of "</xsl:text>
                  <xsl:value-of select="$reviewedTitle"/>
                  <xsl:text>"</xsl:text>
                </mods:title>
              </mods:titleInfo>

              <mods:relatedItem type="reviewOf" xlink:href="{@ID}" xlink:type="simple">
                <xsl:copy-of select="metadata/def.modsContainer/modsContainer/mods:mods/*" />
              </mods:relatedItem>

            </mods:mods>
          </modsContainer>
        </def.modsContainer>
      </metadata>
    </mycoreobject>
  </xsl:template>
</xsl:stylesheet>
