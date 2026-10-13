<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY html-output SYSTEM "xsl/xsl-output-html.fragment">
  ]>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:encoder="xalan://java.net.URLEncoder"
                xmlns:i18n="xalan://org.mycore.services.i18n.MCRTranslation"
                xmlns:xalan="http://xml.apache.org/xalan"
                xmlns:mcrxsl="xalan://org.mycore.common.xml.MCRXMLFunctions"
                xmlns:str="http://exslt.org/strings"
                exclude-result-prefixes="xalan i18n encoder str mcrxsl">
  &html-output;
  <xsl:include href="MyCoReLayout.xsl" />
  <xsl:include href="response-utils.xsl" />
  <xsl:include href="xslInclude:solrResponse" />

  <xsl:param name="WebApplicationBaseURL" />
  <xsl:param name="MCR.Results.FetchHit" />

  <xsl:decimal-format name="european" decimal-separator=',' grouping-separator='.' />

  <xsl:variable name="PageTitle">
    <xsl:value-of select="i18n:translate('mir.editor.subject.search.modal.title')" />
  </xsl:variable>

  <xsl:variable name="query"
                select="/response/lst[@name='responseHeader']/lst[@name='params']/str[@name='terms.regex']" />

  <xsl:template match="lst[@name='mods.sindexname'] | lst[@name='mods.sindexname.published']">
    <xsl:variable name="searchHandler">
      <xsl:choose>
        <xsl:when test="@name='mods.sindexname.published'">selectPublic</xsl:when>
        <xsl:otherwise>select</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:for-each select="int">
      <xsl:sort select="@name" />
      <li>
        <a href="{$ServletsBaseURL}solr/{$searchHandler}?q={encoder:encode(concat('mods.subject:&quot;', @name, '&quot;'), 'UTF-8')}"
           title="Suche nach allen Publikationen">
          <xsl:value-of select="@name" />
        </a>
        <xsl:text>&#160;</xsl:text>
        <span class="text-muted">
          (<xsl:value-of select="format-number(number(.), '###.###', 'european')" />)
        </span>
      </li>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="/response">

    <xsl:variable name="a2z">
      <A search="[aäÄ].*" />
      <B search="b.*" />
      <C search="c.*" />
      <D search="d.*" />
      <E search="e.*" />
      <F search="f.*" />
      <G search="g.*" />
      <H search="h.*" />
      <I search="i.*" />
      <J search="j.*" />
      <K search="k.*" />
      <L search="l.*" />
      <M search="m.*" />
      <N search="n.*" />
      <O search="[oöÖ].*" />
      <P search="p.*" />
      <Q search="q.*" />
      <R search="r.*" />
      <S search="s.*" />
      <T search="t.*" />
      <U search="[uüÜ].*" />
      <V search="v.*" />
      <W search="w.*" />
      <X search="x.*" />
      <Y search="y.*" />
      <Z search="z.*" />
    </xsl:variable>

    <div class="row">
      <div class="col-md-12">
        <div class="row">

          <div class="col-md-4">
            <h2><xsl:value-of select="i18n:translate('mir.editor.subject.search.options.topics')" /></h2>

            <xsl:choose>
              <xsl:when test="lst[@name='terms']/lst[@name='mods.sindexname']/int or
                              lst[@name='terms']/lst[@name='mods.sindexname.published']/int">
                <ul id="resultList">
                  <xsl:apply-templates
                    select="lst[@name='terms']/lst[@name='mods.sindexname'] |
                            lst[@name='terms']/lst[@name='mods.sindexname.published']" />
                </ul>
              </xsl:when>
              <xsl:otherwise>
                <p><xsl:value-of select="i18n:translate('browse.subject.notFound')" /></p>
              </xsl:otherwise>
            </xsl:choose>
          </div>

          <div class="col-md-4">
            <h3><xsl:value-of select="i18n:translate('browse.person.firstLetter')" /></h3>
            <ul class="names">
              <xsl:for-each select="xalan:nodeset($a2z)/*">
                <li>
                  <xsl:if test="$query = @search">
                    <xsl:attribute name="class">active</xsl:attribute>
                  </xsl:if>
                  <a href="{concat($proxyBaseURL, '?XSL.Style=subject&amp;terms.regex=',
                                   encoder:encode(string(@search), 'UTF-8'))}">
                    <xsl:value-of select="name()" />
                  </a>
                  <xsl:if test="position() != last()">
                    <span> | </span>
                  </xsl:if>
                </li>
              </xsl:for-each>
            </ul>
          </div>

          <div class="col-md-4">
            <h3><xsl:value-of select="i18n:translate('browse.person.searchPerson')" /></h3>
            <form role="form" id="index_search_form" method="get" action="{$proxyBaseURL}">
              <xsl:for-each
                select="lst[@name='responseHeader']/lst[@name='params']/str[not(@name='terms.regex')]">
                <input type="hidden" name="{@name}" value="{.}" />
              </xsl:for-each>

              <xsl:variable name="search_value">
                <xsl:choose>
                  <xsl:when test="xalan:nodeset($a2z)/*[@search=$query]">
                    <xsl:value-of select="''" />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="$query" />
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:variable>

              <label class="sr-only form-label" for="index_search">Gesuchtes Subject</label>
              <div class="input-group">
                <input value="{$search_value}"
                       name="terms.regex"
                       class="search_text_gray focus_form_field form-control"
                       id="index_search"
                       type="text"
                       placeholder="Subject suchen" />
                <button type="submit" class="btn btn-secondary search_button" tabindex="1">
                  <xsl:value-of select="i18n:translate('button.search')" />
                </button>
              </div>
            </form>
          </div>

        </div>
      </div>
    </div>

  </xsl:template>

</xsl:stylesheet>
