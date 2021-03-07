<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="xml" indent="no"/>
	
	<xsl:template match="/">
		<xsl:apply-templates select="/TEI/text/body"/>
	</xsl:template>
	
	<xsl:template match="body">
		<xsl:element name="plenary_protocol">
      <xsl:attribute name="lp">
        <xsl:value-of select="/TEI/teiHeader/fileDesc/titleStmt/legislativePeriod" />
      </xsl:attribute>
      <xsl:attribute name="protocol_no">
        <xsl:value-of select="/TEI/teiHeader/fileDesc/titleStmt/sessionNo" />
      </xsl:attribute>
  		<xsl:attribute name="date">
  		  <xsl:value-of select="/TEI/teiHeader/fileDesc/publicationStmt/date" />
  		</xsl:attribute>
			<xsl:attribute name="url">
			  <xsl:value-of select="/TEI/teiHeader/fileDesc/sourceDesc/url" />
			</xsl:attribute>
			<xsl:attribute name="filetype">
			  <xsl:value-of select="/TEI/teiHeader/fileDesc/sourceDesc/filetype" />
			</xsl:attribute>
			<xsl:apply-templates select=".//sp"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="sp">
	  <xsl:element name="speaker">
			<xsl:attribute name="who"><xsl:value-of select="./@who"/></xsl:attribute>
			<xsl:attribute name="name"><xsl:value-of select="./@name"/></xsl:attribute>
			<xsl:attribute name="parliamentary_group"><xsl:value-of select="./@parliamentary_group"/></xsl:attribute>
			<xsl:attribute name="party"><xsl:value-of select="./@party"/></xsl:attribute>
			<xsl:attribute name="role"><xsl:value-of select="./@role"/></xsl:attribute>
			<xsl:for-each select="./p|./stage">
			  <xsl:copy-of select="."/>
			 </xsl:for-each>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
