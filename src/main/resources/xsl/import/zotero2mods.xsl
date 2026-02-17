<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:mods="http://www.loc.gov/mods/v3">

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="mods:mods">
    <mods:mods>
      <xsl:apply-templates select="@*|node()"/>

<!--Change section and publish year here-->
<!--      <mods:classification-->
<!--        xmlns:mods="http://www.loc.gov/mods/v3"-->
<!--        authorityURI="https://arthurianbibliography.info/classifications/artus_sections"-->
<!--        displayLabel="artus_sections"-->
<!--        valueURI="https://arthurianbibliography.info/classifications/artus_sections#australia"/>-->
<!--      <xsl:if test="not(mods:originInfo)">-->
<!--        <mods:originInfo eventType="publication">-->
<!--          <mods:dateIssued encoding="w3cdtf">2024</mods:dateIssued>-->
<!--        </mods:originInfo>-->
<!--      </xsl:if>-->
    </mods:mods>
  </xsl:template>

  <xsl:template match="mods:titleInfo">
    <xsl:choose>
      <xsl:when test="contains(mods:title, ':')">
        <xsl:copy>
          <xsl:apply-templates select="@*"/>
          <mods:title>
            <xsl:value-of select="normalize-space(substring-before(mods:title, ':'))"/>
          </mods:title>
          <mods:subTitle>
            <xsl:value-of select="normalize-space(substring-after(mods:title, ':'))"/>
          </mods:subTitle>
        </xsl:copy>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="mods:genre[@authority='marcgt']" priority="2">
    <xsl:variable name="raw" select="normalize-space(.)"/>
    <xsl:variable name="norm">
      <xsl:call-template name="genre2genre">
        <xsl:with-param name="text" select="$raw"/>
      </xsl:call-template>
    </xsl:variable>

    <mods:genre type="intern"
                authorityURI="http://www.mycore.org/classifications/mir_genres"
                valueURI="http://www.mycore.org/classifications/mir_genres#{$norm}"/>
  </xsl:template>


  <xsl:template match="mods:genre[@authority='local'
                         and not(../mods:genre[@authority='marcgt'])]"
                priority="1">

    <xsl:variable name="raw" select="normalize-space(.)"/>
    <xsl:variable name="norm">
      <xsl:call-template name="genre2genre">
        <xsl:with-param name="text" select="$raw"/>
      </xsl:call-template>
    </xsl:variable>

    <mods:genre type="intern"
                authorityURI="http://www.mycore.org/classifications/mir_genres"
                valueURI="http://www.mycore.org/classifications/mir_genres#{$norm}"/>
  </xsl:template>
  <xsl:template match="mods:mods/mods:typeOfResource"/>

  <xsl:template match="mods:note">
    <xsl:choose>
      <xsl:when test="starts-with(., '#Bib:')">
        <xsl:variable name="clean" select="normalize-space(substring-after(., '#Bib:'))"/>
        <xsl:variable name="family"
                      select="substring-after($clean, substring-before($clean, ' ') || ' ')"/>
        <xsl:variable name="given"
                      select="substring-before($clean, concat(' ', $family))"/>

        <mods:name type="personal">
          <mods:namePart type="family">
            <xsl:value-of select="$family"/>
          </mods:namePart>
          <mods:namePart type="given">
            <xsl:value-of select="$given"/>
          </mods:namePart>
          <!--                    Maybe add role dtc, mdc-->
          <mods:role>
            <mods:roleTerm type="code" authority="marcrelator">mdc</mods:roleTerm>
          </mods:role>
        </mods:name>
      </xsl:when>

      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="mods:physicalDescription/mods:extent">
    <xsl:copy>
      <xsl:value-of select="translate(., 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ .', '')"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="mods:mods/mods:identifier[@type='doi']">
    <xsl:choose>
      <xsl:when test="contains(.,'http')">
        <xsl:copy>
          <xsl:apply-templates select="@*"/>
          <xsl:value-of select="substring-after(., 'https://doi.org/')"/>
        </xsl:copy>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
      </xsl:otherwise>

    </xsl:choose>

  </xsl:template>

  <xsl:template match="mods:language">
    <xsl:for-each select="mods:languageTerm">
      <xsl:variable name="text" select="normalize-space(.)"/>
      <xsl:call-template name="split-languages">
        <xsl:with-param name="text" select="$text"/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="split-languages">
    <xsl:param name="text"/>
    <xsl:choose>
      <xsl:when test="contains($text, ';')">
        <xsl:variable name="first" select="normalize-space(substring-before($text, ';'))"/>
        <xsl:variable name="rest" select="normalize-space(substring-after($text, ';'))"/>

        <mods:language>
          <mods:languageTerm type="code" authority="rfc5646">
            <xsl:call-template name="map-language">
              <xsl:with-param name="code" select="$first"/>
            </xsl:call-template>
          </mods:languageTerm>
        </mods:language>

        <xsl:call-template name="split-languages">
          <xsl:with-param name="text" select="$rest"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <mods:language>
          <mods:languageTerm type="code" authority="rfc5646">
            <xsl:call-template name="map-language">
              <xsl:with-param name="code" select="$text"/>
            </xsl:call-template>
          </mods:languageTerm>
        </mods:language>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="map-language">
    <xsl:param name="code"/>
    <xsl:choose>
      <xsl:when test="$code='ger'">de</xsl:when>
      <xsl:when test="$code='wel'">cy</xsl:when>
      <xsl:when test="$code='eng'">en</xsl:when>
      <xsl:when test="$code='dan'">da</xsl:when>
      <xsl:when test="$code='frm'">fr</xsl:when>
      <xsl:when test="$code='dut'">nl</xsl:when>
      <xsl:when test="$code='srp'">sh-sr</xsl:when>
      <xsl:when test="$code='ice'">is</xsl:when>
      <xsl:when test="$code='lat'">la</xsl:when>
      <xsl:when test="$code='ita'">it</xsl:when>
      <xsl:when test="$code='fre'">fr</xsl:when>
      <xsl:when test="$code='jpn'">ja</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$code"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="mods:originInfo">
    <mods:originInfo eventType="publication">
      <xsl:apply-templates select="mods:place"/>
      <xsl:apply-templates select="mods:publisher"/>
