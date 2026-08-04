<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:i18n="xalan://org.mycore.services.i18n.MCRTranslation"
    xmlns:mcrver="xalan://org.mycore.common.MCRCoreVersion"
    xmlns:mcrxsl="xalan://org.mycore.common.xml.MCRXMLFunctions"
    xmlns:calendar="xalan://java.util.GregorianCalendar"
    exclude-result-prefixes="i18n mcrver mcrxsl calendar">

  <xsl:import href="resource:xsl/layout/mir-common-layout.xsl" />

  <xsl:template name="mir.navigation">

    <div class="header container-lg">
      <div class="header__logo">
        <a href="{concat($WebApplicationBaseURL,substring($loaded_navigation_xml/@hrefStartingPage,2))}">
           <img
             src="{$WebApplicationBaseURL}images/ias-logo-small-inverted.svg"
             alt="IAS Logo" />
        </a>
      </div>
      <div class="header__menu mir-main-nav">
        <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
          <button
            class="navbar-toggler"
            type="button"
            data-bs-toggle="collapse"
            data-bs-target="#mir-main-nav-collapse-box"
            aria-controls="mir-main-nav-collapse-box"
            aria-expanded="false"
            aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
          </button>
          <div
            id="mir-main-nav-collapse-box"
            class="collapse navbar-collapse mir-main-nav__entries justify-content-between">
            <ul class="navbar-nav me-auto mt-2 mt-lg-0">
              <xsl:for-each select="$loaded_navigation_xml/menu">
                <xsl:choose>
                  <xsl:when test="@id='main'"/>
                  <xsl:when test="@id='brand'"/>
                  <xsl:when test="@id='below'"/>
                  <xsl:when test="@id='user'"/>
                  <xsl:otherwise>
                    <xsl:apply-templates select="."/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
              <xsl:call-template name="mir.basketMenu" />
            </ul>
          </div>
        </nav>
      </div>
      <div class="header__search">
        <xsl:variable name="core">
          <xsl:call-template name="getLayoutSearchSolrCore" />
        </xsl:variable>
        <form
          action="{$WebApplicationBaseURL}servlets/solr/{$core}"
          class="searchfield_box d-flex"
          role="search">
          <xsl:variable name="initialCondQuery" select="/response/lst[@name='responseHeader']/lst[@name='params']/str[@name='initialCondQuery']" />

          <input
            name="condQuery"
            placeholder="{i18n:translate('mir.navsearch.placeholder')}"
            class="form-control search-query"
            id="searchInput"
            type="text"
            aria-label="Search" />

          <input type="hidden" id="initialCondQueryMirFlatmirLayout" name="initialCondQuery">
            <xsl:attribute name="value">
              <xsl:choose>
                <xsl:when test="$initialCondQuery">
                  <xsl:value-of select="$initialCondQuery"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="'*'"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
          </input>

          <xsl:choose>
            <xsl:when test="contains($isSearchAllowedForCurrentUser, 'true')">
              <input name="owner" type="hidden" value="createdby:*" />
            </xsl:when>
            <xsl:when test="not(mcrxsl:isCurrentUserGuestUser())">
              <input name="owner" type="hidden" value="createdby:{$CurrentUser}" />
            </xsl:when>
          </xsl:choose>

          <button type="submit" class="btn">
            <i class="fas fa-search"></i>
          </button>
        </form>
      </div>
      <div class="header__options">
        <div class="header__lang mir-prop-nav">
          <nav class="navbar navbar-dark navbar-expand-sm">
            <ul class="navbar-nav">
              <xsl:call-template name="mir.languageMenu" />
            </ul>
          </nav>
        </div>
        <div class="header__login">
          <nav class="navbar navbar-dark navbar-expand-sm">
            <ul class="navbar-nav">
              <xsl:call-template name="mir.loginMenu" />
            </ul>
          </nav>
        </div>
      </div>
    </div>

  </xsl:template>

  <xsl:template name="mir.jumbotwo">
    <!-- show only on startpage -->
    <xsl:if test="//div/@class='jumbotwo'">
    </xsl:if>
  </xsl:template>

  <xsl:template name="mir.footer">
    <div class="container">
      <div class="row project-info-row">
        <!--
        <div class="col artus-address">
          Internationale Artusgesellschaft |
          Bangor University College Road Bangor UK |
          arthurianbibliography@uni-marburg.de |
          <a href="https://ias-sia-iag.org/" target="_blank">
            ias-sia-iag.org
          </a>
        </div>
        -->
        <div class="col-auto artus-copyright">
          <xsl:variable name="tmp" select="calendar:new()" />
          <xsl:text>© </xsl:text>
          <xsl:value-of select="calendar:get($tmp, 1)" />
          <xsl:text> | </xsl:text>
          <xsl:value-of select="i18n:translate('artus.copyright')"/>
        </div>
        <div class="col footer-menu">
          <ul class="internal_links">
            <xsl:apply-templates select="$loaded_navigation_xml/menu[@id='below']/*" />
          </ul>
        </div>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="mir.powered_by">
    <xsl:variable name="mcr_version" select="concat('MyCoRe ',mcrver:getCompleteVersion())" />
    <div id="powered_by">
      <a href="http://www.mycore.de">
        <img src="{$WebApplicationBaseURL}mir-layout/images/mycore_logo_small_invert.png" title="{$mcr_version}" alt="powered by MyCoRe" />
      </a>
    </div>
  </xsl:template>
  <xsl:template name="getLayoutSearchSolrCore">
    <xsl:choose>
      <xsl:when test="not(mcrxsl:isCurrentUserGuestUser())">
        <xsl:text>find</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>findPublic</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
