<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"

    xmlns:m30="http://www.kith.no/xmlstds/eresept/m30/2014-12-01"
    xmlns:f="http://www.kith.no/xmlstds/eresept/forskrivning/2014-12-01"

    exclude-result-prefixes="xs m30 f" version="2.0">

    <xsl:output indent="yes"/>

    <xsl:template match="m30:FEST">
        <CodeSystem xmlns="http://hl7.org/fhir">
            <id value="FEST-Virkestoff"/>
            <url value="http://legemiddelverket.no/FEST/VirkestoffID"/>
            <name value="FestVirkestoff"/>
            <title value="FEST Virkestoff"/>
            <status value="draft"/>
            <experimental value="true"/>
            <description value="Codes for active substances (Virkestoff) defined in FEST."/>
            <content value="complete"/>
            <caseSensitive value="true"/>
            <xsl:apply-templates/>
        </CodeSystem>
    </xsl:template>

    <xsl:template match="m30:KatVirkestoff">
        <xsl:for-each select="m30:OppfVirkestoff">
            <xsl:sort select="f:Virkestoff/f:Navn"/>
            <xsl:apply-templates/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="m30:OppfVirkestoff">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="f:Virkestoff">
        <concept xmlns="http://hl7.org/fhir">
            <code>
                <xsl:attribute name="value">
                    <xsl:value-of select="f:Id"/>
                </xsl:attribute>
            </code>
            <designation>
                <language value="no"/>
                <value>
                    <xsl:attribute name="value">
                        <xsl:value-of select="f:Navn"/>
                    </xsl:attribute>
                </value>
            </designation>
        </concept>
    </xsl:template>

    <xsl:template match="*"/>

</xsl:stylesheet>
