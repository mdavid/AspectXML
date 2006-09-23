<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:variable name="output" select="/page/layout/output/@type"/>
<xsl:variable name="layoutDef" select="document('layoutDefinition.xml')"/>
<xsl:variable name="outputDef" select="document('outputDefinition.xml')/output/definition[@type = $output]"/>
<xsl:variable name="template" select="/page/layout/template/@name"/>
<xsl:variable name="content" select="/page/content"/>

<xsl:strip-space elements="*"/>

<xsl:output method="xml" indent="yes"/>

<xsl:template match="/">
  <xsl:apply-templates select="$layoutDef/templates/template[@name = $template]/layout/*"/>
</xsl:template>

<xsl:template match="*">
  <xsl:variable name="name" select="name()"/>
  <xsl:variable name="source" select="@source"/>
  <xsl:variable name="content" select="$content/*[name() = $source]"/>
  <xsl:variable name="outputDef" select="$outputDef/element[@name = $name]"/>
  <xsl:element name="{$outputDef/translation/@value}">
    <xsl:apply-templates select="@*[not(name() = 'source')]" mode="attMatch">
      <xsl:with-param name="attributes" select="$outputDef/attributes"/>
    </xsl:apply-templates>
    <xsl:if test="$source"><xsl:value-of select="$content"/></xsl:if>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="@*" mode="attMatch">
<xsl:param name="attributes"/>
<xsl:variable name="currentAttName" select="name()"/>
<xsl:variable name="translatedAttName" select="$attributes/attribute[@name = $currentAttName]/@value"/>
  <xsl:attribute name="{$translatedAttName}"><xsl:value-of select="."/></xsl:attribute>
</xsl:template>

</xsl:stylesheet>
