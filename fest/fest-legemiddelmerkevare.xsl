<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"

    xmlns:m30="http://www.kith.no/xmlstds/eresept/m30/2014-12-01"
    xmlns:f="http://www.kith.no/xmlstds/eresept/forskrivning/2014-12-01"

    exclude-result-prefixes="xs m30 f" version="2.0">

    <xsl:output indent="yes"/>

    <xsl:key name="merkevareById"
        match="/m30:FEST/m30:KatLegemiddelMerkevare/m30:OppfLegemiddelMerkevare/f:LegemiddelMerkevare"
        use="f:Id"/>
    <xsl:key name="virkestoffMedStyrkeById"
        match="/m30:FEST/m30:KatVirkestoff/m30:OppfVirkestoff/f:VirkestoffMedStyrke"
        use="f:Id"/>
    <xsl:key name="virkestoffById"
        match="/m30:FEST/m30:KatVirkestoff/m30:OppfVirkestoff/f:Virkestoff"
        use="f:Id"/>

    <xsl:template match="m30:FEST">
        <Bundle xmlns="http://hl7.org/fhir">
            <type value="batch"/>
            <xsl:apply-templates/>
        </Bundle>
    </xsl:template>

    <xsl:template match="m30:KatLegemiddelMerkevare">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="m30:OppfLegemiddelMerkevare">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="f:LegemiddelMerkevare">
        <xsl:variable name="lmvFestId" select="f:Id/text()" as="text()"/>
        <xsl:variable name="lmvNavnFormStyrke" select="normalize-space(replace(f:NavnFormStyrke, '&#xa0;', ' '))"/>
        <entry xmlns="http://hl7.org/fhir">
            <resource>
                <MedicationKnowledge>
                    <id>
                        <xsl:attribute name="value">
                            <xsl:value-of select="replace($lmvFestId, '_', '-')"/>
                        </xsl:attribute>
                    </id>
                    <code>
                        <coding>
                            <system value="http://legemiddelverket.no/FEST/LegemiddelMerkevareID"/>
                            <code>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="$lmvFestId"/>
                                </xsl:attribute>
                            </code>
                            <display>
                                <xsl:attribute name="value">
                                    <xsl:value-of select="$lmvNavnFormStyrke"/>
                                </xsl:attribute>
                            </display>
                        </coding>
                        <text>
                            <xsl:attribute name="value">
                                <xsl:value-of select="$lmvNavnFormStyrke"/>
                            </xsl:attribute>
                        </text>
                    </code>
                    <xsl:apply-templates select="f:SortertVirkestoffMedStyrke"/>
                    <xsl:apply-templates select="f:SortertVirkestoffUtenStyrke"/>
                </MedicationKnowledge>
            </resource>
            <request>
                <method value="PUT"/>
                <url>
                    <xsl:attribute name="value">
                        <xsl:text>MedicationKnowledge/</xsl:text>
                        <xsl:value-of select="replace($lmvFestId, '_', '-')"/>
                    </xsl:attribute>
                </url>
            </request>
        </entry>
    </xsl:template>

    <xsl:template match="f:SortertVirkestoffMedStyrke">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="f:SortertVirkestoffUtenStyrke">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="f:RefVirkestoffMedStyrke">
        <xsl:variable name="virkestoffMedStyrke" select="key('virkestoffMedStyrkeById', .)"/>
        <xsl:variable name="virkestoffId" select="$virkestoffMedStyrke/f:RefVirkestoff/text()"/>
        <xsl:variable name="virkestoff" select="key('virkestoffById', $virkestoffId)"/>
        <xsl:apply-templates select="$virkestoff"/>
    </xsl:template>

    <xsl:template match="f:RefVirkestoff">
        <xsl:variable name="virkestoff" select="key('virkestoffById', .)"/>
        <xsl:apply-templates select="$virkestoff"/>
    </xsl:template>

    <xsl:template match="f:Virkestoff">
        <ingredient xmlns="http://hl7.org/fhir">
            <itemCodeableConcept>
                <coding>
                    <system value="http://legemiddelverket.no/FEST/VirkestoffID"/>
                    <code>
                        <xsl:attribute name="value">
                            <xsl:value-of select="f:Id"/>
                        </xsl:attribute>
                    </code>
                    <display>
                        <xsl:attribute name="value">
                            <xsl:value-of select="f:Navn"/>
                        </xsl:attribute>
                    </display>
                </coding>
            </itemCodeableConcept>
        </ingredient>
    </xsl:template>

    <xsl:template match="*"/>

</xsl:stylesheet>
