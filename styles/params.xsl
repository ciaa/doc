<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
   xmlns:fo="http://www.w3.org/1999/XSL/Format">
   <xsl:import href="docbook-xsl-1.78.1/fo/docbook.xsl"/>
   <!--xsl:import href="docbook-xsl-1.79.0/fo/docbook.xsl"/-->

   <!-- tipo de hoja -->
   <xsl:param name="paper.type">A4</xsl:param>
   <xsl:param name="double.sided" select="0"/>

   <xsl:param name="header.rule" select="1"></xsl:param>
   <xsl:param name="footer.rule" select="1"></xsl:param>

   <!-- quizas cambiar a 2.4 para reviews y notas -->
   <xsl:template match="para[parent::section or parent::chapter]">
      <fo:block xsl:use-attribute-sets="normal.para.spacing">
         <xsl:attribute name="line-height">1.45</xsl:attribute>
         <xsl:apply-templates/>
      </fo:block>
   </xsl:template>

   <!-- dedication -->
   <xsl:template match="dedication" mode="title.markup">
      <xsl:param name="allow-anchors" select="0"/>
      <xsl:choose>
         <xsl:when test="title|info/title">
            <xsl:apply-templates select="(title|info/title)[1]" mode="title.markup">
               <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
            </xsl:apply-templates>
         </xsl:when>
         <xsl:otherwise>
            <xsl:call-template name="gentext">
               <xsl:with-param name="key" select="'Dedication'"/>
            </xsl:call-template>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!-- fonts -->
   <xsl:param name="body.font.family">Ubuntu Light</xsl:param>

   <!-- numeración de las secciones -->
   <xsl:param name="section.autolabel" select="1"/>
   <xsl:param name="section.label.includes.component.label" select ="1"/>

   <!-- callouts -->
   <xsl:param name="callout.graphics">0</xsl:param>

   <!-- gráficos en tips, notes, warnings -->
   <xsl:param name="admon.graphics" select="1"/>
   <xsl:param name="admon.textlabel" select="0"/>

   <xsl:param name="fop1.extensions" select="1"/>

   <xsl:param name="insert.xref.page.number">0</xsl:param>

   <xsl:param name="formal.title.placement">
