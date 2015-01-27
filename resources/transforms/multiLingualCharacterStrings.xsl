<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" 
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" 
  xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gco1="http://www.isotc211.org/2005/gco" 
  xmlns:gmi="http://www.isotc211.org/2005/gmi" xmlns:gmx="http://www.isotc211.org/2005/gmx" 
  xmlns:gsr="http://www.isotc211.org/2005/gsr" xmlns:gss="http://www.isotc211.org/2005/gss" 
  xmlns:gts="http://www.isotc211.org/2005/gts" xmlns:srv1="http://www.isotc211.org/2005/srv" 
  xmlns:gml="http://www.opengis.net/gml/3.2" xmlns:xlink="http://www.w3.org/1999/xlink" 
  xmlns:cat="http://standards.iso.org/19115/-3/cat/1.0/2014-12-25" xmlns:cit="http://standards.iso.org/19115/-3/cit/1.0/2014-12-25"
  xmlns:gcx="http://standards.iso.org/19115/-3/gcx/1.0/2014-12-25" xmlns:gex="http://standards.iso.org/19115/-3/gex/1.0/2014-12-25" 
  xmlns:lan="http://standards.iso.org/19115/-3/lan/1.0/2014-12-25" xmlns:srv="http://standards.iso.org/19115/-3/srv/2.0/2014-12-25" 
  xmlns:mac="http://standards.iso.org/19115/-3/mac/1.0/2014-12-25" xmlns:mas="http://standards.iso.org/19115/-3/mas/1.0/2014-12-25"
  xmlns:mcc="http://standards.iso.org/19115/-3/mcc/1.0/2014-12-25" xmlns:mco="http://standards.iso.org/19115/-3/mco/1.0/2014-12-25" 
  xmlns:mda="http://standards.iso.org/19115/-3/mda/1.0/2014-12-25" xmlns:mdb="http://standards.iso.org/19115/-3/mdb/1.0/2014-12-25" 
  xmlns:mdt="http://standards.iso.org/19115/-3/mdt/1.0/2014-12-25" xmlns:mex="http://standards.iso.org/19115/-3/mex/1.0/2014-12-25"
  xmlns:mrl="http://standards.iso.org/19115/-3/mrl/1.0/2014-12-25" xmlns:mds="http://standards.iso.org/19115/-3/mds/1.0/2014-12-25" 
  xmlns:mmi="http://standards.iso.org/19115/-3/mmi/1.0/2014-12-25" xmlns:mpc="http://standards.iso.org/19115/-3/mpc/1.0/2014-12-25" 
  xmlns:mrc="http://standards.iso.org/19115/-3/mrc/1.0/2014-12-25" xmlns:mrd="http://standards.iso.org/19115/-3/mrd/1.0/2014-12-25"
  xmlns:mri="http://standards.iso.org/19115/-3/mri/1.0/2014-12-25" xmlns:mrs="http://standards.iso.org/19115/-3/mrs/1.0/2014-12-25" 
  xmlns:msr="http://standards.iso.org/19115/-3/msr/1.0/2014-12-25" xmlns:mdq="http://standards.iso.org/19157/-2/mdq/1.0/2014-12-25" 
  xmlns:gco="http://standards.iso.org/19139/gco/1.0/2014-12-25" exclude-result-prefixes="#all">
  <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet">
    <xd:desc>
      <xd:p> These utility templates transform CodeLists and CharacterStrings from ISO 19139 into ISO 19115-3.</xd:p>
      <xd:p>Version December 5, 2014</xd:p>
      <xd:p><xd:b>Author:</xd:b>thabermann@hdfgroup.org</xd:p>
    </xd:desc>
  </xd:doc>
  <!-- This transform introduces a new namespce with the prefix gco. 
    We need placeholder for the new namespace in the transform that gets 
    converted to gco on output-->
  <!--<xsl:namespace-alias stylesheet-prefix="gco_new" result-prefix="gco"/>-->
  <xsl:template name="writeCharacterStringElement">
    <!-- Parameters
        elementName = the name of the element (with namespace prefix) that contains the codelist, i.e. cit:name
        nodeWithStringToWrite = the path of the node that contains the character string to be written
        -->
    <xsl:param name="elementName"/>
    <xsl:param name="nodeWithStringToWrite"/>
    <xsl:variable name="isMultilingual" select="count($nodeWithStringToWrite/gmd:PT_FreeText) > 0"/>
    <xsl:variable name="hasCharacterString" select="count($nodeWithStringToWrite/gco1:CharacterString) = 1"/>
    <!-- Need to add new gco namespace -->
    <xsl:variable name="newElementName">
      <xsl:choose>
        <xsl:when test="starts-with($elementName,'gco1:')">
          <xsl:value-of select="concat('gco:',substring-after($elementName,':'))"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$elementName"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$nodeWithStringToWrite">
        <xsl:element name="{$newElementName}">
          <xsl:copy-of select="$nodeWithStringToWrite/@*[name() != 'xsi:type']"/>
          <xsl:if test="$isMultilingual">
            <xsl:attribute name="xsi:type" select="'lan:PT_FreeText_PropertyType'"/>
          </xsl:if>
          <xsl:if test="$hasCharacterString">
            <gco:CharacterString>
              <xsl:value-of select="$nodeWithStringToWrite/gco1:CharacterString"/>
            </gco:CharacterString>
          </xsl:if>
          <xsl:if test="$isMultilingual">
            <xsl:apply-templates select="$nodeWithStringToWrite/gmd:PT_FreeText"/>
          </xsl:if>
        </xsl:element>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
