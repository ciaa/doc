<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
   xmlns:html="http://www.w3.org/1999/XSL/Format">
   <xsl:import href="docbook-xsl-1.78.1/html/chunk.xsl"/>
   <xsl:param name="html.stylesheet">style.css</xsl:param>
   <xsl:param name="admon.graphics" select="1"/>
   <xsl:param name="admon.textlabel" select="0"/>
   <xsl:param name="callout.graphics">0</xsl:param>
   <xsl:param name="chunker.output.encoding">UTF-8</xsl:param>

   <!-- numeración de las secciones -->
   <xsl:param name="section.autolabel" select="1"/>
   <xsl:param name="section.label.includes.component.label" select ="1"/>
</xsl:stylesheet>
