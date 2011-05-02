<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
    <xsl:import href="http://docbook.sourceforge.net/release/xsl/current/fo/docbook.xsl" />
    
    <xsl:param name="page.width" select="'8.25in'"/> 
    <xsl:param name="page.height" select="'10.75in'"/> 

    <xsl:attribute-set name="monospace.properties">
        <!--<xsl:attribute name="line-height">0.85em</xsl:attribute>-->
        <xsl:attribute name="font-size">0.9em</xsl:attribute>
    </xsl:attribute-set>
</xsl:stylesheet>
