<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:mcri18n="xalan://org.mycore.services.i18n.MCRTranslation"
                xmlns:mcrxsl="xalan://org.mycore.common.xml.MCRXMLFunctions"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="mcri18n">

  <xsl:template match="index-search-form">
    <xsl:variable name="core">
      <xsl:call-template name="getLayoutSearchSolrCore" />
    </xsl:variable>
    <form
      action="../servlets/solr/{$core}"
      id="project-searchMainPage"
      class="form-inline d-flex justify-content-center mt-5"
      role="search" >
      <div class="input-group input-group-lg">
        <input
          name="condQuery"
          placeholder="{mcri18n:translate('artus.index.search.placeholder')}"
          class="form-control search-query"
          id="project-searchInput"
          type="text" />
        <button type="submit" class="btn btn-outline-secondary">
          <i class="fa fa-search"></i>
        </button>
      </div>
    </form>
    <script src="../js/index.js" />
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