<!--      <mods:dateIssued encoding="w3cdtf">2024</mods:dateIssued>-->
    </mods:originInfo>
  </xsl:template>

  <xsl:template match="mods:place">
    <mods:place>
      <xsl:apply-templates select="mods:placeTerm"/>
    </mods:place>
  </xsl:template>

  <xsl:template match="mods:placeTerm">
    <mods:placeTerm type="text">
      <xsl:value-of select="normalize-space(.)"/>
    </mods:placeTerm>
  </xsl:template>

  <xsl:template match="mods:publisher">
    <mods:publisher>
      <xsl:value-of select="normalize-space(.)"/>
    </mods:publisher>
  </xsl:template>

  <xsl:template match="mods:subject">
    <xsl:variable name="subj" select="normalize-space(.)"/>

    <xsl:choose>
      <xsl:when test="$subj='Part_Dissertation'">
        <xsl:apply-templates select="ancestor::mods:mods/mods:genre" mode="delete"/>
        <mods:genre type="intern"
                    authorityURI="http://www.mycore.org/classifications/mir_genres"
                    valueURI="http://www.mycore.org/classifications/mir_genres#dissertation"/>
      </xsl:when>
      <xsl:when test="$subj='Part_Text'">
        <mods:classification authorityURI="https://arthurianbibliography.info/classifications/artus_parts"
                             displayLabel="artus_parts"
                             valueURI="https://arthurianbibliography.info/classifications/artus_parts#CHS"/>
      </xsl:when>
      <xsl:when test="$subj='Part_Study'">
        <mods:classification authorityURI="https://arthurianbibliography.info/classifications/artus_parts"
                             displayLabel="artus_parts"
                             valueURI="https://arthurianbibliography.info/classifications/artus_parts#TTA"/>
      </xsl:when>
      <xsl:when test="$subj='Part_Review'">
      </xsl:when>
      <xsl:otherwise>
        <!-- delete by doing nothing -->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template name="genre2genre">
    <xsl:param name="text"/>
    <xsl:variable name="genre" select="normalize-space(translate($text, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'))"/>
    <xsl:variable name="hasEditorNoAuthor"
                  select="
          not(ancestor::mods:mods//mods:name/mods:role/mods:roleTerm[@authority='marcrelator' and normalize-space(.)='aut'])
          and ancestor::mods:mods//mods:name/mods:role/mods:roleTerm[@authority='marcrelator' and normalize-space(.)='edt']
        "/>

    <xsl:choose>
      <xsl:when test="$genre='journalarticle'">article</xsl:when>
      <xsl:when test="$genre='journal'">journal</xsl:when>
      <xsl:when test="$genre='book'">
        <xsl:choose>
          <xsl:when test="$hasEditorNoAuthor">collection</xsl:when>
          <xsl:otherwise>book</xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$genre='booksection'">
        <xsl:choose>
          <xsl:when test="$hasEditorNoAuthor">collection</xsl:when>
          <xsl:otherwise>chapter</xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:otherwise>
        <xsl:value-of select="$genre"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="mods:genre" mode="delete"/>
  <xsl:template match="mods:originInfo[count(*) = 0]"/>

</xsl:stylesheet>