figure after
example before
equation after
table after
procedure after
task after
   </xsl:param>

   <xsl:template name="header.content">
      <xsl:param name="pageclass" select="''"/>
      <xsl:param name="sequence" select="''"/>
      <xsl:param name="position" select="''"/>
      <xsl:param name="gentext-key" select="''"/>

      <fo:block>
         <!-- sequence can be odd, even, first, blank -->
         <!-- position can be left, center, right -->
         <xsl:choose>

            <xsl:when test="$sequence = 'odd' and $position = 'left'">
               <fo:retrieve-marker retrieve-class-name="section.head.marker"
                  retrieve-position="first-including-carryover"
                  retrieve-boundary="page-sequence"/>
            </xsl:when>

            <xsl:when test="$sequence = 'odd' and $position = 'center'">
               <xsl:call-template name="draft.text"/>
            </xsl:when>

            <xsl:when test="$sequence = 'odd' and $position = 'right'">
               <fo:page-number/>
            </xsl:when>

            <xsl:when test="$sequence = 'even' and $position = 'left'">
               <fo:page-number/>
            </xsl:when>

            <xsl:when test="$sequence = 'even' and $position = 'center'">
               <xsl:call-template name="draft.text"/>
            </xsl:when>

            <xsl:when test="$sequence = 'even' and $position = 'right'">
               <xsl:apply-templates select="." mode="titleabbrev.markup"/>
            </xsl:when>

            <xsl:when test="$sequence = 'first' and $position = 'left'">
            </xsl:when>

            <xsl:when test="$sequence = 'first' and $position = 'right'">
            </xsl:when>

            <xsl:when test="$sequence = 'first' and $position = 'center'">
               <xsl:value-of
                  select="ancestor-or-self::book/bookinfo/corpauthor"/>
            </xsl:when>

            <xsl:when test="$sequence = 'blank' and $position = 'left'">
               <fo:page-number/>
            </xsl:when>

            <xsl:when test="$sequence = 'blank' and $position = 'center'">
               <xsl:text>This page intentionally left blank</xsl:text>
            </xsl:when>

            <xsl:when test="$sequence = 'blank' and $position = 'right'">
            </xsl:when>

         </xsl:choose>
      </fo:block>
   </xsl:template>

   <xsl:template name="footer.content">
      <xsl:param name="pageclass" select="''"/>
      <xsl:param name="sequence" select="''"/>
      <xsl:param name="position" select="''"/>
      <xsl:param name="gentext-key" select="''"/>

      <fo:block>
         <!-- sequence can be odd, even, first, blank -->
         <!-- position can be left, center, right -->
         <xsl:choose>
            <xsl:when test="$pageclass = 'titlepage' or $pageclass = 'lot' or $pageclass = 'front'">
               <!-- off -->
            </xsl:when>

            <xsl:when test="$sequence = 'odd' and $position = 'left'">
            </xsl:when>

            <xsl:when test="$sequence = 'odd' and $position = 'center'">
               <xsl:call-template name="draft.text"/>
               <xsl:apply-templates select="." mode="titleabbrev.markup"/>
            </xsl:when>

            <xsl:when test="$sequence = 'odd' and $position = 'right'">
            </xsl:when>

            <xsl:when test="$sequence = 'even' and $position = 'left'">
            </xsl:when>

            <xsl:when test="$sequence = 'even' and $position = 'center'">
               <xsl:call-template name="draft.text"/>
               <xsl:apply-templates select="." mode="titleabbrev.markup"/>
            </xsl:when>

            <xsl:when test="$sequence = 'even' and $position = 'right'">
               <xsl:apply-templates select="." mode="titleabbrev.markup"/>
            </xsl:when>

            <xsl:when test="$sequence = 'first' and $position = 'left'">
            </xsl:when>

            <xsl:when test="$sequence = 'first' and $position = 'right'">
            </xsl:when>

            <xsl:when test="$sequence = 'first' and $position = 'center'">
               <xsl:value-of
                  select="ancestor-or-self::book/bookinfo/corpauthor"/>
            </xsl:when>

            <xsl:when test="$sequence = 'blank' and $position = 'left'">
            </xsl:when>

            <xsl:when test="$sequence = 'blank' and $position = 'center'">
               <xsl:text>This page intentionally left blank</xsl:text>
            </xsl:when>

            <xsl:when test="$sequence = 'blank' and $position = 'right'">
            </xsl:when>

         </xsl:choose>
      </fo:block>
   </xsl:template>

   <xsl:template name="head.sep.rule">
      <xsl:param name="pageclass"/>
      <xsl:param name="sequence"/>
      <xsl:param name="gentext-key"/>

      <xsl:if test="$header.rule != 0">
         <xsl:choose>
            <xsl:when test="$pageclass = 'titlepage'">
               <!-- off -->
            </xsl:when>
            <xsl:when test="$pageclass = 'lot'">
               <!-- off -->
            </xsl:when>
            <xsl:when test="$pageclass = 'front'">
               <!-- off -->
            </xsl:when>
            <xsl:when test="$pageclass = 'index' and $sequence = 'first'">
               <!-- off -->
            </xsl:when>
            <xsl:when test="( $pageclass = 'body' or $pageclass = 'back' ) and $sequence = 'first'">
               <!-- off -->
            </xsl:when>
            <xsl:otherwise>
               <!-- top of each page -->
               <xsl:attribute name="border-bottom-width">2pt</xsl:attribute>
               <xsl:attribute name="border-bottom-style">solid</xsl:attribute>
               <xsl:attribute name="border-bottom-color">#8b90bd</xsl:attribute>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:if>
   </xsl:template>

   <xsl:template name="foot.sep.rule">
      <xsl:param name="pageclass"/>
      <xsl:param name="sequence"/>
      <xsl:param name="gentext-key"/>

      <xsl:if test="$footer.rule != 0">
         <xsl:choose>
            <xsl:when test="$pageclass = 'titlepage' or $pageclass = 'lot' or $pageclass = 'front'">
               <!-- off -->
            </xsl:when>
            <xsl:when test="$pageclass = 'index' and $sequence = 'first'">
               <!-- off -->
            </xsl:when>
            <xsl:when test="( $pageclass = 'body' or $pageclass = 'back' ) and $sequence = 'first'">
               <!-- off -->
            </xsl:when>
            <xsl:otherwise>
               <!-- bottom of each page -->
               <xsl:attribute name="border-top-width">2pt</xsl:attribute>
               <xsl:attribute name="border-top-style">solid</xsl:attribute>
               <xsl:attribute name="border-top-color">#8b90bd</xsl:attribute>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:if>
   </xsl:template>

   <!-- FRONT Cover -->
   <xsl:template name="front.cover">
      <xsl:call-template name="page.sequence">
         <xsl:with-param name="master-reference">titlepage</xsl:with-param>
         <xsl:with-param name="content">
            <fo:block text-align="center">
               <fo:external-graphic src="url(images/cover_paths.svg)" padding-top="-2.5cm" vertical-align="middle" content-height="100%" content-width="80%" />
               <!-- content-height="100%" content-width="80%"/-->
            </fo:block>
         </xsl:with-param>
      </xsl:call-template>
   </xsl:template>

   <!-- BACK Cover -->
   <xsl:template name="back.cover">
      <xsl:call-template name="page.sequence">
         <xsl:with-param name="master-reference">titlepage</xsl:with-param>
         <xsl:with-param name="content">
            <fo:block text-align="center">
               <fo:external-graphic src="url(images/back_paths.svg)" padding-top="-2.5cm" vertical-align="middle" content-height="100%" content-width="80%" />
            </fo:block>
         </xsl:with-param>
      </xsl:call-template>
   </xsl:template>

   <!-- programlisting -->
   <xsl:attribute-set name="monospace.verbatim.properties">
      <xsl:attribute name="keep-together.within-column">always</xsl:attribute>
      <xsl:attribute name="line-height">1</xsl:attribute>
      <xsl:attribute name="font-size">8pt</xsl:attribute>
   </xsl:attribute-set>

   <!-- borde y fondo de programlist -->
   <xsl:param name="shade.verbatim" select="1"/>

   <xsl:attribute-set name="shade.verbatim.style">
      <xsl:attribute name="background-color">#d7d7e3</xsl:attribute>
      <xsl:attribute name="border-width">2pt</xsl:attribute>
      <xsl:attribute name="border-style">solid</xsl:attribute>
      <xsl:attribute name="border-color">#8b90bd</xsl:attribute>
      <xsl:attribute name="margin">0pt</xsl:attribute>
   </xsl:attribute-set>

   <!-- notes, warnings, info -->
   <xsl:attribute-set name="admonition.properties.warning">
      <xsl:attribute name="keep-together.within-column">always</xsl:attribute>
      <xsl:attribute name="border">1.5pt solid #a21202</xsl:attribute>
      <xsl:attribute name="background-color">#fb4813</xsl:attribute>
      <xsl:attribute name="padding">0.1in</xsl:attribute>
      <xsl:attribute name="padding-top">-0.1in</xsl:attribute>
      <xsl:attribute name="margin-right">0.1in</xsl:attribute>
   </xsl:attribute-set>

   <xsl:attribute-set name="admonition.properties.note">
      <xsl:attribute name="keep-together.within-column">always</xsl:attribute>
      <xsl:attribute name="border">1.5pt solid #d46e1c</xsl:attribute>
      <xsl:attribute name="background-color">#ffefa8</xsl:attribute>
      <xsl:attribute name="padding">0.1in</xsl:attribute>
      <xsl:attribute name="padding-top">-0.1in</xsl:attribute>
      <xsl:attribute name="margin-right">0.1in</xsl:attribute>
   </xsl:attribute-set>

   <xsl:attribute-set name="admonition.properties.tip">
      <xsl:attribute name="keep-together.within-column">always</xsl:attribute>
      <xsl:attribute name="border">1.5pt solid #268101</xsl:attribute>
      <xsl:attribute name="background-color">#8ad216</xsl:attribute>
      <xsl:attribute name="padding">0.1in</xsl:attribute>
      <xsl:attribute name="padding-top">-0.1in</xsl:attribute>
      <xsl:attribute name="margin-right">0.1in</xsl:attribute>
   </xsl:attribute-set>

   <xsl:attribute-set name="admonition.properties.important">
      <xsl:attribute name="keep-together.within-column">always</xsl:attribute>
      <xsl:attribute name="border">1.5pt solid #eca327</xsl:attribute>
      <xsl:attribute name="background-color">#fffc58</xsl:attribute>
      <xsl:attribute name="padding">0.1in</xsl:attribute>
      <xsl:attribute name="padding-top">-0.1in</xsl:attribute>
      <xsl:attribute name="margin-right">0.1in</xsl:attribute>
   </xsl:attribute-set>

   <xsl:attribute-set name="admonition.properties">
      <xsl:attribute name="keep-together.within-column">always</xsl:attribute>
      <xsl:attribute name="border">1.5pt solid #0000ff</xsl:attribute>
      <xsl:attribute name="background-color">#00ff00</xsl:attribute>
      <xsl:attribute name="padding">0.1in</xsl:attribute>
      <xsl:attribute name="padding-top">-0.1in</xsl:attribute>
      <xsl:attribute name="margin-right">0.1in</xsl:attribute>
   </xsl:attribute-set>

   <xsl:attribute-set name="component.title.properties">
      <xsl:attribute name="color">#8b90bd</xsl:attribute>
      <xsl:attribute name="padding">8pt</xsl:attribute>
   </xsl:attribute-set>
   <xsl:attribute-set name="section.title.properties">
      <xsl:attribute name="keep-together.within-column">always</xsl:attribute>
      <xsl:attribute name="color">#8b90bd</xsl:attribute>
      <xsl:attribute name="padding">8pt</xsl:attribute>
      <xsl:attribute name="border-right-width">5pt</xsl:attribute>
      <xsl:attribute name="border-right-style">solid</xsl:attribute>
      <!--xsl:attribute name="border-right-color">#E0E0E0</xsl:attribute-->
      <xsl:attribute name="border-right-color">#d7d7e3</xsl:attribute>
      <xsl:attribute name="text-align">left</xsl:attribute>
   </xsl:attribute-set>

   <xsl:attribute-set name="shade.verbatim.style">
      <xsl:attribute name="background-color">#FFFFFF</xsl:attribute>
      <xsl:attribute name="border-width">0.5pt</xsl:attribute>
      <xsl:attribute name="border-style">solid</xsl:attribute>
      <xsl:attribute name="border-color">#575757</xsl:attribute>
      <xsl:attribute name="padding">3pt</xsl:attribute>
   </xsl:attribute-set>

   <xsl:template match="processing-instruction('hard-pagebreak')">
      <fo:block break-after='page'/>
</xsl:template>
</xsl:stylesheet>
