<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:mods="http://www.loc.gov/mods/v3"
                exclude-result-prefixes="mods">


  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>



  <xsl:template match="mods:name">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>


      <xsl:if test="not(mods:displayForm)">
        <mods:displayForm>
          <xsl:choose>
            <!-- Japanese order? -->
            <xsl:when test="ancestor::mods:mods/mods:classification[contains(@valueURI,'artus_sections#japan')]">
              <xsl:value-of select="concat(mods:namePart[@type='family'], ' ', mods:namePart[@type='given'])"/>
            </xsl:when>

            <!-- Default order -->
            <xsl:otherwise>
              <xsl:value-of select="concat(mods:namePart[@type='given'], ' ', mods:namePart[@type='family'])"/>
            </xsl:otherwise>
          </xsl:choose>
        </mods:displayForm>
      </xsl:if>

      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="mods:abstract">
    <xsl:variable name="lang" select="ancestor::mods:mods/mods:language/mods:languageTerm[@type='code' and @authority='rfc5646']"/>
    <xsl:copy>
      <xsl:if test="$lang">
        <xsl:attribute name="xml:lang">
          <xsl:value-of select="$lang"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!-- Swap valueURI for artus_parts classifications -->
  <xsl:template match="mods:classification[@authorityURI='https://arthurianbibliography.info/classifications/artus_parts']">
    <xsl:copy>
      <!-- Copy all attributes except valueURI -->
      <xsl:copy-of select="@*[local-name() != 'valueURI']"/>

      <!-- Rebuild valueURI cleanly -->
      <xsl:attribute name="valueURI">
        <xsl:variable name="clean" select="normalize-space(@valueURI)"/>
        <xsl:choose>
          <xsl:when test="$clean = 'https://arthurianbibliography.info/classifications/artus_parts#TTA'">
            <xsl:attribute name="valueURI">
              <xsl:value-of select="normalize-space('https://arthurianbibliography.info/classifications/artus_parts#CHS')"/>
            </xsl:attribute>
          </xsl:when>
          <xsl:when test="$clean = 'https://arthurianbibliography.info/classifications/artus_parts#CHS'">
            <xsl:attribute name="valueURI">
              <xsl:value-of select="normalize-space('https://arthurianbibliography.info/classifications/artus_parts#TTA')"/>
            </xsl:attribute>          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$clean"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>

      <!-- Copy children -->
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="mods:genre[
        @authorityURI='http://www.mycore.org/classifications/mir_genres'
        and @valueURI='http://www.mycore.org/classifications/mir_genres#thesis'
        and ../mods:genre[@valueURI='http://www.mycore.org/classifications/mir_genres#dissertation']
    ]"/>
</xsl:stylesheet>
