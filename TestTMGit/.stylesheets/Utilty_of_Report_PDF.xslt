<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:redirect="org.apache.xalan.lib.Redirect"
	xmlns:java="http://xml.apache.org/xalan/java"
	extension-element-prefixes="redirect java">
	<xsl:param name="browserWeb"/>
	<xsl:output method="xml" media-type="text/html"
		doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="DTD/xhtml1-strict.dtd"
		cdata-section-elements="script style" encoding="ISO-8859-1" indent="yes" />

	<xsl:template match="@*|node()" priority="-1">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:template>

	<xsl:template name="updateref">
		<xsl:param name="ref" />
		<xsl:choose>
			<xsl:when test="contains($ref, 'plaf/')">
				<xsl:variable name="repl"
					select="concat('file:/', $browserWeb, '/../plaf/')" />
				<xsl:variable name="str"
					select="java:java.lang.String.new(string($ref))" />
				<xsl:value-of select="java:replaceAll($str, '.*.plaf/', $repl)" />
			</xsl:when>
			<xsl:when test="contains($ref, 'html/')">
				<xsl:variable name="repl"
					select="concat('file:/', $browserWeb, '/../html/')" />
				<xsl:variable name="str"
					select="java:java.lang.String.new(string($ref))" />
				<xsl:value-of select="java:replaceAll($str, '.*.html/', $repl)" />
			</xsl:when>
			<xsl:otherwise>
			 	<xsl:value-of select="$ref" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="@href">
		<xsl:attribute name="href">		
		<xsl:call-template name="updateref">
			<xsl:with-param name="ref" select="." />
		</xsl:call-template>
		</xsl:attribute>
	</xsl:template>

	<xsl:template match="@src">
		<xsl:attribute name="src">		
		<xsl:call-template name="updateref">
			<xsl:with-param name="ref" select="." />
		</xsl:call-template>
		</xsl:attribute>
	</xsl:template>

	<xsl:template match="xhtml:input[@type='text']">
		<xsl:element name="xhtml:span">
			<xsl:if test="@disabled='disabled'">
				<xsl:attribute name="style">background-color: gray;</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="class">input</xsl:attribute>
			<xsl:value-of select="@value" />
		</xsl:element>
	</xsl:template>

	<xsl:template match="xhtml:input[@type='radio']">
		<xsl:element name="xhtml:span">
			<xsl:if test="@checked='true'">
				<xsl:attribute name="style">border: thin solid black;</xsl:attribute>
			</xsl:if>
			<xsl:value-of select="@value" />
		</xsl:element>
	</xsl:template>

	<xsl:template name="followTab">
		<xsl:param name="table" />
		<xsl:param name="title" />
		<xsl:param name="tabjs" />
		<xsl:variable name="tab" select="substring($tabjs, 23,4)" />
		<xsl:variable name="tabTable" select="$table/ancestor::xhtml:tr/following-sibling::xhtml:tr/descendant::xhtml:table[@id=$tab]" />			
		<xsl:element name="xhtml:div">
			<xsl:attribute name="class">repDiv</xsl:attribute>
			<xhtml:div class="repTabTitle"><xsl:value-of select="$title" /></xhtml:div>
			<xsl:element name="xhtml:div">
				<xsl:choose>
					<xsl:when test="starts-with($title, 'Audit')">
						<xsl:attribute name="class">repTab audit</xsl:attribute>
						<xsl:element name="xhtml:table">
							<xsl:copy>
								<xsl:apply-templates select="$tabTable/*" />
							</xsl:copy>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="class">repTab</xsl:attribute>
						<xsl:element name="xhtml:table">
							<xsl:copy>
								<xsl:apply-templates select="$tabTable/*" />
							</xsl:copy>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
				
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="xhtml:table[@id='headtab']" >
		<xsl:variable name="table" select="." />
		<xsl:for-each select="descendant::xhtml:a">
			<xsl:call-template name="followTab">
				<xsl:with-param name="table" select="$table" />
				<xsl:with-param name="title" select="./xhtml:span" />
				<xsl:with-param name="tabjs" select="@href" />
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	
	<!-- do not display EMPTY FIELDS in snapshot -->
	<xsl:template match="xhtml:tr[@tabid]" mode="OFF">
		<xsl:variable name="isEmpty" select="descendant::input/@value" />
		EMMMM : <xsl:value-of select="$isEmpty" />
		<xsl:apply-templates />
	</xsl:template>
	
	
	<xsl:template match="xhtml:select" >
		<xsl:variable name="value1" select="xhtml:option[@selected]" />
		<xsl:variable name="value2" select="xhtml:option[not(@value)]" />
		<xsl:element name="xhtml:span">
			<xsl:attribute name="class">selectedOption</xsl:attribute>
			<xsl:value-of select="concat($value1, $value2)" />
		</xsl:element>
	</xsl:template>
	
	<!-- <xsl:template match="xhtml:select">
		<xsl:element name="xhtml:span">
			<xsl:value-of select="@oldvalue" />
		</xsl:element>
	</xsl:template>  -->
	
	
	<xsl:template match="xhtml:textarea" >
		<xsl:variable name="value" select="string(.)" />
		<xsl:element name="xhtml:span">
			<xsl:attribute name="class">selectedOption</xsl:attribute>
			<xsl:value-of select="$value" />
		</xsl:element>
	</xsl:template>
	
</xsl:stylesheet>