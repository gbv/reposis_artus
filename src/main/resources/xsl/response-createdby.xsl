<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY html-output SYSTEM "xsl/xsl-output-html.fragment">
  ]>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:encoder="xalan://java.net.URLEncoder"
                xmlns:i18n="xalan://org.mycore.services.i18n.MCRTranslation"
                xmlns:mcrxsl="xalan://org.mycore.common.xml.MCRXMLFunctions"
                xmlns:mcruser="xalan://org.mycore.user2.MCRUserManager"
                exclude-result-prefixes="encoder mcruser">
  &html-output;
  <xsl:import href="layout/mir-layout-utils.xsl" />
  <xsl:include href="MyCoReLayout.xsl"/>
  <xsl:include href="response-utils.xsl"/>
  <xsl:include href="xslInclude:solrResponse"/>


  <xsl:param name="WebApplicationBaseURL"/>

  <xsl:decimal-format name="european" decimal-separator=',' grouping-separator='.'/>

  <xsl:variable name="PageTitle">
    <xsl:value-of select="i18n:translate('artus.view.documents.page.title')"/>
  </xsl:variable>

  <xsl:template match="/response">
    <xsl:choose>
      <xsl:when test="mcrxsl:isCurrentUserInRole('admin')">
        <h1 class="page-header">
          <xsl:value-of select="i18n:translate('artus.view.documents.page.title')"/>
        </h1>
        <xsl:variable name="users"
                      select="lst[@name='facet_counts']/lst[@name='facet_fields']/lst[@name='createdby']/int"/>
        <xsl:variable name="total" select="sum($users)"/>


        <div class="createdby-overview">
          <xsl:choose>
            <xsl:when test="$users">

              <p class="text-muted small mb-3 summary">
                <xsl:value-of select="format-number(count($users), '###.###', 'european')"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="i18n:translate('metadata.versionInfo.user')"/>
                <xsl:text> · </xsl:text>
                <xsl:value-of select="format-number($total, '###.###', 'european')"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="i18n:translate('artus.documents')"/>
              </p>
              <div class="table-responsive">
                <table class="table table-hover">
                  <thead>
                    <tr>
                      <th scope="col" class="w-100">
                        <xsl:value-of select="i18n:translate('metadata.versionInfo.user')"/>
                      </th>
                      <th scope="col" class="text-right text-nowrap">
                        <xsl:value-of select="i18n:translate('artus.documents')"/>
                      </th>
                      <th scope="col"></th>
                    </tr>
                  </thead>
                  <tbody>
                    <xsl:for-each select="$users">
                      <xsl:variable name="userName">
                        <xsl:choose>
                          <xsl:when test="contains(@name, '@')">
                            <xsl:value-of select="substring-before(@name, '@')"/>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of select="@name"/>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:variable>
                      <xsl:variable name="realm">
                        <xsl:choose>
                          <xsl:when test="contains(@name, '@')">
                            <xsl:value-of select="substring-after(@name, '@')"/>
                          </xsl:when>
                          <xsl:otherwise>local</xsl:otherwise>
                        </xsl:choose>
                      </xsl:variable>
                      <xsl:variable name="userExists" select="mcruser:exists(string($userName), string($realm))"/>
                      <tr>
                        <xsl:if test="not($userExists)">
                          <xsl:attribute name="class">user-deleted</xsl:attribute>
                        </xsl:if>
                        <td>
                          <xsl:choose>
                            <xsl:when test="$userExists">
                              <a
                                href="{$ServletsBaseURL}MCRUserServlet?action=show&amp;id={encoder:encode(string(@name), 'UTF-8')}"
                                title="Benutzerprofil anzeigen">
                                <xsl:value-of select="@name"/>
                              </a>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:variable name="deletedTextHint" select="i18n:translate('artus.deleted.hint')"/>

                              <span class="text-danger deleted-name " title="{$deletedTextHint}">
                                <xsl:value-of select="@name"/>
                              </span>
                              <xsl:text>&#160;</xsl:text>
                              <small class="deleted-hint text-danger">
                                <xsl:value-of select="i18n:translate('artus.deleted')"/>
                              </small>
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td class="count text-nowrap">
                          <span class="count-badge">
                            <xsl:value-of select="format-number(number(.), '###.###', 'european')"/>
                          </span>
                        </td>
                        <td class="go text-nowrap">
                          <a class="btn btn-sm btn-primary"
                             href="{$ServletsBaseURL}solr/select?q={encoder:encode(concat('createdby:&quot;', @name, '&quot;'), 'UTF-8')}&amp;fq=objectType%3Amods">
                            <xsl:value-of select="i18n:translate('artus.view.documents')"/>
                          </a>
                        </td>
                      </tr>
                    </xsl:for-each>
                  </tbody>
                </table>
              </div>

            </xsl:when>
            <xsl:otherwise>
              <div class="alert alert-warning">
                <xsl:value-of select="i18n:translate('artus.view.documents.user.not.found')"/>
              </div>
            </xsl:otherwise>
          </xsl:choose>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="mir.printNotLoggedIn" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


</xsl:stylesheet>
