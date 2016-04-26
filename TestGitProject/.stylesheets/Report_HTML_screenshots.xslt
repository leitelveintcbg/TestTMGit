<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	xmlns:redirect="org.apache.xalan.lib.Redirect"
	xmlns:java="http://xml.apache.org/xalan/java"
	xmlns:util="xalan://hu.fot.util.xml.XmlHelper"
	xmlns:utils2="xalan://hu.fot.util.xml.XSLUtils"
	xmlns:htmlutils="xalan://hu.fot.util.Html2Image"
	extension-element-prefixes="redirect java util utils2 htmlutils">
	<xsl:param name="file"/>
	<xsl:param name="browserDir"/>
	<xsl:param name="pdfCss"/>
	<xsl:param name="title"/>
	<xsl:param name="projName"/>
	<xsl:param name="testCycle"/>
	<xsl:param name="testStartDate"/>
	<xsl:param name="sutVersion"/>
	<xsl:param name="sutEnvironment"/>
	<xsl:param name="logo"/>

	<xsl:output method="xml" media-type="text/html" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="DTD/xhtml1-strict.dtd" cdata-section-elements="script style" encoding="ISO-8859-1" indent="yes"/>

	<xsl:template name="updateref">
		<xsl:param name="ref" />
		<xsl:choose>
			<xsl:when test="contains($ref, 'plaf/')">
				<xsl:variable name="repl"
					select="concat('file:/', $browserDir, '/../plaf/')" />
				<xsl:variable name="str"
					select="java:java.lang.String.new(string($ref))" />
				<xsl:value-of select="java:replaceAll($str, '.*.plaf/', $repl)" />
			</xsl:when>
			<xsl:when test="contains($ref, 'html/')">
				<xsl:variable name="repl"
					select="concat('file:/', $browserDir, '/../html/')" />
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


	<!-- FieldValues template is from PrintableReport -->
	<xsl:template match="//Inputs/InputMessage/FieldValues" mode="fieldValues">
		<xsl:param name="seqNo"/>
		<xsl:variable name="itId">
			<xsl:choose>
				<xsl:when test="../@iteration!=''">
					<xsl:value-of select="../@iteration"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="../@Baseline_iteration"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="menuId">
			<xsl:value-of select="generate-id(.)"/>
		</xsl:variable>

		<xsl:variable name="versionMode">
			<xsl:choose>
				<xsl:when test="./@Mode!=''">
					<xsl:value-of select="./@Mode"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="./@Baseline_Mode"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<h3>
			<xsl:text>Original design of input data:</xsl:text>
		</h3>
		<xsl:apply-templates select="." mode="RunLog"/>
		<xsl:choose>
			<xsl:when test="../../../Outputs/Iteration">
				<xsl:for-each select="../../../Outputs/Iteration[@number=$itId  or @Baseline_number=$itId]">
					<h3>
						<xsl:text>Setting field value(s)</xsl:text>
					</h3>


					<xsl:for-each select=".//TransactionID[not(preceding-sibling::TransactionID)]">
						<table width="100%" border="2">
							<thead>
								<tr>
									<th colspan="2" align="center">
										<xsl:text>Transaction id</xsl:text>
									</th>
								</tr>
								<xsl:if test="$isCompare=1">
									<tr>
										<th>Value</th>
										<th>Baseline value</th>
									</tr>
								</xsl:if>
							</thead>
							<tbody>
								<tr>
									<td>
										<xsl:value-of select="@id"/>
									</td>
									<xsl:if test="$isCompare=1">
										<td>
											<xsl:value-of select="@Baseline_id"/>
										</td>
									</xsl:if>
								</tr>
							</tbody>
						</table>
						<br/>
					</xsl:for-each>


<!--  				<xsl:if test=".//SET_FIELD">
						<table width="100%" border="2">
							<thead>
								<tr>
									<th colspan="3" align="center">
										<xsl:text>Field value setting(s)</xsl:text>
									</th>
								</tr>
								<tr>
									<th>Field name</th>
									<th>Value</th>
									<xsl:if test="$isCompare=1">
										<th>Baseline value</th>
									</xsl:if>
								</tr>
							</thead>
							<tbody>
								<xsl:apply-templates select=".//SET_FIELD"/>
							</tbody>
						</table>
						<br/>
					</xsl:if>
-->
					<xsl:for-each select=".//Testcase[starts-with(@Text,'Commit')]">
						<xsl:if test="preceding-sibling::Testcase[starts-with(@Text,'Override reason')]">
							<table width="100%" border="2">
								<thead>
									<tr>
										<th colspan="2" align="center">
											<xsl:text>Override reason(s)</xsl:text>
										</th>
									</tr>
									<xsl:if test="$isCompare=1">
										<tr>
											<th>Value</th>
											<th>Baseline value</th>
										</tr>
									</xsl:if>
								</thead>
								<tbody>
									<xsl:for-each select="preceding-sibling::Testcase[starts-with(@Text,'Override reason')]">
										<tr>
											<xsl:if test="$isCompare=1">
												<xsl:if test="contains(@TestManager_DiffType,'Changed')">
													<xsl:attribute name="class">changed</xsl:attribute>
												</xsl:if>
												<xsl:if test="contains(@TestManager_DiffType,'Added')">
													<xsl:attribute name="class">added</xsl:attribute>
												</xsl:if>
												<xsl:if test="contains(@TestManager_DiffType,'Removed')">
													<xsl:attribute name="class">removed</xsl:attribute>
												</xsl:if>
											</xsl:if>
											<td>
												<xsl:value-of select="@Text"/>
											</td>
											<xsl:if test="$isCompare=1">
												<td>
													<xsl:value-of select="@Baseline_Text"/>
												</td>
												<xsl:if test="./Defect">
													<td>
														<a>
															<xsl:attribute name="id">
																<xsl:text>def</xsl:text>
																<xsl:number value="count(preceding::Defect)"/>
															</xsl:attribute>
															<xsl:attribute name="name">
																<xsl:text>defect</xsl:text>
																<xsl:value-of select="./Defect/@id"/>
															</xsl:attribute>

															<xsl:for-each select="Defect">
																<xsl:value-of select="@id"/>
																<xsl:text>(</xsl:text>
																<xsl:value-of select="@name"/>
																<xsl:text>)</xsl:text>
																<br/>
															</xsl:for-each>
															<input value="x" type="button">
																<xsl:attribute name="onclick">
																	<xsl:text>hidingDefectFromDefects('</xsl:text>
																	<xsl:value-of select="./Defect/@id"/>
																	<xsl:text>');</xsl:text>
																</xsl:attribute>
															</input>
														</a>
													</td>
												</xsl:if>
											</xsl:if>
										</tr>
									</xsl:for-each>
								</tbody>
							</table>
							<br/>
						</xsl:if>

						<!--Error text messages in the VersionFields or AAVersionFields -->
						<xsl:if test="../../../*[contains(name(),'VersionFields')]//*[@errorText!='']">
							<table width="100%" border="2">
								<thead>
									<tr>
										<th colspan="3" align="center">
											<strong>Error message(s)</strong>
										</th>
									</tr>

									<tr>
										<th>Field name</th>
										<th>Value</th>
										<xsl:if test="$isCompare=1">
											<th>Baseline value</th>
										</xsl:if>
									</tr>
								</thead>
								<tbody>
									<xsl:for-each select="../../../*[contains(name(),'VersionFields')]//*[@errorText!='']">
										<tr>
											<xsl:if test="$isCompare=1">
												<xsl:if test="contains(@TestManager_DiffType,'Changed')">
													<xsl:attribute name="class">changed</xsl:attribute>
												</xsl:if>
												<xsl:if test="contains(@TestManager_DiffType,'Added')">
													<xsl:attribute name="class">added</xsl:attribute>
												</xsl:if>
												<xsl:if test="contains(@TestManager_DiffType,'Removed')">
													<xsl:attribute name="class">removed</xsl:attribute>
												</xsl:if>
											</xsl:if>
											<td>
												<xsl:text>(</xsl:text>
												<xsl:choose>
													<xsl:when test="@fieldNumber1!=''">
														<xsl:value-of select="@fieldNumber1"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="@Baseline_fieldNumber1"/>
													</xsl:otherwise>
												</xsl:choose>
												<xsl:for-each select="ancestor::Value">
													<xsl:text>.</xsl:text>
													<xsl:choose>
														<xsl:when test="@number!=''">
															<xsl:value-of select="@number"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="@Baseline_number"/>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:for-each>
												<xsl:text>) </xsl:text>
												<xsl:value-of select="name()"/>
											</td>
											<td>
												<xsl:value-of select="@errorText"/>
											</td>
											<xsl:if test="$isCompare=1">
												<td>
													<xsl:value-of select="@Baseline_errorText"/>
												</td>
												<xsl:if test="./Defect">
													<td>
														<xsl:for-each select="Defect">
															<xsl:value-of select="@id"/>
															<xsl:text>(</xsl:text>
															<xsl:value-of select="@name"/>
															<xsl:text>)</xsl:text>
															<br/>
														</xsl:for-each>
													</td>
												</xsl:if>
											</xsl:if>
										</tr>
									</xsl:for-each>
								</tbody>
							</table>
							<br/>
						</xsl:if>

						<xsl:if test="preceding-sibling::INFO[starts-with(@Text,'Error message')]">
							<table width="100%" border="2">
								<thead>
									<tr>
										<th colspan="2" align="center">
											<xsl:text>Error reason(s) during commit</xsl:text>
										</th>
									</tr>
									<xsl:if test="$isCompare=1">
										<tr>
											<th>Value</th>
											<th>Baseline value</th>
										</tr>
									</xsl:if>
								</thead>
								<tbody>
									<xsl:for-each select="preceding-sibling::INFO[starts-with(@Text,'Error message')]">
										<tr>
											<xsl:if test="$isCompare=1">
												<xsl:if test="contains(@TestManager_DiffType,'Changed')">
													<xsl:attribute name="class">changed</xsl:attribute>
												</xsl:if>
												<xsl:if test="contains(@TestManager_DiffType,'Added')">
													<xsl:attribute name="class">added</xsl:attribute>
												</xsl:if>
												<xsl:if test="contains(@TestManager_DiffType,'Removed')">
													<xsl:attribute name="class">removed</xsl:attribute>
												</xsl:if>
											</xsl:if>
											<td>
												<xsl:value-of select="@Text"/>
											</td>
											<xsl:if test="$isCompare=1">
												<td>
													<xsl:value-of select="@Baseline_Text"/>
												</td>
												<xsl:if test="./Defect">
													<td>
														<xsl:for-each select="Defect">
															<xsl:value-of select="@id"/>
															<xsl:text>(</xsl:text>
															<xsl:value-of select="@name"/>
															<xsl:text>)</xsl:text>
															<br/>
														</xsl:for-each>
													</td>
												</xsl:if>
											</xsl:if>
										</tr>
									</xsl:for-each>
								</tbody>
							</table>
							<br/>
						</xsl:if>
						<xsl:call-template name="commit-table">
							<xsl:with-param name="id">
								<xsl:value-of select="generate-id(.)"/>
							</xsl:with-param>
						</xsl:call-template>
						<br/>
					</xsl:for-each>
						
					<xsl:for-each select="Script/Version[(@mode=$versionMode) or (@Baseline_mode=$versionMode)]/RunLog/Testcase[starts-with(@Text,'Globus message')]">

						<table width="100%" border="2">
							<thead>
								<tr>
									<th colspan="2" align="center">
										<xsl:text>GLOBUS message(s)</xsl:text>
									</th>
								</tr>
								<xsl:if test="$isCompare=1">
									<tr>
										<th>Value</th>
										<th>Baseline value</th>
									</tr>
								</xsl:if>
							</thead>
							<tbody>
								<tr>
									<xsl:if test="$isCompare=1">
										<xsl:if test="contains(@TestManager_DiffType,'Changed')">
											<xsl:attribute name="class">changed</xsl:attribute>
										</xsl:if>
										<xsl:if test="contains(@TestManager_DiffType,'Added')">
											<xsl:attribute name="class">added</xsl:attribute>
										</xsl:if>
										<xsl:if test="contains(@TestManager_DiffType,'Removed')">
											<xsl:attribute name="class">removed</xsl:attribute>
										</xsl:if>
									</xsl:if>
									<td>
										<xsl:value-of select="@Text"/>
									</td>
									<xsl:if test="$isCompare=1">
										<td>
											<xsl:value-of select="@Baseline_Text"/>
										</td>
										<xsl:if test="./Defect">
											<td>
												<xsl:for-each select="Defect">
													<xsl:value-of select="@id"/>
													<xsl:text>(</xsl:text>
													<xsl:value-of select="@name"/>
													<xsl:text>)</xsl:text>
													<br/>
												</xsl:for-each>
											</td>
										</xsl:if>
									</xsl:if>
								</tr>
							</tbody>
						</table>
						<br/>
					</xsl:for-each>

					<xsl:for-each select=".//Testcase[starts-with(@Text,'TXN COMPLETE')]">
						<table width="100%" border="2">
							<thead>
								<tr>
									<th colspan="2" align="center">
										<xsl:text>TXN COMPLETE</xsl:text>
									</th>
								</tr>
								<xsl:if test="$isCompare=1">
									<tr>
										<th>Value</th>
										<th>Baseline value</th>
									</tr>
								</xsl:if>
							</thead>
							<tbody>
								<tr>
									<xsl:if test="$isCompare=1">
										<xsl:if test="contains(@TestManager_DiffType,'Changed')">
											<xsl:attribute name="class">changed</xsl:attribute>
										</xsl:if>
										<xsl:if test="contains(@TestManager_DiffType,'Added')">
											<xsl:attribute name="class">added</xsl:attribute>
										</xsl:if>
										<xsl:if test="contains(@TestManager_DiffType,'Removed')">
											<xsl:attribute name="class">removed</xsl:attribute>
										</xsl:if>
									</xsl:if>
									<td>
										<xsl:value-of select="@Text"/>
									</td>
									<xsl:if test="$isCompare=1">
										<td>
											<xsl:value-of select="@Baseline_Text"/>
										</td>
										<xsl:if test="./Defect">
											<td>
												<xsl:for-each select="Defect">
													<xsl:value-of select="@id"/>
													<xsl:text>(</xsl:text>
													<xsl:value-of select="@name"/>
													<xsl:text>)</xsl:text>
													<br/>
												</xsl:for-each>
											</td>
										</xsl:if>
									</xsl:if>
								</tr>
							</tbody>
						</table>
						<br/>
					</xsl:for-each>

					<xsl:if test="Script/Version[(@mode=$versionMode) or (@Baseline_mode=$versionMode)]/*[contains(name(),'VersionFields')]/descendant::*[@value!='' or @Baseline_value!='']">
						<h3>
							<xsl:text>Snapshot of non-empty fields before commit</xsl:text>
						</h3>
						<xsl:for-each select="Script/Version[(@mode=$versionMode) or (@Baseline_mode=$versionMode)]/RunLog">
							<xsl:apply-templates select=".//RECEIVED[contains(@Command, '-FillVersion') and position()=last()]" mode="version">
								<xsl:with-param name="postfix" select="@mode"/>
							</xsl:apply-templates>
							<br/>
						</xsl:for-each>
					</xsl:if>

					<xsl:if test="Script/Version[@mode='S']/RunLog/INFO[@Text='Checking output fields']">
						<xsl:call-template name="checkOutput">
							<xsl:with-param name="node" select="."/>
						</xsl:call-template>
					</xsl:if>

					<xsl:if test="($versionMode!='S') and Script/Version[(@mode='S') or (@Baseline_mode='S')]/*[contains(name(),'VersionFields')]/descendant::*[@value!='' or @Baseline_value!='']">
						<h3>
							<xsl:text>Snapshot of non-empty fields after commit</xsl:text>
						</h3>
						<xsl:for-each select="Script/Version[(@mode='S') or (@Baseline_mode='S')]/*[contains(name(),'VersionFields')]">
							<xsl:apply-templates select=".//RECEIVED[contains(@Command, '-OpenVersion') and position()=last()]" mode="version">
								<xsl:with-param name="postfix" select="@mode"/>
							</xsl:apply-templates>
							<br/>
						</xsl:for-each>
					</xsl:if>
					<br/>
				</xsl:for-each>
			</xsl:when>

			<xsl:otherwise>
				<xsl:for-each select="../../../Outputs">
					<h3>
						<xsl:text>Setting field value(s)</xsl:text>
					</h3>

					<xsl:for-each select=".//TransactionID[not(preceding-sibling::TransactionID)]">
						<table width="100%" border="2">
							<thead>
								<tr>
									<th colspan="2" align="center">
										<xsl:text>Transaction id</xsl:text>
									</th>
								</tr>
								<xsl:if test="$isCompare=1">
									<tr>
										<th>Value</th>
										<th>Baseline value</th>
									</tr>
								</xsl:if>
							</thead>
							<tbody>
								<tr>
									<td>
										<xsl:value-of select="@id"/>
									</td>
									<xsl:if test="$isCompare=1">
										<td>
											<xsl:value-of select="@Baseline_id"/>
										</td>
									</xsl:if>
								</tr>
							</tbody>
						</table>
						<br/>
					</xsl:for-each>

<!--					<xsl:if test=".//SET_FIELD">
						<table width="100%" border="2">
							<thead>
								<tr>
									<th colspan="3" align="center">
										<xsl:text>Field value setting(s)</xsl:text>
									</th>
								</tr>
								<tr>
									<th>Field name</th>
									<th>Value</th>
									<xsl:if test="$isCompare=1">
										<th>Baseline value</th>
									</xsl:if>
								</tr>
							</thead>
							<tbody>
								<xsl:apply-templates select=".//SET_FIELD"/>
							</tbody>
						</table>
						<br/>
					</xsl:if>
-->
					<xsl:for-each select=".//Testcase[starts-with(@Text,'Commit')]">
						<xsl:if test="preceding-sibling::Testcase[starts-with(@Text,'Override reason')]">

							<table width="100%" border="2">
								<thead>
									<tr>
										<th colspan="2" align="center">
											<xsl:text>Override reason(s)</xsl:text>
										</th>
									</tr>
									<xsl:if test="$isCompare=1">
										<tr>
											<th>Value</th>
											<th>Baseline value</th>
										</tr>
									</xsl:if>
								</thead>
								<tbody>
									<xsl:for-each select="preceding-sibling::Testcase[starts-with(@Text,'Override reason')]">
										<tr>
											<xsl:if test="$isCompare=1">
												<xsl:if test="contains(@TestManager_DiffType,'Changed')">
													<xsl:attribute name="class">changed</xsl:attribute>
												</xsl:if>
												<xsl:if test="contains(@TestManager_DiffType,'Added')">
													<xsl:attribute name="class">added</xsl:attribute>
												</xsl:if>
												<xsl:if test="contains(@TestManager_DiffType,'Removed')">
													<xsl:attribute name="class">removed</xsl:attribute>
												</xsl:if>
											</xsl:if>
											<td>
												<xsl:value-of select="@Text"/>
											</td>
											<xsl:if test="$isCompare=1">
												<td>
													<xsl:value-of select="@Baseline_Text"/>
												</td>
												<xsl:if test="./Defect">
													<td>
														<xsl:for-each select="Defect">
															<xsl:value-of select="@id"/>
															<xsl:text>(</xsl:text>
															<xsl:value-of select="@name"/>
															<xsl:text>)</xsl:text>
															<br/>
														</xsl:for-each>
													</td>
												</xsl:if>
											</xsl:if>
										</tr>
									</xsl:for-each>
								</tbody>
							</table>
						</xsl:if>

						<!--Error text messages in the VersionFields and AAVersionFields -->
						<xsl:if test="../../../*[contains(name(),'VersionFields')]//*[@errorText!='']">

							<table width="100%" border="2">
								<thead>
									<tr>
										<th colspan="3" align="center">
											<strong>Error message(s)</strong>
										</th>
									</tr>

									<tr>
										<th>Field name</th>
										<th>Value</th>
										<xsl:if test="$isCompare=1">
											<th>Baseline value</th>
										</xsl:if>
									</tr>
								</thead>
								<tbody>
									<xsl:for-each select="../../../*[contains(name(),'VersionFields')]//*[@errorText!='']">
										<tr>
											<xsl:if test="$isCompare=1">
												<xsl:if test="contains(@TestManager_DiffType,'Changed')">
													<xsl:attribute name="class">changed</xsl:attribute>
												</xsl:if>
												<xsl:if test="contains(@TestManager_DiffType,'Added')">
													<xsl:attribute name="class">added</xsl:attribute>
												</xsl:if>
												<xsl:if test="contains(@TestManager_DiffType,'Removed')">
													<xsl:attribute name="class">removed</xsl:attribute>
												</xsl:if>
											</xsl:if>
											<td>
												<xsl:text>(</xsl:text>
												<xsl:choose>
													<xsl:when test="@fieldNumber1!=''">
														<xsl:value-of select="@fieldNumber1"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="@Baseline_fieldNumber1"/>
													</xsl:otherwise>
												</xsl:choose>
												<xsl:for-each select="ancestor::Value">
													<xsl:text>.</xsl:text>
													<xsl:choose>
														<xsl:when test="@number!=''">
															<xsl:value-of select="@number"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="@Baseline_number"/>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:for-each>
												<xsl:text>) </xsl:text>
												<xsl:value-of select="name()"/>
											</td>
											<td>
												<xsl:value-of select="@errorText"/>
											</td>
											<xsl:if test="$isCompare=1">
												<td>
													<xsl:value-of select="@Baseline_errorText"/>
												</td>
												<xsl:if test="./Defect">
													<td>
														<xsl:for-each select="Defect">
															<xsl:value-of select="@id"/>
															<xsl:text>(</xsl:text>
															<xsl:value-of select="@name"/>
															<xsl:text>)</xsl:text>
															<br/>
														</xsl:for-each>
													</td>
												</xsl:if>
											</xsl:if>
										</tr>
									</xsl:for-each>
								</tbody>
							</table>
						</xsl:if>

						<xsl:if test="preceding-sibling::INFO[starts-with(@Text,'Error message')]">

							<table width="100%" border="2">
								<thead>
									<tr>
										<th colspan="2" align="center">
											<xsl:text>Error reason(s) during commit</xsl:text>
										</th>
									</tr>
									<xsl:if test="$isCompare=1">
										<tr>
											<th>Value</th>
											<th>Baseline value</th>
										</tr>
									</xsl:if>
								</thead>
								<tbody>
									<xsl:for-each select="preceding-sibling::INFO[starts-with(@Text,'Error message')]">
										<tr>
											<xsl:if test="$isCompare=1">
												<xsl:if test="contains(@TestManager_DiffType,'Changed')">
													<xsl:attribute name="class">changed</xsl:attribute>
												</xsl:if>
												<xsl:if test="contains(@TestManager_DiffType,'Added')">
													<xsl:attribute name="class">added</xsl:attribute>
												</xsl:if>
												<xsl:if test="contains(@TestManager_DiffType,'Removed')">
													<xsl:attribute name="class">removed</xsl:attribute>
												</xsl:if>
											</xsl:if>
											<td>
												<xsl:value-of select="@Text"/>
											</td>
											<xsl:if test="$isCompare=1">
												<td>
													<xsl:value-of select="@Baseline_Text"/>
												</td>
												<xsl:if test="./Defect">
													<td>
														<xsl:for-each select="Defect">
															<xsl:value-of select="@id"/>
															<xsl:text>(</xsl:text>
															<xsl:value-of select="@name"/>
															<xsl:text>)</xsl:text>
															<br/>
														</xsl:for-each>
													</td>
												</xsl:if>
											</xsl:if>
										</tr>
									</xsl:for-each>
								</tbody>
							</table>
						</xsl:if>
						<xsl:call-template name="commit-table">
							<xsl:with-param name="id">
								<xsl:value-of select="generate-id(.)"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>

					<xsl:for-each select="Script/Version[(@mode=ancestor::Sequence/Inputs/InputMessage/FieldValues/@Mode) or (@Baseline_mode=ancestor::Sequence/Inputs/InputMessage/FieldValues/@Baseline_Mode)]/RunLog/Testcase[starts-with(@Text,'Globus message')]">

						<table width="100%" border="2">
							<thead>
								<tr>
									<th colspan="2" align="center">
										<xsl:text>GLOBUS message(s)</xsl:text>
									</th>
								</tr>
								<xsl:if test="$isCompare=1">
									<tr>
										<th>Value</th>
										<th>Baseline value</th>
									</tr>
								</xsl:if>
							</thead>
							<tbody>
								<tr>
									<xsl:if test="$isCompare=1">
										<xsl:if test="contains(@TestManager_DiffType,'Changed')">
											<xsl:attribute name="class">changed</xsl:attribute>
										</xsl:if>
										<xsl:if test="contains(@TestManager_DiffType,'Added')">
											<xsl:attribute name="class">added</xsl:attribute>
										</xsl:if>
										<xsl:if test="contains(@TestManager_DiffType,'Removed')">
											<xsl:attribute name="class">removed</xsl:attribute>
										</xsl:if>
									</xsl:if>
									<td>
										<xsl:value-of select="@Text"/>
									</td>
									<xsl:if test="$isCompare=1">
										<td>
											<xsl:value-of select="@Baseline_Text"/>
										</td>
										<xsl:if test="./Defect">
											<td>
												<xsl:for-each select="Defect">
													<xsl:value-of select="@id"/>
													<xsl:text>(</xsl:text>
													<xsl:value-of select="@name"/>
													<xsl:text>)</xsl:text>
													<br/>
												</xsl:for-each>
											</td>
										</xsl:if>
									</xsl:if>
								</tr>
							</tbody>
						</table>
					</xsl:for-each>

					<xsl:for-each select=".//Testcase[starts-with(@Text,'TXN COMPLETE')]">

						<table width="100%" border="2">
							<thead>
								<tr>
									<th colspan="2" align="center">
										<xsl:text>TXN COMPLETE</xsl:text>
									</th>
								</tr>
								<xsl:if test="$isCompare=1">
									<tr>
										<th>Value</th>
										<th>Baseline value</th>
									</tr>
								</xsl:if>
							</thead>
							<tbody>
								<tr>
									<xsl:if test="$isCompare=1">
										<xsl:if test="contains(@TestManager_DiffType,'Changed')">
											<xsl:attribute name="class">changed</xsl:attribute>
										</xsl:if>
										<xsl:if test="contains(@TestManager_DiffType,'Added')">
											<xsl:attribute name="class">added</xsl:attribute>
										</xsl:if>
										<xsl:if test="contains(@TestManager_DiffType,'Removed')">
											<xsl:attribute name="class">removed</xsl:attribute>
										</xsl:if>
									</xsl:if>
									<td>
										<xsl:value-of select="@Text"/>
									</td>
									<xsl:if test="$isCompare=1">
										<td>
											<xsl:value-of select="@Baseline_Text"/>
										</td>
										<xsl:if test="./Defect">
											<td>
												<xsl:for-each select="Defect">
													<xsl:value-of select="@id"/>
													<xsl:text>(</xsl:text>
													<xsl:value-of select="@name"/>
													<xsl:text>)</xsl:text>
													<br/>
												</xsl:for-each>
											</td>
										</xsl:if>
									</xsl:if>
								</tr>
							</tbody>
						</table>
					</xsl:for-each>

					<xsl:if test="Script/Version[(@mode=ancestor::Sequence/Inputs/InputMessage/FieldValues/@Mode) or (@Baseline_mode=ancestor::Sequence/Inputs/InputMessage/FieldValues/@Baseline_Mode)]/*[contains(name(),'VersionFields')]/descendant::*[@value!='' or @Baseline_value!='']">
						<h3>
							<xsl:text>Snapshot of non-empty fields before commit</xsl:text>
						</h3>
						<xsl:for-each select="Script/Version[(@mode=ancestor::Sequence/Inputs/InputMessage/FieldValues/@Mode) or (@Baseline_mode=ancestor::Sequence/Inputs/InputMessage/FieldValues/@Baseline_Mode)]">
							<xsl:variable name="openVersionCount" select="count(.//RECEIVED[contains(@Command, '-OpenVersion') and position()=last()])"/>
							<xsl:choose>
								<xsl:when test="(@mode='A' or @Baseline_mode='A' or @mode='S' or @Baseline_mode='S') and $openVersionCount>0">
									<xsl:apply-templates select=".//RECEIVED[contains(@Command, '-OpenVersion') and position()=last()]" mode="version">
										<xsl:with-param name="postfix" select="@mode"/>
									</xsl:apply-templates>
								</xsl:when>
								<xsl:when test="(@mode='A' or @Baseline_mode='A' or @mode='S' or @Baseline_mode='S') and $openVersionCount=0">
									<xsl:apply-templates select="ancestor::Sequence/preceding-sibling::Sequence[1]//RECEIVED[contains(@Command, '-ExecuteDrillAction') and position()=last()]" mode="version">
										<xsl:with-param name="postfix" select="@mode"/>
									</xsl:apply-templates>
								</xsl:when>
								<xsl:otherwise>
									<xsl:apply-templates select=".//RECEIVED[contains(@Command, '-FillVersion') and position()=last()]" mode="version">
										<xsl:with-param name="postfix" select="@mode"/>
									</xsl:apply-templates>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</xsl:if>

					<xsl:if test="Script/Version[@mode='S']/RunLog/INFO[@Text='Checking output fields']">
						<xsl:call-template name="checkOutput">
							<xsl:with-param name="node" select="."/>
						</xsl:call-template>
					</xsl:if>

					<xsl:if test="Script/Version[(@mode='S') or (@Baseline_mode='S')]/*[contains(name(),'VersionFields')]/descendant::*[@value!='' or @Baseline_value!=''] and (ancestor::Sequence/Inputs/InputMessage/FieldValues/@Mode!='S' or ancestor::Sequence/Inputs/InputMessage/FieldValues/@Baseline_Mode!='S')">
						<h3>
							<xsl:text>Snapshot of non-empty fields after commit</xsl:text>
						</h3>
						<xsl:for-each select="Script/Version[(@mode='S') or (@Baseline_mode='S')]">
							<xsl:apply-templates select=".//RECEIVED[contains(@Command, '-OpenVersion') and position()=last()]" mode="version">
								<xsl:with-param name="postfix" select="@mode"/>
							</xsl:apply-templates>
							<br/>
						</xsl:for-each>
					</xsl:if>
					<br/>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="checkInput">
		<xsl:variable name="exp" select="'as expected'"/>
		<h3>
			<xsl:text>Checking of input fields</xsl:text>
		</h3>
		<table width="100%" border="2">
			<thead>
				<tr>
					<th colspan="4" align="center">
						<xsl:text>Expected values</xsl:text>
					</th>
				</tr>
				<tr>
					<th>Field name</th>
					<th>Message</th>
				</tr>
			</thead>
			<tbody>
				<xsl:for-each select=".//SET_FIELD[@OriginalExpected]">
					<tr>
						<td>
							<xsl:attribute name="class">
								<xsl:choose>
									<xsl:when test="contains(./Testcase/@Text, $exp)">matchExpected</xsl:when>
									<xsl:otherwise>noMatchExpected</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
							<xsl:value-of select="@Text"/>
						</td>
						<td>
							<xsl:value-of select="./Testcase/@Text"/>
						</td>
					</tr>
				</xsl:for-each>
			</tbody>
		</table>
		<br/>
	</xsl:template>

	<xsl:template name="checkOutput">
		<xsl:param name="node"/>
		<xsl:variable name="exp" select="'as expected'"/>
		<xsl:if test="$node/Script/Version[@mode='S']/RunLog/INFO[@Text='Checking output fields']">
			<h3>
				<xsl:text>Checking of output fields</xsl:text>
			</h3>
			<xsl:for-each select="$node/Script/Version[@mode='S']/RunLog/INFO[@Text='Checking output fields']">
				<table width="100%" border="2">
					<thead>
						<tr>
							<th colspan="4" align="center">
								<xsl:text>Expected values</xsl:text>
							</th>
						</tr>
						<tr>
							<th>Field name</th>
							<th>Message</th>
						</tr>
					</thead>
					<tbody>
						<xsl:for-each select="./INFO">
							<tr>
								<td>
									<xsl:attribute name="class">
										<xsl:choose>
											<xsl:when test="contains(./Testcase/@Text, $exp)">matchExpected</xsl:when>
											<xsl:otherwise>noMatchExpected</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
									<xsl:value-of select="substring-after(@Text,'Output field: ')"/>
								</td>
								<td>
									<xsl:value-of select="./Testcase/@Text"/>
								</td>
							</tr>
						</xsl:for-each>
					</tbody>
				</table>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>

	<xsl:variable name="isCompare">
		<xsl:choose>
			<xsl:when test="Root/@TestManager_isDifference">
				<xsl:number value="1"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:number value="0"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="numberOfDefect">
		<xsl:value-of select="count(//Defect)"/>
	</xsl:variable>

	<xsl:template name="unzip">
		<xsl:param name="text.zip"/>
		<xsl:variable name="text">
			<xsl:choose>
				<xsl:when test="starts-with($text.zip,'***fetchit(')">
					<xsl:if test="ancestor-or-self::Call">
						<xsl:value-of select="utils2:getText($text.zip, $file, ancestor-or-self::Call/@xmloutFile)"/>
					</xsl:if>
					<xsl:if test="not(ancestor-or-self::Call)">
						<xsl:value-of select="utils2:getText($text.zip, $file)"/>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="util:getZippedContent($text.zip)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$text"/>
	</xsl:template>

	<xsl:template name="replace-string">
		<xsl:param name="text"/>
		<xsl:param name="replace"/>
		<xsl:param name="with"/>
		<xsl:variable name="str" select="java:java.lang.String.new(string($text))"/>
		<xsl:value-of select="java:replaceAll($str, $replace, $with)"/>
	</xsl:template>

	<xsl:template name="putRecHtml">
		<xsl:param name="html"/>
		<xsl:value-of disable-output-escaping="yes" select="$html"/>
	</xsl:template>

	<xsl:template name="reportHead">

		<div id="header">
			<table style="width:100%">
				<tr>
					<td style="text-align:left">
						<xsl:value-of select="$testCycle"/>
					</td>
					<td>
						<div id="headLogo"/>
					</td>
					<td style="text-align:right">
						<xsl:value-of select="$sutEnvironment"/>
					</td>
				</tr>
			</table>
		</div>

		<div id="footer">
			<table style="width:100%">
				<tr>
					<td style="text-align:left">Page
						<span id="pagenumber"/>of
						<span id="pagecount"/>
					</td>
					<td style="text-align:center">
						<xsl:value-of select="$projName"/>
					</td>
					<td style="text-align:right">
						<xsl:value-of select="$title"/>
					</td>
				</tr>
			</table>
		</div>

		<table class="infoTable" style="font-size:1.2em;">
			<tr style="font-size:1.2em;">
				<td class="iName">Project:</td>
				<td class="iValue" style="font-weight: bold;">
					<xsl:value-of select="$projName"/>
				</td>
			</tr>
			<tr style="font-size:1.2em;">
				<td class="iName">Test Cycle:</td>
				<td class="iValue" style="font-weight: bold;">
					<xsl:value-of select="$testCycle"/>
				</td>
			</tr>
			<tr>
				<td class="iName">Cycle Schedule:</td>
				<td class="iValue">
					<xsl:value-of select="$testStartDate"/>
				</td>
			</tr>
			<tr>
				<td class="iName">Test Environment:</td>
				<td class="iValue">
					<xsl:value-of select="$sutEnvironment"/>
				</td>
			</tr>
			<tr>
				<td class="iName">System Version:</td>
				<td class="iValue">
					<xsl:value-of select="$sutVersion"/>
				</td>
			</tr>
		</table>
	</xsl:template>

	<xsl:template name="tcHead">
		<xsl:param name="tagging"/>
		<xsl:param name="action"/>
		<xsl:param name="tcNo"/>
		<xsl:param name="name"/>
		<xsl:param name="day"/>
		<xsl:param name="phase"/>
		<xsl:param name="type"/>
		<xsl:param name="subject"/>
		<xsl:param name="seqNo"/>

		<xsl:variable name="tcTitle">
			<xsl:value-of select="$tcNo"/>Test Case :
			<xsl:value-of select="$name"/>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="substring-after($tcNo, '.')=''">
				<h2 style="white-space:normal;">
					<xsl:value-of select="$tcTitle"/>
				</h2>
			</xsl:when>
			<xsl:otherwise>
				<h3 style="white-space:normal;">
					<xsl:value-of select="$tcTitle"/>
				</h3>
			</xsl:otherwise>
		</xsl:choose>

		<div class="tcInfo">
			<xsl:element name="div">
				<xsl:attribute name="class">
					<xsl:call-template name="type-class">
						<xsl:with-param name="type" select="$type"/>
					</xsl:call-template>
				</xsl:attribute>
				<xsl:call-template name="type-text">
					<xsl:with-param name="type" select="$type"/>
				</xsl:call-template>
				<xsl:value-of select="concat(' in ', $day)"/>
			</xsl:element>
			<xsl:element name="div">
				<xsl:value-of select="$action" />
				<xsl:value-of select="$subject" />
				<xsl:if test="''!=$tagging">
					<br />Error or comment:<br />
					<xsl:value-of select="$tagging" />
				</xsl:if>
			</xsl:element>
		</div>
	</xsl:template>

	<xsl:template name="seq-tcNo">
		<xsl:for-each select="ancestor-or-self::Sequence">
			<xsl:choose>
				<xsl:when test="@number!=''">
					<xsl:value-of select="@number"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@Baseline_number"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>.</xsl:text>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="seq-comment">
		<xsl:choose>
			<xsl:when test="@comment!=''">
				<xsl:value-of select="@comment"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="@Baseline_comment"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="type-text">
		<xsl:param name="type"/>
		<xsl:choose>
			<xsl:when test="$type='Preparatory'">
				<xsl:value-of select="'Preparatory Action'"/>
			</xsl:when>
			<xsl:when test="$type='Test'">
				<xsl:value-of select="'Test Action'"/>
			</xsl:when>
			<xsl:when test="$type='Check'">
				<xsl:value-of select="'Check Action'"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="type-class">
		<xsl:param name="type"/>
		<xsl:choose>
			<xsl:when test="$type='Preparatory'">
				<xsl:value-of select="'tctype prep'"/>
			</xsl:when>
			<xsl:when test="$type='Test'">
				<xsl:value-of select="'tctype tst'"/>
			</xsl:when>
			<xsl:when test="$type='Check'">
				<xsl:value-of select="'tctype chk'"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="commit-table">
		<xsl:param name="id"/>
		<div class="com" name="com">
			<xsl:attribute name="id">
				<xsl:text>com</xsl:text>
				<xsl:value-of select="$id"/>
			</xsl:attribute>
			<xsl:element name="table">
				<xsl:attribute name="width">100%</xsl:attribute>
				<xsl:attribute name="style">
					<xsl:choose>
						<xsl:when test="contains(@Text, 'fail')">border:6px solid red; -webkit-border-radius:1px;-moz-border-radius:1px;-ms-border-radius:1px;-o-border-radius:1px;border-radius:1px;</xsl:when>
						<xsl:otherwise>border:6px solid green; -webkit-border-radius:13px;-moz-border-radius:13px;-ms-border-radius:13px;-o-border-radius:13px;border-radius:13px;</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<thead>
					<tr>
						<th colspan="2" align="center">
							<xsl:text>Commit</xsl:text>
						</th>
					</tr>
					<xsl:if test="$isCompare=1">
						<tr>
							<th>Value</th>
							<th>Baseline value</th>
						</tr>
					</xsl:if>
				</thead>
				<tbody>
					<tr>
						<xsl:if test="$isCompare=1">
							<xsl:if test="contains(@TestManager_DiffType,'Changed')">
								<xsl:attribute name="class">changed</xsl:attribute>
							</xsl:if>
							<xsl:if test="contains(@TestManager_DiffType,'Added')">
								<xsl:attribute name="class">added</xsl:attribute>
							</xsl:if>
							<xsl:if test="contains(@TestManager_DiffType,'Removed')">
								<xsl:attribute name="class">removed</xsl:attribute>
							</xsl:if>
						</xsl:if>
						<td>
							<xsl:value-of select="@Text"/>
						</td>
						<xsl:if test="$isCompare=1">
							<td>
								<xsl:value-of select="@Baseline_Text"/>
							</td>
							<xsl:if test="./Defect">
								<td>

									<a>
										<xsl:attribute name="id">
											<xsl:text>def</xsl:text>
											<xsl:number value="count(preceding::Defect)"/>
										</xsl:attribute>
										<xsl:attribute name="name">
											<xsl:text>defect</xsl:text>
											<xsl:value-of select="./Defect/@id"/>
										</xsl:attribute>

										<xsl:for-each select="Defect">
											<xsl:value-of select="@id"/>
											<xsl:text>(</xsl:text>
											<xsl:value-of select="@name"/>
											<xsl:text>)</xsl:text>
											<br/>
										</xsl:for-each>

										<xsl:call-template name="defectButtons">
											<xsl:with-param name="defectnumber" select="count(preceding::Defect)"/>
										</xsl:call-template>
										<input value="x" type="button">
											<xsl:attribute name="onclick">
												<xsl:text>hidingDefectFromDefects('</xsl:text>
												<xsl:value-of select="./Defect/@id"/>
												<xsl:text>');</xsl:text>
											</xsl:attribute>
										</input>
									</a>
								</td>
							</xsl:if>
						</xsl:if>
					</tr>
				</tbody>
			</xsl:element>
		</div>
	</xsl:template>

	<xsl:template match="RECEIVED" mode="version">
		<xsl:param name="postfix"/>
		<xsl:variable name="appt">appreq</xsl:variable>
		<xsl:variable name="apps">appreq-
			<xsl:value-of select="ancestor::Day/@value"/>-
			<xsl:value-of select="ancestor::Sequence/@number"/>-
			<xsl:value-of select="$postfix"/>
		</xsl:variable>
		<xsl:variable name="text_html">
			<xsl:choose>
				<xsl:when test="@Text">
					<xsl:value-of select="@Text"/>
				</xsl:when>
				<xsl:when test="@Text.zip">
					<xsl:call-template name="unzip">
						<xsl:with-param name="text.zip" select="@Text.zip"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>-</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="newText">
			<xsl:choose>
				<xsl:when test="contains($text_html, '&lt;div class=&quot;dprocessing&quot; id=')">
					<!-- R12 -->
					<xsl:call-template name="replace-string">
						<xsl:with-param name="text" select="substring-before(substring-after($text_html,'&lt;img border=&quot;0&quot; src=&quot;../plaf/images/default/gears.gif&quot;&gt;&lt;/div&gt;'),'&lt;form name=&quot;generalForm&quot; method=&quot;POST&quot; action=&quot;BrowserServlet&quot; id=&quot;generalForm&quot;&gt;')"/>
						<xsl:with-param name="replace" select="$appt"/>
						<xsl:with-param name="with" select="$apps"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="replace-string">
						<xsl:with-param name="text" select="substring-before(substring-after($text_html,'&lt;div class=&quot;dheader&quot; id=&quot;divHeader&quot;&gt;'),'&lt;form name=&quot;generalForm&quot; method=&quot;POST&quot; action=&quot;BrowserServlet&quot; id=&quot;generalForm&quot;&gt;')"/>
						<xsl:with-param name="replace" select="$appt"/>
						<xsl:with-param name="with" select="$apps"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="tabt">'tab</xsl:variable>
		<xsl:variable name="tabs">'tab-
			<xsl:value-of select="ancestor::Day/@value"/>-
			<xsl:value-of select="ancestor::Sequence/@number"/>-
			<xsl:value-of select="$postfix"/>
		</xsl:variable>
		<xsl:variable name="newText2">
			<xsl:call-template name="replace-string">
				<xsl:with-param name="text" select="$newText"/>
				<xsl:with-param name="replace" select="$tabt"/>
				<xsl:with-param name="with" select="$tabs"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="tabt2">id="tab</xsl:variable>
		<xsl:variable name="tabs2">id="tab-
			<xsl:value-of select="ancestor::Day/@value"/>-
			<xsl:value-of select="ancestor::Sequence/@number"/>-
			<xsl:value-of select="$postfix"/>
		</xsl:variable>
		<xsl:variable name="newText3">
			<xsl:call-template name="replace-string">
				<xsl:with-param name="text" select="$newText2"/>
				<xsl:with-param name="replace" select="$tabt2"/>
				<xsl:with-param name="with" select="$tabs2"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="tabt3">value="tab</xsl:variable>
		<xsl:variable name="tabs3">value="tab-
			<xsl:value-of select="ancestor::Day/@value"/>-
			<xsl:value-of select="ancestor::Sequence/@number"/>-
			<xsl:value-of select="$postfix"/>
		</xsl:variable>
		<xsl:variable name="newText4">
			<xsl:call-template name="replace-string">
				<xsl:with-param name="text" select="$newText3"/>
				<xsl:with-param name="replace" select="$tabt3"/>
				<xsl:with-param name="with" select="$tabs3"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="tabt4">tabname="tab</xsl:variable>
		<xsl:variable name="tabs4">tabname="tab-
			<xsl:value-of select="ancestor::Day/@value"/>-
			<xsl:value-of select="ancestor::Sequence/@number"/>-
			<xsl:value-of select="$postfix"/>
		</xsl:variable>
		<xsl:variable name="newText5">
			<xsl:call-template name="replace-string">
				<xsl:with-param name="text" select="$newText4"/>
				<xsl:with-param name="replace" select="$tabt4"/>
				<xsl:with-param name="with" select="$tabs4"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="newText6">
			<xsl:call-template name="replace-string">
				<xsl:with-param name="text" select="$newText5"/>
				<xsl:with-param name="replace" select="'&quot;../plaf'"/>
				<xsl:with-param name="with" select="concat('&quot;file:/',$browserDir,'/../plaf')"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="newText7">
			<xsl:call-template name="replace-string">
				<xsl:with-param name="text" select="$newText6"/>
				<xsl:with-param name="replace" select="'&quot;../html'"/>
				<xsl:with-param name="with" select="concat('&quot;file:/',$browserDir,'/../html')"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="tabt5">class="tab</xsl:variable>
		<xsl:variable name="tabs5">class="tab-
			<xsl:value-of select="ancestor::Day/@value"/>-
			<xsl:value-of select="ancestor::Sequence/@number"/>-
			<xsl:value-of select="$postfix"/>
		</xsl:variable>
		<xsl:variable name="newText8">
			<xsl:call-template name="replace-string">
				<xsl:with-param name="text" select="$newText7"/>
				<xsl:with-param name="replace" select="$tabt5"/>
				<xsl:with-param name="with" select="$tabs5"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="image">
			<xsl:value-of select="htmlutils:getHtmlImage($text_html, $browserDir, $pdfCss, 'T24')">
			</xsl:value-of>
		</xsl:variable>
		
		<xsl:call-template name="putRecHtml">
			<xsl:with-param name="html" select="$image"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="RECEIVED" mode="enquiry">
		<xsl:param name="postfix"/>

		<xsl:variable name="text_html">
			<xsl:choose>
				<xsl:when test="@Text">
					<xsl:value-of select="@Text"/>
				</xsl:when>
				<xsl:when test="@Text.zip">
					<xsl:call-template name="unzip">
						<xsl:with-param name="text.zip" select="@Text.zip"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>-</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="image">
			<xsl:value-of select="htmlutils:getHtmlImage($text_html, $browserDir, $pdfCss, 'T24')">
			</xsl:value-of>
		</xsl:variable>

		<xsl:text disable-output-escaping="yes">&lt;div class=&quot;denqresponse&quot;&gt;</xsl:text>
		<xsl:call-template name="putRecHtml">
			<xsl:with-param name="html" select="$image"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="/">
		<xsl:variable name="projName" select="//@projName"/>
		<xsl:variable name="testCycle" select="//@testCycle"/>
		<xsl:variable name="testStartDate" select="//@testStartDate"/>
		<xsl:variable name="sutVersion" select="//@sutVersion"/>
		<xsl:variable name="sutEnvironment" select="//@sutEnvironment"/>
		<xsl:variable name="title">
			<xsl:choose>
				<xsl:when test="./Root/ExecutionLog/@comment!=''">
					<xsl:value-of select="./Root/ExecutionLog/@comment"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="./Root/ExecutionLog/@fileName"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
			<head>
				<xsl:element name="meta">
					<xsl:attribute name="name">browserWeb</xsl:attribute>
					<xsl:attribute name="content">
						<xsl:value-of select="//@browserWeb"/>
					</xsl:attribute>
				</xsl:element>
				<title>
					<xsl:value-of select="$title"/>
				</title>

				<link rel="stylesheet" type="text/css" href="file:/{$browserDir}/../plaf/style/default/general.css"/>
				<link rel="stylesheet" type="text/css" href="file:/{$browserDir}/../plaf/style/default/custom.css"/>

				<xsl:element name="link">
					<xsl:attribute name="rel">stylesheet</xsl:attribute>
					<xsl:attribute name="type">text/css</xsl:attribute>
					<xsl:attribute name="href">
						<xsl:value-of select="$pdfCss"/>
					</xsl:attribute>
				</xsl:element>
			</head>
			<body>

				<div id="xmainPage">
				<xsl:value-of disable-output-escaping="yes" select="$logo"/>
				<!-- <table class="infoTable" style="width=100%">
					<tr>
						<td>HAlleluja </td>
						<td><xsl:value-of disable-output-escaping="yes" select="$logo"/> </td>
					</tr>
				</table>
				 -->
					<xsl:for-each select=".//ExecutionLog">
						<xsl:if test="@comment != ''">
							<xsl:for-each select="@comment">
								<h1>
									<xsl:value-of select="."/>
								</h1>
							</xsl:for-each>
						</xsl:if>
						<a id="main">
							<h3>
								<xsl:value-of select=".//ExecutionLog/@fileName"/>
							</h3>
						</a>
						<p/>
					</xsl:for-each>

					<xsl:call-template name="reportHead">
						<xsl:with-param name="title" select="$title"/>
						<xsl:with-param name="projName" select="$projName"/>
						<xsl:with-param name="testCycle" select="$testCycle"/>
						<xsl:with-param name="testStartDate" select="$testStartDate"/>
						<xsl:with-param name="sutVersion" select="$sutVersion"/>
						<xsl:with-param name="sutEnvironment" select="$sutEnvironment"/>
					</xsl:call-template>

					<xsl:for-each select="Root">
						<xsl:apply-templates mode="Root"/>
					</xsl:for-each>
				</div>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="ExecutionLog" mode="Root">
		<xsl:if test="$isCompare=1">
			<h2>
				<xsl:text>Logical Attributes</xsl:text>
			</h2>
			<xsl:apply-templates select="./Day/LogicalAttributes"/>
		</xsl:if>
		<xsl:apply-templates mode="ExecutionLog"/>
	</xsl:template>

	<xsl:template match="Day[./Sequence/Inputs/InputMessage]" mode="ExecutionLog">
		<xsl:variable name="currentDay">
			<xsl:choose>
				<xsl:when test="@value!=''">
					<xsl:value-of select="@value"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@Baseline_value"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>. day, </xsl:text>
			<xsl:choose>
				<xsl:when test="@phase!=''">
					<xsl:value-of select="@phase"/>
				</xsl:when>
				<xsl:when test="@Baseline_phase!=''">
					<xsl:value-of select="@Baseline_phase"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>main</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text> phase</xsl:text>
		</xsl:variable>
		<hr/>
		<a class="daypage">
			<xsl:attribute name="id">
				<xsl:text>day</xsl:text>
				<xsl:choose>
					<xsl:when test="@value!=''">
						<xsl:value-of select="@value"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="@Baseline_value"/>
					</xsl:otherwise>
				</xsl:choose>

				<xsl:choose>
					<xsl:when test="@phase!=''">
						<xsl:text>_</xsl:text>
						<xsl:value-of select="@phase"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>_</xsl:text>
						<xsl:value-of select="@Baseline_phase"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<h1>
				<xsl:value-of select="$currentDay"/>
				<xsl:text>:</xsl:text>
			</h1>
		</a>
		<div class="daydiv" name="daydiv">
			<xsl:attribute name="id">
				<xsl:text>daydiv</xsl:text>
				<xsl:value-of select="generate-id(.)"/>
			</xsl:attribute>
			<xsl:apply-templates select="./Sequence" mode="Day">
				<xsl:with-param name="day" select="$currentDay"/>
			</xsl:apply-templates>
		</div>
	</xsl:template>


	<xsl:template match="Sequence[./Inputs/InputMessage/Call]" mode="Day">
		<xsl:param name="day"/>

		<xsl:variable name="comment">
			<xsl:call-template name="seq-comment"/>
		</xsl:variable>
		<xsl:variable name="tcNo">
			<xsl:call-template name="seq-tcNo"/>
		</xsl:variable>
		<xsl:variable name="seqNo">seq
			<xsl:call-template name="seq-tcNo"/>
		</xsl:variable>
		<xsl:variable name="type">
			<xsl:value-of select="@type"/>
		</xsl:variable>
		<xsl:variable name="tagging">
			<xsl:value-of select="./Outputs/Script/Call/Result[1]/Testcase[@Status='1']/@Text" />
		</xsl:variable>

		<div style="margin-left:0px">
			<a>
				<xsl:call-template name="tcHead">
					<xsl:with-param name="action">
						<xsl:value-of select="'Calling Test Scenario '"/>
					</xsl:with-param>
					<xsl:with-param name="day">
						<xsl:value-of select="$day"/>
					</xsl:with-param>
					<xsl:with-param name="name">
						<xsl:value-of select="$comment" disable-output-escaping="yes"/>
					</xsl:with-param>
					<xsl:with-param name="subject">
						<xsl:value-of select="./Inputs/InputMessage/Call/@callee"/>
					</xsl:with-param>
					<xsl:with-param name="tcNo">
						<xsl:value-of select="$tcNo"/>
					</xsl:with-param>
					<xsl:with-param name="type">
						<xsl:value-of select="$type" />
					</xsl:with-param>
					<!-- Using for missing/unparseable pack log error message -->
					<xsl:with-param name="tagging">
						<xsl:value-of select="$tagging" />
					</xsl:with-param>
				</xsl:call-template>
			</a>
		</div>
		<xsl:if test="@type!='Preparatory'">
			<xsl:apply-templates select=".//Sequence" mode="Day">
				<xsl:with-param name="day" select="$day"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

	<xsl:template match="Sequence[not(.//Call) and ./Inputs/InputMessage[not(.//Call)]]" mode="Day">
		<xsl:param name="day"/>

		<xsl:variable name="comment">
			<xsl:call-template name="seq-comment"/>
		</xsl:variable>
		<xsl:variable name="tcNo">
			<xsl:call-template name="seq-tcNo"/>
		</xsl:variable>
		<xsl:variable name="seqNo">seq
			<xsl:call-template name="seq-tcNo"/>
		</xsl:variable>
		<xsl:variable name="type">
			<xsl:value-of select="@type"/>
		</xsl:variable>

		<xsl:if test=".//RunLog">

			<xsl:for-each select="./Inputs/InputMessage/FieldValues">
				<xsl:variable name="itId">
					<xsl:choose>
						<xsl:when test="../@iteration!=''">
							<xsl:value-of select="../@iteration"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="../@Baseline_iteration"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="menuId">
					<xsl:value-of select="generate-id(.)"/>
				</xsl:variable>

				<xsl:variable name="versionMode">
					<xsl:choose>
						<xsl:when test="./@Mode!=''">
							<xsl:value-of select="./@Mode"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="./@Baseline_Mode"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<div style="margin-left:0px">
					<xsl:attribute name="onmouseover">
						<xsl:text>menuInJump('menu</xsl:text>
						<xsl:value-of select="$menuId"/>
						<xsl:text>');</xsl:text>
					</xsl:attribute>
					<xsl:attribute name="ondblclick">
						<xsl:text>bookmarkSequence('menu</xsl:text>
						<xsl:value-of select="$menuId"/>
						<xsl:text>');</xsl:text>
					</xsl:attribute>
	
	
					<xsl:variable name="tagging">
						<xsl:text> version in </xsl:text>
						<xsl:choose>
							<xsl:when test="@Mode!=''">
								<xsl:value-of select="@Mode"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="@Baseline_Mode"/>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:text> mode</xsl:text>
						<xsl:if test="@usergroup or @Baseline_usergroup">
							<xsl:text> with </xsl:text>
							<xsl:choose>
								<xsl:when test="@usergroup!=''">
									<xsl:value-of select="@usergroup"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="@Baseline_usergroup"/>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:text> user</xsl:text>
						</xsl:if>
						<xsl:if test="@bpUsergroup or @Baseline_bpUserGroup">
							<xsl:text> with </xsl:text>
							<xsl:choose>
								<xsl:when test="@bpUsergroup!=''">
									<xsl:value-of select="@bpUsergroup"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="@Baseline_bpUsergroup"/>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:text> user</xsl:text>
						</xsl:if>
						<xsl:text>, commit has to be </xsl:text>
						<xsl:choose>
							<xsl:when test="@Commit!=''">
								<xsl:value-of select="@Commit"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="@Baseline_Commit"/>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:if test="../@iteration or ../@Baseline_iteration or ancestor::Iteration">
							<xsl:text> Iteration: </xsl:text>
							<xsl:choose>
								<xsl:when test="ancestor::Iteration/@number!=''">
									<xsl:value-of select="ancestor::Iteration/@number"/>
								</xsl:when>
								<xsl:when test="ancestor::Iteration/@Baseline_number!=''">
									<xsl:value-of select="ancestor::Iteration/@Baseline_number"/>
								</xsl:when>
								<xsl:when test="../@iteration!=''">
									<xsl:value-of select="../@iteration"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="../@Baseline_iteration"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:if>
					</xsl:variable>
	
					<a>
						<xsl:attribute name="id">
							<xsl:value-of select="$menuId"/>
						</xsl:attribute>
	
	
						<xsl:call-template name="tcHead">
							<xsl:with-param name="action">
								<xsl:value-of select="'Opening '"/>
							</xsl:with-param>
							<xsl:with-param name="tagging">
								<xsl:value-of select="$tagging"/>
							</xsl:with-param>
							<xsl:with-param name="day">
								<xsl:value-of select="$day"/>
							</xsl:with-param>
							<xsl:with-param name="name">
								<xsl:value-of select="$comment" disable-output-escaping="yes"/>
							</xsl:with-param>
							<xsl:with-param name="subject">
								<xsl:choose>
									<xsl:when test="@version!=''">
										<xsl:value-of select="@version"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="@Baseline_version"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:with-param>
							<xsl:with-param name="seqNo">
								<xsl:value-of select="$seqNo"/>
							</xsl:with-param>
							<xsl:with-param name="tcNo">
								<xsl:value-of select="$tcNo"/>
							</xsl:with-param>
							<xsl:with-param name="type">
								<xsl:value-of select="$type"/>
							</xsl:with-param>
						</xsl:call-template>
					</a>
	
					<xsl:if test="$type!='Preparatory'">
						<xsl:choose>
							<xsl:when test="../../../Outputs/Iteration">
								<xsl:for-each select="../../../Outputs/Iteration[@number=$itId  or @Baseline_number=$itId]">
									<div class="sfv" name="sfv">
										<xsl:attribute name="id">
											<xsl:text>sfv</xsl:text>
											<xsl:value-of select="$menuId"/>
										</xsl:attribute>
	
										<xsl:for-each select=".//Testcase[starts-with(@Text,'Commit')]">
											<xsl:if test="preceding-sibling::Testcase[starts-with(@Text,'Override reason')]">
												<div class="or" name="or">
													<xsl:attribute name="id">
														<xsl:text>or</xsl:text>
														<xsl:value-of select="generate-id(.)"/>
													</xsl:attribute>
	
													<table width="100%" border="2">
														<thead>
															<tr>
																<th colspan="2" align="center">
																	<xsl:text>Override reason(s)</xsl:text>
																</th>
															</tr>
															<xsl:if test="$isCompare=1">
																<tr>
																	<th>Value</th>
																	<th>Baseline value</th>
																</tr>
															</xsl:if>
														</thead>
														<tbody>
															<xsl:for-each select="preceding-sibling::Testcase[starts-with(@Text,'Override reason')]">
																<tr>
																	<xsl:if test="$isCompare=1">
																		<xsl:if test="contains(@TestManager_DiffType,'Changed')">
																			<xsl:attribute name="class">changed</xsl:attribute>
																		</xsl:if>
																		<xsl:if test="contains(@TestManager_DiffType,'Added')">
																			<xsl:attribute name="class">added</xsl:attribute>
																		</xsl:if>
																		<xsl:if test="contains(@TestManager_DiffType,'Removed')">
																			<xsl:attribute name="class">removed</xsl:attribute>
																		</xsl:if>
																	</xsl:if>
																	<td>
																		<xsl:value-of select="@Text"/>
																	</td>
																	<xsl:if test="$isCompare=1">
																		<td>
																			<xsl:value-of select="@Baseline_Text"/>
																		</td>
																		<xsl:if test="./Defect">
																			<td>
																				<a>
																					<xsl:attribute name="id">
																						<xsl:text>def</xsl:text>
																						<xsl:number value="count(preceding::Defect)"/>
																					</xsl:attribute>
																					<xsl:attribute name="name">
																						<xsl:text>defect</xsl:text>
																						<xsl:value-of select="./Defect/@id"/>
																					</xsl:attribute>
	
																					<xsl:for-each select="Defect">
																						<xsl:value-of select="@id"/>
																						<xsl:text>(</xsl:text>
																						<xsl:value-of select="@name"/>
																						<xsl:text>)</xsl:text>
																						<br/>
																					</xsl:for-each>
	
																					<xsl:call-template name="defectButtons">
																						<xsl:with-param name="defectnumber" select="count(preceding::Defect)"/>
																					</xsl:call-template>
																					<input value="x" type="button">
																						<xsl:attribute name="onclick">
																							<xsl:text>hidingDefectFromDefects('</xsl:text>
																							<xsl:value-of select="./Defect/@id"/>
																							<xsl:text>');</xsl:text>
																						</xsl:attribute>
																					</input>
																				</a>
																			</td>
																		</xsl:if>
																	</xsl:if>
																</tr>
															</xsl:for-each>
														</tbody>
													</table>
												</div>
											</xsl:if>
	
											<!--Error text messages in the VersionFileds -->
											<xsl:if test="../../../*[contains(name(),'VersionFields')]//*[@errorText!='']">
												<div class="em" name="em">
													<xsl:attribute name="id">
														<xsl:text>em</xsl:text>
														<xsl:value-of select="generate-id(.)"/>
													</xsl:attribute>
													<table width="100%" border="2">
														<thead>
															<tr>
																<th colspan="3" align="center">
																	<strong>Error message(s)</strong>
																</th>
															</tr>
	
															<tr>
																<th>Field name</th>
																<th>Value</th>
																<xsl:if test="$isCompare=1">
																	<th>Baseline value</th>
																</xsl:if>
															</tr>
														</thead>
														<tbody>
															<xsl:for-each select="../../../*[contains(name(),'VersionFields')]//*[@errorText!='']">
																<tr>
																	<xsl:if test="$isCompare=1">
																		<xsl:if test="contains(@TestManager_DiffType,'Changed')">
																			<xsl:attribute name="class">changed</xsl:attribute>
																		</xsl:if>
																		<xsl:if test="contains(@TestManager_DiffType,'Added')">
																			<xsl:attribute name="class">added</xsl:attribute>
																		</xsl:if>
																		<xsl:if test="contains(@TestManager_DiffType,'Removed')">
																			<xsl:attribute name="class">removed</xsl:attribute>
																		</xsl:if>
																	</xsl:if>
																	<td>
																		<xsl:text>(</xsl:text>
																		<xsl:choose>
																			<xsl:when test="@fieldNumber1!=''">
																				<xsl:value-of select="@fieldNumber1"/>
																			</xsl:when>
																			<xsl:otherwise>
																				<xsl:value-of select="@Baseline_fieldNumber1"/>
																			</xsl:otherwise>
																		</xsl:choose>
																		<xsl:for-each select="ancestor::Value">
																			<xsl:text>.</xsl:text>
																			<xsl:choose>
																				<xsl:when test="@number!=''">
																					<xsl:value-of select="@number"/>
																				</xsl:when>
																				<xsl:otherwise>
																					<xsl:value-of select="@Baseline_number"/>
																				</xsl:otherwise>
																			</xsl:choose>
																		</xsl:for-each>
																		<xsl:text>) </xsl:text>
																		<xsl:value-of select="name()"/>
																	</td>
																	<td>
																		<xsl:value-of select="@errorText"/>
																	</td>
																	<xsl:if test="$isCompare=1">
																		<td>
																			<xsl:value-of select="@Baseline_errorText"/>
																		</td>
																		<xsl:if test="./Defect">
																			<td>
	
																				<a>
																					<xsl:attribute name="id">
																						<xsl:text>def</xsl:text>
																						<xsl:number value="count(preceding::Defect)"/>
																					</xsl:attribute>
																					<xsl:attribute name="name">
																						<xsl:text>defect</xsl:text>
																						<xsl:value-of select="./Defect/@id"/>
																					</xsl:attribute>
	
																					<xsl:for-each select="Defect">
																						<xsl:value-of select="@id"/>
																						<xsl:text>(</xsl:text>
																						<xsl:value-of select="@name"/>
																						<xsl:text>)</xsl:text>
																						<br/>
																					</xsl:for-each>
	
	
																					<xsl:call-template name="defectButtons">
																						<xsl:with-param name="defectnumber" select="count(preceding::Defect)"/>
																					</xsl:call-template>
																					<input value="x" type="button">
																						<xsl:attribute name="onclick">
																							<xsl:text>hidingDefectFromDefects('</xsl:text>
																							<xsl:value-of select="./Defect/@id"/>
																							<xsl:text>');</xsl:text>
																						</xsl:attribute>
																					</input>
																				</a>
																			</td>
																		</xsl:if>
																	</xsl:if>
																</tr>
															</xsl:for-each>
														</tbody>
													</table>
												</div>
											</xsl:if>
	
											<xsl:if test="preceding-sibling::*[starts-with(@Text,'Error message')]">
												<div class="erdc" name="erdc">
													<xsl:attribute name="id">
														<xsl:text>erdc</xsl:text>
														<xsl:value-of select="generate-id(.)"/>
													</xsl:attribute>
													<table width="100%" border="2">
														<thead>
															<tr>
																<th colspan="2" align="center">
																	<xsl:text>Error reason(s) during commit</xsl:text>
																</th>
															</tr>
															<xsl:if test="$isCompare=1">
																<tr>
																	<th>Value</th>
																	<th>Baseline value</th>
																</tr>
															</xsl:if>
														</thead>
														<tbody>
															<xsl:for-each select="preceding-sibling::*[starts-with(@Text,'Error message')]">
																<tr>
																	<xsl:if test="$isCompare=1">
																		<xsl:if test="contains(@TestManager_DiffType,'Changed')">
																			<xsl:attribute name="class">changed</xsl:attribute>
																		</xsl:if>
																		<xsl:if test="contains(@TestManager_DiffType,'Added')">
																			<xsl:attribute name="class">added</xsl:attribute>
																		</xsl:if>
																		<xsl:if test="contains(@TestManager_DiffType,'Removed')">
																			<xsl:attribute name="class">removed</xsl:attribute>
																		</xsl:if>
																	</xsl:if>
																	<td>
																		<xsl:value-of select="@Text"/>
																	</td>
																	<xsl:if test="$isCompare=1">
																		<td>
																			<xsl:value-of select="@Baseline_Text"/>
																		</td>
																		<xsl:if test="./Defect">
																			<td>
	
																				<a>
																					<xsl:attribute name="id">
																						<xsl:text>def</xsl:text>
																						<xsl:number value="count(preceding::Defect)"/>
																					</xsl:attribute>
																					<xsl:attribute name="name">
																						<xsl:text>defect</xsl:text>
																						<xsl:value-of select="./Defect/@id"/>
																					</xsl:attribute>
	
																					<xsl:for-each select="Defect">
																						<xsl:value-of select="@id"/>
																						<xsl:text>(</xsl:text>
																						<xsl:value-of select="@name"/>
																						<xsl:text>)</xsl:text>
																						<br/>
																					</xsl:for-each>
	
																					<xsl:call-template name="defectButtons">
																						<xsl:with-param name="defectnumber" select="count(preceding::Defect)"/>
																					</xsl:call-template>
																					<input value="x" type="button">
																						<xsl:attribute name="onclick">
																							<xsl:text>hidingDefectFromDefects('</xsl:text>
																							<xsl:value-of select="./Defect/@id"/>
																							<xsl:text>');</xsl:text>
																						</xsl:attribute>
																					</input>
																				</a>
																			</td>
																		</xsl:if>
																	</xsl:if>
																</tr>
															</xsl:for-each>
														</tbody>
													</table>
												</div>
											</xsl:if>
										</xsl:for-each>
	
										<xsl:for-each select="Script/Version[(@mode=$versionMode) or (@Baseline_mode=$versionMode)]/RunLog/Testcase[starts-with(@Text,'Globus message')]">
											<div class="glomes" name="glomes">
												<xsl:attribute name="id">
													<xsl:text>glomes</xsl:text>
													<xsl:value-of select="$menuId"/>
												</xsl:attribute>
												<table width="100%" border="2">
													<thead>
														<tr>
															<th colspan="2" align="center">
																<xsl:text>GLOBUS message(s)</xsl:text>
															</th>
														</tr>
														<xsl:if test="$isCompare=1">
															<tr>
																<th>Value</th>
																<th>Baseline value</th>
															</tr>
														</xsl:if>
													</thead>
													<tbody>
														<tr>
															<xsl:if test="$isCompare=1">
																<xsl:if test="contains(@TestManager_DiffType,'Changed')">
																	<xsl:attribute name="class">changed</xsl:attribute>
																</xsl:if>
																<xsl:if test="contains(@TestManager_DiffType,'Added')">
																	<xsl:attribute name="class">added</xsl:attribute>
																</xsl:if>
																<xsl:if test="contains(@TestManager_DiffType,'Removed')">
																	<xsl:attribute name="class">removed</xsl:attribute>
																</xsl:if>
															</xsl:if>
															<td>
																<xsl:value-of select="@Text"/>
															</td>
															<xsl:if test="$isCompare=1">
																<td>
																	<xsl:value-of select="@Baseline_Text"/>
																</td>
																<xsl:if test="./Defect">
																	<td>
																		<a>
																			<xsl:attribute name="id">
																				<xsl:text>def</xsl:text>
																				<xsl:number value="count(preceding::Defect)"/>
																			</xsl:attribute>
																			<xsl:attribute name="name">
																				<xsl:text>defect</xsl:text>
																				<xsl:value-of select="./Defect/@id"/>
																			</xsl:attribute>
	
																			<xsl:for-each select="Defect">
																				<xsl:value-of select="@id"/>
																				<xsl:text>(</xsl:text>
																				<xsl:value-of select="@name"/>
																				<xsl:text>)</xsl:text>
																				<br/>
																			</xsl:for-each>
	
																			<xsl:call-template name="defectButtons">
																				<xsl:with-param name="defectnumber" select="count(preceding::Defect)"/>
																			</xsl:call-template>
																			<input value="x" type="button">
																				<xsl:attribute name="onclick">
																					<xsl:text>hidingDefectFromDefects('</xsl:text>
																					<xsl:value-of select="./Defect/@id"/>
																					<xsl:text>');</xsl:text>
																				</xsl:attribute>
																			</input>
																		</a>
																	</td>
																</xsl:if>
															</xsl:if>
														</tr>
													</tbody>
												</table>
											</div>
										</xsl:for-each>
	
										<xsl:for-each select=".//Testcase[starts-with(@Text,'TXN COMPLETE')]">
											<div class="txncom" name="txncom">
												<xsl:attribute name="id">
													<xsl:text>txncom</xsl:text>
													<xsl:value-of select="$menuId"/>
												</xsl:attribute>
												<table width="100%" border="2">
													<thead>
														<tr>
															<th colspan="2" align="center">
																<xsl:text>TXN COMPLETE</xsl:text>
															</th>
														</tr>
														<xsl:if test="$isCompare=1">
															<tr>
																<th>Value</th>
																<th>Baseline value</th>
															</tr>
														</xsl:if>
													</thead>
													<tbody>
														<tr>
															<xsl:if test="$isCompare=1">
																<xsl:if test="contains(@TestManager_DiffType,'Changed')">
																	<xsl:attribute name="class">changed</xsl:attribute>
																</xsl:if>
																<xsl:if test="contains(@TestManager_DiffType,'Added')">
																	<xsl:attribute name="class">added</xsl:attribute>
																</xsl:if>
																<xsl:if test="contains(@TestManager_DiffType,'Removed')">
																	<xsl:attribute name="class">removed</xsl:attribute>
																</xsl:if>
															</xsl:if>
															<td>
																<xsl:value-of select="@Text"/>
															</td>
															<xsl:if test="$isCompare=1">
																<td>
																	<xsl:value-of select="@Baseline_Text"/>
																</td>
																<xsl:if test="./Defect">
																	<td>
	
																		<a>
																			<xsl:attribute name="id">
																				<xsl:text>def</xsl:text>
																				<xsl:number value="count(preceding::Defect)"/>
																			</xsl:attribute>
																			<xsl:attribute name="name">
																				<xsl:text>defect</xsl:text>
																				<xsl:value-of select="./Defect/@id"/>
																			</xsl:attribute>
	
																			<xsl:for-each select="Defect">
																				<xsl:value-of select="@id"/>
																				<xsl:text>(</xsl:text>
																				<xsl:value-of select="@name"/>
																				<xsl:text>)</xsl:text>
																				<br/>
																			</xsl:for-each>
	
																			<xsl:call-template name="defectButtons">
																				<xsl:with-param name="defectnumber" select="count(preceding::Defect)"/>
																			</xsl:call-template>
																			<input value="x" type="button">
																				<xsl:attribute name="onclick">
																					<xsl:text>hidingDefectFromDefects('</xsl:text>
																					<xsl:value-of select="./Defect/@id"/>
																					<xsl:text>');</xsl:text>
																				</xsl:attribute>
																			</input>
																		</a>
																	</td>
																</xsl:if>
															</xsl:if>
														</tr>
													</tbody>
												</table>
											</div>
										</xsl:for-each>
									</div>
	
									<xsl:if test="Script/Version[(@mode=$versionMode) or (@Baseline_mode=$versionMode)]/*[contains(name(),'VersionFields')]/descendant::*[@value!='' or @Baseline_value!='']">
										<xsl:if test=".//Testcase[starts-with(@Text,'Commit') and contains(@Text, 'fail')]">
											<div class="sbc" name="sbc">
												<xsl:attribute name="id">
													<xsl:text>sbc</xsl:text>
													<xsl:value-of select="$menuId"/>
												</xsl:attribute>
												<h3>
													<xsl:text>Snapshot of non-empty fields before commit</xsl:text>
												</h3>
	
												<xsl:apply-templates select=".//RECEIVED[contains(@Command, '-FillVersion') and position()=last()]" mode="version">
													<xsl:with-param name="postfix" select="$versionMode"/>
												</xsl:apply-templates>
											</div>
										</xsl:if>
									</xsl:if>
	
								</xsl:for-each>
							</xsl:when>
	
							<xsl:otherwise>
								<xsl:for-each select="../../../Outputs">
									<div class="sfv" name="sfv">
										<xsl:attribute name="id">
											<xsl:text>sfv</xsl:text>
											<xsl:value-of select="$menuId"/>
										</xsl:attribute>
										<xsl:for-each select=".//Testcase[starts-with(@Text,'Commit')]">
											<!--Error text messages in the VersionFileds -->
											<xsl:if test="../../../*[contains(name(),'VersionFields')]//*[@errorText!='']">
												<div class="em" name="em">
													<xsl:attribute name="id">
														<xsl:text>em</xsl:text>
														<xsl:value-of select="$menuId"/>
													</xsl:attribute>
													<table width="100%" border="2">
														<thead>
															<tr>
																<th colspan="3" align="center">
																	<strong>Error message(s)</strong>
																</th>
															</tr>
	
															<tr>
																<th>Field name</th>
																<th>Value</th>
																<xsl:if test="$isCompare=1">
																	<th>Baseline value</th>
																</xsl:if>
															</tr>
														</thead>
														<tbody>
															<xsl:for-each select="../../../*[contains(name(),'VersionFields')]//*[@errorText!='']">
																<tr>
																	<xsl:if test="$isCompare=1">
																		<xsl:if test="contains(@TestManager_DiffType,'Changed')">
																			<xsl:attribute name="class">changed</xsl:attribute>
																		</xsl:if>
																		<xsl:if test="contains(@TestManager_DiffType,'Added')">
																			<xsl:attribute name="class">added</xsl:attribute>
																		</xsl:if>
																		<xsl:if test="contains(@TestManager_DiffType,'Removed')">
																			<xsl:attribute name="class">removed</xsl:attribute>
																		</xsl:if>
																	</xsl:if>
																	<td>
																		<xsl:text>(</xsl:text>
																		<xsl:choose>
																			<xsl:when test="@fieldNumber1!=''">
																				<xsl:value-of select="@fieldNumber1"/>
																			</xsl:when>
																			<xsl:otherwise>
																				<xsl:value-of select="@Baseline_fieldNumber1"/>
																			</xsl:otherwise>
																		</xsl:choose>
																		<xsl:for-each select="ancestor::Value">
																			<xsl:text>.</xsl:text>
																			<xsl:choose>
																				<xsl:when test="@number!=''">
																					<xsl:value-of select="@number"/>
																				</xsl:when>
																				<xsl:otherwise>
																					<xsl:value-of select="@Baseline_number"/>
																				</xsl:otherwise>
																			</xsl:choose>
																		</xsl:for-each>
																		<xsl:text>) </xsl:text>
																		<xsl:value-of select="name()"/>
																	</td>
																	<td>
																		<xsl:value-of select="@errorText"/>
																	</td>
																	<xsl:if test="$isCompare=1">
																		<td>
																			<xsl:value-of select="@Baseline_errorText"/>
																		</td>
																		<xsl:if test="./Defect">
																			<td>
	
																				<a>
																					<xsl:attribute name="id">
																						<xsl:text>def</xsl:text>
																						<xsl:number value="count(preceding::Defect)"/>
																					</xsl:attribute>
																					<xsl:attribute name="name">
																						<xsl:text>defect</xsl:text>
																						<xsl:value-of select="./Defect/@id"/>
																					</xsl:attribute>
	
																					<xsl:for-each select="Defect">
																						<xsl:value-of select="@id"/>
																						<xsl:text>(</xsl:text>
																						<xsl:value-of select="@name"/>
																						<xsl:text>)</xsl:text>
																						<br/>
																					</xsl:for-each>
	
																					<xsl:call-template name="defectButtons">
																						<xsl:with-param name="defectnumber" select="count(preceding::Defect)"/>
																					</xsl:call-template>
																					<input value="x" type="button">
																						<xsl:attribute name="onclick">
																							<xsl:text>hidingDefectFromDefects('</xsl:text>
																							<xsl:value-of select="./Defect/@id"/>
																							<xsl:text>');</xsl:text>
																						</xsl:attribute>
																					</input>
																				</a>
																			</td>
																		</xsl:if>
																	</xsl:if>
																</tr>
															</xsl:for-each>
														</tbody>
													</table>
												</div>
											</xsl:if>
	
											<xsl:if test="preceding-sibling::*[starts-with(@Text,'Error message')]">
												<div class="erdc" name="erdc">
													<xsl:attribute name="id">
														<xsl:text>erdc</xsl:text>
														<xsl:value-of select="$menuId"/>
													</xsl:attribute>
													<table width="100%" border="2">
														<thead>
															<tr>
																<th colspan="2" align="center">
																	<xsl:text>Error reason(s) during commit</xsl:text>
																</th>
															</tr>
															<xsl:if test="$isCompare=1">
																<tr>
																	<th>Value</th>
																	<th>Baseline value</th>
																</tr>
															</xsl:if>
														</thead>
														<tbody>
															<xsl:for-each select="preceding-sibling::*[starts-with(@Text,'Error message')]">
																<tr>
																	<xsl:if test="$isCompare=1">
																		<xsl:if test="contains(@TestManager_DiffType,'Changed')">
																			<xsl:attribute name="class">changed</xsl:attribute>
																		</xsl:if>
																		<xsl:if test="contains(@TestManager_DiffType,'Added')">
																			<xsl:attribute name="class">added</xsl:attribute>
																		</xsl:if>
																		<xsl:if test="contains(@TestManager_DiffType,'Removed')">
																			<xsl:attribute name="class">removed</xsl:attribute>
																		</xsl:if>
																	</xsl:if>
																	<td>
																		<xsl:value-of select="@Text"/>
																	</td>
																	<xsl:if test="$isCompare=1">
																		<td>
																			<xsl:value-of select="@Baseline_Text"/>
																		</td>
																		<xsl:if test="./Defect">
																			<td>
	
																				<a>
																					<xsl:attribute name="id">
																						<xsl:text>def</xsl:text>
																						<xsl:number value="count(preceding::Defect)"/>
																					</xsl:attribute>
																					<xsl:attribute name="name">
																						<xsl:text>defect</xsl:text>
																						<xsl:value-of select="./Defect/@id"/>
																					</xsl:attribute>
	
																					<xsl:for-each select="Defect">
																						<xsl:value-of select="@id"/>
																						<xsl:text>(</xsl:text>
																						<xsl:value-of select="@name"/>
																						<xsl:text>)</xsl:text>
																						<br/>
																					</xsl:for-each>
	
																					<xsl:call-template name="defectButtons">
																						<xsl:with-param name="defectnumber" select="count(preceding::Defect)"/>
																					</xsl:call-template>
																					<input value="x" type="button">
																						<xsl:attribute name="onclick">
																							<xsl:text>hidingDefectFromDefects('</xsl:text>
																							<xsl:value-of select="./Defect/@id"/>
																							<xsl:text>');</xsl:text>
																						</xsl:attribute>
																					</input>
																				</a>
																			</td>
																		</xsl:if>
																	</xsl:if>
																</tr>
															</xsl:for-each>
														</tbody>
													</table>
												</div>
											</xsl:if>
										</xsl:for-each>
	
										<xsl:for-each select="Script/Version[(@mode=ancestor::Sequence/Inputs/InputMessage/FieldValues/@Mode) or (@Baseline_mode=ancestor::Sequence/Inputs/InputMessage/FieldValues/@Baseline_Mode)]/RunLog/Testcase[starts-with(@Text,'Globus message')]">
											<div class="glomes" name="glomes">
												<xsl:attribute name="id">
													<xsl:text>glomes</xsl:text>
													<xsl:value-of select="$menuId"/>
												</xsl:attribute>
												<table width="100%" border="2">
													<thead>
														<tr>
															<th colspan="2" align="center">
																<xsl:text>GLOBUS message(s)</xsl:text>
															</th>
														</tr>
														<xsl:if test="$isCompare=1">
															<tr>
																<th>Value</th>
																<th>Baseline value</th>
															</tr>
														</xsl:if>
													</thead>
													<tbody>
														<tr>
															<xsl:if test="$isCompare=1">
																<xsl:if test="contains(@TestManager_DiffType,'Changed')">
																	<xsl:attribute name="class">changed</xsl:attribute>
																</xsl:if>
	
																<xsl:if test="contains(@TestManager_DiffType,'Added')">
																	<xsl:attribute name="class">added</xsl:attribute>
																</xsl:if>
																<xsl:if test="contains(@TestManager_DiffType,'Removed')">
																	<xsl:attribute name="class">removed</xsl:attribute>
																</xsl:if>
															</xsl:if>
															<td>
																<xsl:value-of select="@Text"/>
															</td>
															<xsl:if test="$isCompare=1">
																<td>
																	<xsl:value-of select="@Baseline_Text"/>
																</td>
																<xsl:if test="./Defect">
																	<td>
	
																		<a>
																			<xsl:attribute name="id">
																				<xsl:text>def</xsl:text>
																				<xsl:number value="count(preceding::Defect)"/>
																			</xsl:attribute>
																			<xsl:attribute name="name">
																				<xsl:text>defect</xsl:text>
																				<xsl:value-of select="./Defect/@id"/>
																			</xsl:attribute>
	
																			<xsl:for-each select="Defect">
																				<xsl:value-of select="@id"/>
																				<xsl:text>(</xsl:text>
																				<xsl:value-of select="@name"/>
																				<xsl:text>)</xsl:text>
																				<br/>
																			</xsl:for-each>
	
																			<xsl:call-template name="defectButtons">
																				<xsl:with-param name="defectnumber" select="count(preceding::Defect)"/>
																			</xsl:call-template>
																			<input value="x" type="button">
																				<xsl:attribute name="onclick">
																					<xsl:text>hidingDefectFromDefects('</xsl:text>
																					<xsl:value-of select="./Defect/@id"/>
																					<xsl:text>');</xsl:text>
																				</xsl:attribute>
																			</input>
																		</a>
																	</td>
																</xsl:if>
															</xsl:if>
														</tr>
													</tbody>
												</table>
											</div>
										</xsl:for-each>
	
										<xsl:for-each select=".//Testcase[starts-with(@Text,'TXN COMPLETE')]">
											<div class="txncom" name="txncom">
	
												<xsl:attribute name="id">
													<xsl:text>txncom</xsl:text>
													<xsl:value-of select="$menuId"/>
												</xsl:attribute>
												<table width="100%" border="2">
													<thead>
														<tr>
															<th colspan="2" align="center">
																<xsl:text>TXN COMPLETE</xsl:text>
															</th>
														</tr>
														<xsl:if test="$isCompare=1">
															<tr>
																<th>Value</th>
																<th>Baseline value</th>
															</tr>
														</xsl:if>
													</thead>
													<tbody>
														<tr>
															<xsl:if test="$isCompare=1">
																<xsl:if test="contains(@TestManager_DiffType,'Changed')">
																	<xsl:attribute name="class">changed</xsl:attribute>
																</xsl:if>
																<xsl:if test="contains(@TestManager_DiffType,'Added')">
																	<xsl:attribute name="class">added</xsl:attribute>
																</xsl:if>
																<xsl:if test="contains(@TestManager_DiffType,'Removed')">
																	<xsl:attribute name="class">removed</xsl:attribute>
																</xsl:if>
															</xsl:if>
															<td>
																<xsl:value-of select="@Text"/>
															</td>
															<xsl:if test="$isCompare=1">
																<td>
																	<xsl:value-of select="@Baseline_Text"/>
																</td>
																<xsl:if test="./Defect">
																	<td>
	
																		<a>
																			<xsl:attribute name="id">
																				<xsl:text>def</xsl:text>
																				<xsl:number value="count(preceding::Defect)"/>
																			</xsl:attribute>
																			<xsl:attribute name="name">
																				<xsl:text>defect</xsl:text>
																				<xsl:value-of select="./Defect/@id"/>
																			</xsl:attribute>
	
																			<xsl:for-each select="Defect">
																				<xsl:value-of select="@id"/>
																				<xsl:text>(</xsl:text>
																				<xsl:value-of select="@name"/>
																				<xsl:text>)</xsl:text>
																				<br/>
																			</xsl:for-each>
	
																			<xsl:call-template name="defectButtons">
																				<xsl:with-param name="defectnumber" select="count(preceding::Defect)"/>
																			</xsl:call-template>
																			<input value="x" type="button">
																				<xsl:attribute name="onclick">
																					<xsl:text>hidingDefectFromDefects('</xsl:text>
																					<xsl:value-of select="./Defect/@id"/>
																					<xsl:text>');</xsl:text>
																				</xsl:attribute>
																			</input>
																		</a>
																	</td>
																</xsl:if>
															</xsl:if>
														</tr>
													</tbody>
												</table>
											</div>
										</xsl:for-each>
									</div>
									<xsl:if test="Script/Version[(@mode=ancestor::Sequence/Inputs/InputMessage/FieldValues/@Mode) or (@Baseline_mode=ancestor::Sequence/Inputs/InputMessage/FieldValues/@Baseline_Mode)]/*[contains(name(),'VersionFields')]/descendant::*[@value!='' or @Baseline_value!='']">
										<xsl:if test=".//Testcase[starts-with(@Text,'Commit') and contains(@Text, 'fail')]">
											<div class="sbc" name="sbc">
												<xsl:attribute name="id">
													<xsl:text>sbc</xsl:text>
													<xsl:value-of select="$menuId"/>
												</xsl:attribute>
												<xsl:call-template name="checkInput"/>
												<h3>
													<xsl:text>Snapshot of non-empty fields before commit</xsl:text>
												</h3>
												<xsl:apply-templates select=".//RECEIVED[contains(@Command, '-FillVersion') and position()=last()]" mode="version">
													<xsl:with-param name="postfix" select="$versionMode"/>
												</xsl:apply-templates>
											</div>
										</xsl:if>
									</xsl:if>
	
									<xsl:apply-templates select=".." mode="fieldValues">
										<xsl:with-param name="seqNo" select="$seqNo" />
									</xsl:apply-templates>
								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</div>
				<a href="#main">
					<span style="text-align: right">Top</span>
				</a>
				<hr/>
			</xsl:for-each>
		</xsl:if>

		<xsl:if test=".//EnquiryData">
			<xsl:for-each select="./Inputs/InputMessage/EnquiryData">
				<xsl:variable name="menuId">
					<xsl:value-of select="generate-id(.)"/>
				</xsl:variable>

				<xsl:variable name="resultSelection">
					<xsl:if test="@resultSelection or @Baseline_resultSelection">
						<xsl:choose>
							<xsl:when test="@resultSelection!=''">
								<xsl:value-of select="@resultSelection"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="@Baseline_resultSelection"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				</xsl:variable>

				<xsl:variable name="expectedSecondLevel" select="string(./ExpectedOutput[child::Field]/@expectedResult)"/>

				<div style="white-space:normal; margin-left:0px">
					<xsl:attribute name="onmouseover">
						<xsl:text>menuInJump('menu</xsl:text>
						<xsl:value-of select="$menuId"/>
						<xsl:text>');</xsl:text>
					</xsl:attribute>
					<xsl:attribute name="ondblclick">
						<xsl:text>bookmarkSequence('menu</xsl:text>
						<xsl:value-of select="$menuId"/>
						<xsl:text>');</xsl:text>
					</xsl:attribute>

					<xsl:variable name="tagging">
						<xsl:if test="@usergroup or @Baseline_usergroup">
							<xsl:text> with </xsl:text>
							<xsl:choose>
								<xsl:when test="@usergroup!=''">
									<xsl:value-of select="@usergroup"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="@Baseline_usergroup"/>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:text> user</xsl:text>
						</xsl:if>
						<xsl:if test="$resultSelection!=''">
							<xsl:text>, result selection is '</xsl:text>
							<xsl:value-of select="$resultSelection"/>
							<xsl:text>'</xsl:text>
						</xsl:if>
						<xsl:choose>
							<xsl:when test="$expectedSecondLevel!=''">
								<xsl:text>, second level selection is '</xsl:text>
								<xsl:value-of select="$expectedSecondLevel"/>
								<xsl:text>'</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>, without second level selection</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<a>
						<xsl:attribute name="id">
							<xsl:value-of select="$menuId"/>
						</xsl:attribute>

						<xsl:call-template name="tcHead">
							<xsl:with-param name="action">
								<xsl:value-of select="'Enquiry of '"/>
							</xsl:with-param>
							<xsl:with-param name="tagging">
								<xsl:value-of select="$tagging"/>
							</xsl:with-param>
							<xsl:with-param name="day">
								<xsl:value-of select="$day"/>
							</xsl:with-param>
							<xsl:with-param name="name">
								<xsl:value-of select="$comment" disable-output-escaping="yes"/>
							</xsl:with-param>
							<xsl:with-param name="subject">
								<xsl:choose>
									<xsl:when test="@name!=''">
										<xsl:value-of select="@name"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="@Baseline_name"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:with-param>
							<xsl:with-param name="seqNo">
								<xsl:value-of select="$seqNo"/>
							</xsl:with-param>
							<xsl:with-param name="tcNo">
								<xsl:value-of select="$tcNo"/>
							</xsl:with-param>
							<xsl:with-param name="type">
								<xsl:value-of select="$type"/>
							</xsl:with-param>
						</xsl:call-template>
					</a>
				</div>

				<!-- ENQ Snaphot Decisions -->
<!--			<xsl:variable name="oldSnapshotCondition">
					<xsl:value-of select="($resultSelection='All' or $resultSelection='Selected only') and $expectedSecondLevel='' "/>
				</xsl:variable>

				<xsl:variable name="numOfColumns">
					<xsl:value-of select="count(ancestor::Sequence/Outputs/Script/SelectionResult/Row[1]/Field[not(@Row)])"/>
				</xsl:variable>



				<xsl:variable name="text_simple" select="ancestor::Sequence/Outputs/Script//RECEIVED[contains(@Command,'-ExecuteEnquiry')]/@Text"/>

				<xsl:variable name="text_zip" select="ancestor::Sequence/Outputs/Script//RECEIVED[contains(@Command,'-ExecuteEnquiry')]/@Text.zip"/>

				<xsl:variable name="text_plain">
					<xsl:choose>
						<xsl:when test="$text_simple">
							<xsl:value-of select="$text_simple"/>
						</xsl:when>
						<xsl:when test="$text_zip">
							<xsl:call-template name="unzip">
								<xsl:with-param name="text.zip" select="$text_zip"/>
							</xsl:call-template>
						</xsl:when>
					</xsl:choose>
				</xsl:variable>

				-->
				<!-- snapshot contains <table class="enqheader"> -->
				<!-- 
				<xsl:variable name="hasHeader" select="contains($text_plain, 'table class=&quot;enqheader&quot;&gt;&#xA;&lt;tr&gt;')"/>

				<xsl:variable name="showTabular" select="($numOfColumns &gt; 10) and not($hasHeader)"/>
				-->
				<!--
				<div> numOfColumns : <xsl:value-of select="$numOfColumns" /> hasHeader 
					: <xsl:value-of select="$hasHeader" /> showTabular : <xsl:value-of select="$showTabular" 
					/> </div>
					-->

				<!--
				<xsl:choose>
					<xsl:when test="$showTabular">
						<xsl:call-template name="createEnqResultTable"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="createEnqResultSnapshot"/>
					</xsl:otherwise>
				</xsl:choose>
				-->

				<xsl:choose>
					<xsl:when test="$resultSelection='All' and $expectedSecondLevel=''">
						<xsl:call-template name="createEnqResultSnapshot"/>
					</xsl:when>
					<xsl:when test="$resultSelection='Selected only' and $expectedSecondLevel=''">
						<xsl:call-template name="createEnqResultSnapshot"/>
					</xsl:when>
					<xsl:when test="($resultSelection='Selected only' or $resultSelection='All') and $expectedSecondLevel!=''">
						<xsl:call-template name="createEnqResultTable"/>
						<xsl:call-template name="createEnqResultSnapshot"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="createEnqResultTable"/>
					</xsl:otherwise>
				</xsl:choose>
				
				<!--
				<xsl:call-template name="createEnqResultTable"/>
				-->
				<hr/>
			</xsl:for-each>
		</xsl:if>

		<xsl:if test=".//FieldValues[@Interface or @Baseline_Interface]">

			<xsl:for-each select="./Inputs/InputMessage">
				<xsl:variable name="menuId">
					<xsl:value-of select="generate-id(./FieldValues)"/>
				</xsl:variable>

				<xsl:variable name="itIdInterface">
					<xsl:choose>
						<xsl:when test="./@iteration!=''">
							<xsl:value-of select="./@iteration"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="./@Baseline_iteration"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<div style="margin-left:0px">
					<xsl:attribute name="onmouseover">
						<xsl:text>menuInJump('menu</xsl:text>
						<xsl:value-of select="$menuId"/>
						<xsl:text>');</xsl:text>
					</xsl:attribute>
					<xsl:attribute name="ondblclick">
						<xsl:text>bookmarkSequence('menu</xsl:text>
						<xsl:value-of select="$menuId"/>
						<xsl:text>');</xsl:text>
					</xsl:attribute>
					<a>
						<xsl:attribute name="id">
							<xsl:value-of select="$menuId"/>
						</xsl:attribute>
					</a>

					<h2>
						<xsl:value-of select="$seqNo"/>
						<xsl:text>: </xsl:text>
						<xsl:choose>
							<xsl:when test="./FieldValues/@version!=''">
								<xsl:value-of select="./FieldValues/@version"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="./FieldValues/@Baseline_version"/>
							</xsl:otherwise>
						</xsl:choose>

						<xsl:if test=".//FieldValues[@Interface='I' or @Baseline_Interface='I']">
							<xsl:text> in-coming interface message</xsl:text>
						</xsl:if>

						<xsl:if test="./FieldValues/@Interface='O' or ./FieldValues/@Baseline_Interface='O'">
							<xsl:text> out-going interface message</xsl:text>
						</xsl:if>
					</h2>

					<div class="im" name="im">
						<xsl:attribute name="id">
							<xsl:text>im</xsl:text>
							<xsl:value-of select="generate-id(.)"/>
						</xsl:attribute>
						<xsl:if test=".//FieldValues[@Interface='I' or @Baseline_Interface='I']">
							<xsl:apply-templates select=".//FieldValues" mode="Interface"/>
						</xsl:if>

						<xsl:if test=".//FieldValues[@Interface='O' or @Baseline_Interface='O']">
							<xsl:for-each select="../../Outputs">
								<!--If the Interface is not iteration -->
								<xsl:choose>
									<xsl:when test="not(.//Iteration)">
										<xsl:for-each select=".//Message[not(./Message)]">
											<xsl:apply-templates select="."/>
										</xsl:for-each>
									</xsl:when>

									<!--If the Interface is iteration! -->
									<xsl:otherwise>
										<xsl:for-each select=".//Iteration[@number=$itIdInterface or @Baseline_number=$itIdInterface]">
											<xsl:apply-templates select=".//Message[not(./Message)]"/>
										</xsl:for-each>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
						</xsl:if>
					</div>
				</div>
				<a href="#main">
					<span style="text-align: right">Top</span>
				</a>
				<hr/>
			</xsl:for-each>
		</xsl:if>

		<xsl:if test=".//REPORT">
			<xsl:for-each select=".//Outputs[Script/REPORT]">
				<xsl:variable name="menuId">
					<xsl:value-of select="generate-id(.)"/>
				</xsl:variable>

				<div style="margin-left:0px">
					<xsl:attribute name="onmouseover">
						<xsl:text>menuInJump('menu</xsl:text>
						<xsl:value-of select="$menuId"/>
						<xsl:text>');</xsl:text>
					</xsl:attribute>
					<xsl:attribute name="ondblclick">
						<xsl:text>bookmarkSequence('menu</xsl:text>
						<xsl:value-of select="$menuId"/>
						<xsl:text>');</xsl:text>
					</xsl:attribute>
					<a>
						<xsl:attribute name="id">
							<xsl:value-of select="$menuId"/>
						</xsl:attribute>
					</a>

					<h2>
						<xsl:value-of select="$seqNo"/>
						<xsl:text>: Report:</xsl:text>
					</h2>

					<div class="rep" name="rep">
						<xsl:attribute name="id">
							<xsl:text>rep</xsl:text>
							<xsl:value-of select="generate-id(.)"/>
						</xsl:attribute>
						<table width="100%" border="2">
							<thead>
								<tr>
									<th colspan="2">REPORT(S)</th>
								</tr>
								<xsl:if test="$isCompare=1">
									<tr>
										<th>Value</th>
										<th>Baseline value</th>
									</tr>
								</xsl:if>
							</thead>
							<tbody>
								<xsl:for-each select=".//REPORT">
									<tr>
										<xsl:if test="$isCompare=1">
											<xsl:if test="contains(@TestManager_DiffType,'Changed')">
												<xsl:attribute name="class">changed</xsl:attribute>
											</xsl:if>
											<xsl:if test="contains(@TestManager_DiffType,'Added')">
												<xsl:attribute name="class">added</xsl:attribute>
											</xsl:if>
											<xsl:if test="contains(@TestManager_DiffType,'Removed')">
												<xsl:attribute name="class">removed</xsl:attribute>
											</xsl:if>
										</xsl:if>
										<td>
											<pre>
												<xsl:value-of select="@Text" disable-output-escaping="yes"/>
											</pre>
										</td>
										<xsl:if test="$isCompare=1">
											<td>
												<pre>
													<xsl:value-of select="@Baseline_Text" disable-output-escaping="yes"/>
												</pre>
											</td>
											<xsl:if test="./Defect">
												<td>

													<a>
														<xsl:attribute name="id">
															<xsl:text>def</xsl:text>
															<xsl:number value="count(preceding::Defect)"/>
														</xsl:attribute>
														<xsl:attribute name="name">
															<xsl:text>defect</xsl:text>
															<xsl:value-of select="./Defect/@id"/>
														</xsl:attribute>

														<xsl:for-each select="Defect">
															<xsl:value-of select="@id"/>
															<xsl:text>(</xsl:text>
															<xsl:value-of select="@name"/>
															<xsl:text>)</xsl:text>
															<br/>
														</xsl:for-each>

														<xsl:call-template name="defectButtons">
															<xsl:with-param name="defectnumber" select="count(preceding::Defect)"/>
														</xsl:call-template>
														<input value="x" type="button">
															<xsl:attribute name="onclick">
																<xsl:text>hidingDefectFromDefects('</xsl:text>
																<xsl:value-of select="./Defect/@id"/>
																<xsl:text>');</xsl:text>
															</xsl:attribute>
														</input>
													</a>
												</td>
											</xsl:if>
										</xsl:if>
									</tr>
								</xsl:for-each>
							</tbody>
						</table>
					</div>
				</div>
				<a href="#main">
					<span style="text-align: right">Top</span>
				</a>
				<hr/>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>

	<xsl:template match="FieldValues" mode="RunLog">
		<table width="100%" border="2">
			<thead>
				<tr>
					<th colspan="5" align="center">
						<xsl:text>Field value setting(s)</xsl:text>
					</th>
				</tr>
				<tr>
					<th>Field name</th>
					<th>Value</th>
					<th>Expected value</th>
					<xsl:if test="$isCompare=1">
						<th>Baseline value</th>
						<th>Baseline expected value</th>
					</xsl:if>
				</tr>
			</thead>
			<tbody>
				<xsl:apply-templates select="./*" mode="FieldValues"/>
			</tbody>
		</table>
	</xsl:template>

	<xsl:template match="*" mode="FieldValues">
		<xsl:choose>
			<xsl:when test="@subVersion='true'">
				<xsl:for-each select="./*">
					<xsl:apply-templates select="." mode="FieldValues"/>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="@multivalue='yes' or @Baseline_multivalue='yes'">
				<xsl:for-each select="./item">
					<xsl:apply-templates mode="FieldValues"/>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<tr>
					<td>
						<xsl:if test="ancestor::FieldValues[@subVersion='true']">
							<xsl:text> (</xsl:text>
							<xsl:value-of select="ancestor::FieldValues[@subVersion='true']/@version"/>
							<xsl:text>) </xsl:text>
						</xsl:if>
						<xsl:value-of select="name()"/>
					</td>
					<td>
						<xsl:value-of select="@Value"/>
					</td>
					<td>
						<xsl:value-of select="@Expected"/>
					</td>
					<xsl:if test="$isCompare=1">
						<td>
							<xsl:value-of select="@Baseline_Value"/>
						</td>
						<td>
							<xsl:value-of select="@Baseline_Expected"/>
						</td>
					</xsl:if>
				</tr>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*[@Baseline_value!='' or @value!='']" mode="VersionFields">
		<xsl:choose>
			<xsl:when test="@multivalue='yes' or @Baseline_multivalue='yes'">
				<xsl:for-each select="./Value">
					<xsl:apply-templates mode="VersionFields"/>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<tr>
					<xsl:if test="$isCompare=1">
						<xsl:if test="contains(@TestManager_DiffType,'Changed')">
							<xsl:attribute name="class">changed</xsl:attribute>
						</xsl:if>
						<xsl:if test="contains(@TestManager_DiffType,'Added')">
							<xsl:attribute name="class">added</xsl:attribute>
						</xsl:if>
						<xsl:if test="contains(@TestManager_DiffType,'Removed')">
							<xsl:attribute name="class">removed</xsl:attribute>
						</xsl:if>
					</xsl:if>
					<td>
						<xsl:text>(</xsl:text>
						<xsl:choose>
							<xsl:when test="@fieldNumber1!=''">
								<xsl:value-of select="@fieldNumber1"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="@Baseline_fieldNumber1"/>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:for-each select="ancestor::Value">
							<xsl:text>.</xsl:text>
							<xsl:choose>
								<xsl:when test="@number!=''">
									<xsl:value-of select="@number"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="@Baseline_number"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
						<xsl:text>) </xsl:text>
						<xsl:value-of select="name()"/>
					</td>
					<xsl:if test="not(contains(@TestManager_DiffType,'Changed'))">
						<td>
							<xsl:choose>
								<xsl:when test="@desc1!=''">
									<xsl:choose>
										<xsl:when test="@value=@desc1">
											<xsl:value-of select="@desc1"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="@desc1"/>
											<xsl:text> ('</xsl:text>
											<xsl:value-of select="@value"/>
											<xsl:text>')</xsl:text>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:otherwise>
									<xsl:choose>
										<xsl:when test="@value=@desc1">
											<xsl:text>''</xsl:text>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="@desc1"/>
											<xsl:text> ('</xsl:text>
											<xsl:value-of select="@value"/>
											<xsl:text>')</xsl:text>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:otherwise>
							</xsl:choose>
						</td>
						<xsl:if test="$isCompare=1">
							<td>
								<xsl:choose>
									<xsl:when test="@Baseline_desc1!=''">
										<xsl:if test="@Baseline_value=@Baseline_desc1">
											<xsl:value-of select="@Baseline_desc1"/>
										</xsl:if>
										<xsl:if test="@Baseline_value!=@Baseline_desc1">
											<xsl:value-of select="@Baseline_desc1"/>
											<xsl:text> ('</xsl:text>
											<xsl:value-of select="@Baseline_value"/>
											<xsl:text>')</xsl:text>
										</xsl:if>
									</xsl:when>
									<xsl:otherwise>
										<xsl:if test="@Baseline_value=@Baseline_desc1">
											<xsl:text>''</xsl:text>
										</xsl:if>
										<xsl:if test="@Baseline_value!=@Baseline_desc1">
											<xsl:value-of select="@Baseline_desc1"/>
											<xsl:text> ('</xsl:text>
											<xsl:value-of select="@Baseline_value"/>
											<xsl:text>')</xsl:text>
										</xsl:if>
									</xsl:otherwise>
								</xsl:choose>
							</td>
							<xsl:if test="./Defect">
								<td>

									<a>
										<xsl:attribute name="id">
											<xsl:text>def</xsl:text>
											<xsl:number value="count(preceding::Defect)"/>
										</xsl:attribute>
										<xsl:attribute name="name">
											<xsl:text>defect</xsl:text>
											<xsl:value-of select="./Defect/@id"/>
										</xsl:attribute>

										<xsl:for-each select="Defect">
											<xsl:value-of select="@id"/>
											<xsl:text>(</xsl:text>
											<xsl:value-of select="@name"/>
											<xsl:text>)</xsl:text>
											<br/>
										</xsl:for-each>

										<xsl:call-template name="defectButtons">
											<xsl:with-param name="defectnumber" select="count(preceding::Defect)"/>
										</xsl:call-template>
										<input value="x" type="button">
											<xsl:attribute name="onclick">
												<xsl:text>hidingDefectFromDefects('</xsl:text>
												<xsl:value-of select="./Defect/@id"/>
												<xsl:text>');</xsl:text>
											</xsl:attribute>
										</input>
									</a>
								</td>
							</xsl:if>
						</xsl:if>
					</xsl:if>
					<xsl:if test="contains(@TestManager_DiffType,'Changed')">
						<td>
							<xsl:choose>
								<xsl:when test="@desc1!=''">
									<xsl:if test="@value=@desc1">
										<xsl:value-of select="@desc1"/>
									</xsl:if>
									<xsl:if test="@value!=@desc1">
										<xsl:value-of select="@desc1"/>
										<xsl:text> ('</xsl:text>
										<xsl:value-of select="@value"/>
										<xsl:text>')</xsl:text>
									</xsl:if>
								</xsl:when>
								<xsl:otherwise>
									<xsl:if test="@value=@desc1">
										<xsl:text>''</xsl:text>
									</xsl:if>
									<xsl:if test="@value!=@desc1">
										<xsl:value-of select="@desc1"/>
										<xsl:text> ('</xsl:text>
										<xsl:value-of select="@value"/>
										<xsl:text>')</xsl:text>
									</xsl:if>
								</xsl:otherwise>
							</xsl:choose>

							<xsl:if test="@desc2!=@Baseline_desc2">
								<br/>
								<xsl:text>desc2: </xsl:text>
								<xsl:choose>
									<xsl:when test="@desc2=''">
										<xsl:text>''</xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="@desc2"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if>
							<xsl:if test="@errorText!=@Baseline_errorText">
								<br/>
								<xsl:text>errorText: </xsl:text>
								<xsl:choose>
									<xsl:when test="@errorText=''">
										<xsl:text>''</xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="@errorText"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if>
							<xsl:if test="@fieldDescription!=@Baseline_fieldDescription">
								<br/>
								<xsl:text>fieldDescription: </xsl:text>
								<xsl:choose>
									<xsl:when test="@fieldDescription=''">
										<xsl:text>''</xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="@fieldDescription"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if>
						</td>
						<td>
							<xsl:choose>
								<xsl:when test="@Baseline_desc1!=''">
									<xsl:if test="@Baseline_value=@Baseline_desc1">
										<xsl:value-of select="@Baseline_desc1"/>
									</xsl:if>
									<xsl:if test="@Baseline_value!=@Baseline_desc1">
										<xsl:value-of select="@Baseline_desc1"/>
										<xsl:text> ('</xsl:text>
										<xsl:value-of select="@Baseline_value"/>
										<xsl:text>')</xsl:text>
									</xsl:if>
								</xsl:when>
								<xsl:otherwise>
									<xsl:if test="@Baseline_value=@Baseline_desc1">
										<xsl:text>''</xsl:text>
									</xsl:if>
									<xsl:if test="@Baseline_value!=@Baseline_desc1">
										<xsl:value-of select="@Baseline_desc1"/>
										<xsl:text> ('</xsl:text>
										<xsl:value-of select="@Baseline_value"/>
										<xsl:text>')</xsl:text>
									</xsl:if>
								</xsl:otherwise>
							</xsl:choose>

							<xsl:if test="@desc2!=@Baseline_desc2">
								<br/>
								<xsl:text>desc2: </xsl:text>
								<xsl:choose>
									<xsl:when test="@Baseline_desc2=''">
										<xsl:text>''</xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="@Baseline_desc2"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if>
							<xsl:if test="@errorText!=@Baseline_errorText">
								<br/>
								<xsl:text>errorText: </xsl:text>
								<xsl:choose>
									<xsl:when test="@Baseline_errorText=''">
										<xsl:text>''</xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="@Baseline_errorText"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if>
							<xsl:if test="@fieldDescription!=@Baseline_fieldDescription">
								<br/>
								<xsl:text>fieldDescription: </xsl:text>
								<xsl:choose>
									<xsl:when test="@Baseline_fieldDescription=''">
										<xsl:text>''</xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="@Baseline_fieldDescription"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if>
						</td>
						<xsl:if test="./Defect">
							<td>
								<a>
									<xsl:attribute name="id">
										<xsl:text>def</xsl:text>
										<xsl:number value="count(preceding::Defect)"/>
									</xsl:attribute>
									<xsl:attribute name="name">
										<xsl:text>defect</xsl:text>
										<xsl:value-of select="./Defect/@id"/>
									</xsl:attribute>

									<xsl:for-each select="Defect">
										<xsl:value-of select="@id"/>
										<xsl:text>(</xsl:text>
										<xsl:value-of select="@name"/>
										<xsl:text>)</xsl:text>
										<br/>
									</xsl:for-each>

									<xsl:call-template name="defectButtons">
										<xsl:with-param name="defectnumber" select="count(preceding::Defect)"/>
									</xsl:call-template>
									<input value="x" type="button">
										<xsl:attribute name="onclick">
											<xsl:text>hidingDefectFromDefects('</xsl:text>
											<xsl:value-of select="./Defect/@id"/>
											<xsl:text>');</xsl:text>
										</xsl:attribute>
									</input>
								</a>
							</td>
						</xsl:if>
					</xsl:if>
				</tr>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="createEnqResultSnapshot">
		<div class="rs" name="rs">
			<xsl:attribute name="id">
				<xsl:text>rs</xsl:text>
				<xsl:value-of select="generate-id(.)"/>
			</xsl:attribute>

			<xsl:variable name="iter">
				<xsl:choose>
					<xsl:when test="not(ancestor::Sequence/Outputs/Iteration)">
						<xsl:value-of select="''"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="../@iteration"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<h3>Snapshot of Result(s):</h3>

			<xsl:choose>
				<xsl:when test="ancestor::InputMessage/@iteration">
					<xsl:variable name="iteration" select="ancestor::InputMessage/@iteration"/>
					<xsl:variable name="executeEnquiry" select="count(ancestor::Sequence/Outputs/Iteration[(@number=$iteration)]/Script//RECEIVED[contains(@Command,'-ExecuteEnquiry')])"/>
					<xsl:choose>
						<xsl:when test="$executeEnquiry>0">
							<xsl:for-each select="ancestor::Sequence/Outputs/Iteration[(@number=$iteration)]/Script//RECEIVED[contains(@Command,'-ExecuteEnquiry')]">
								<xsl:if test="position() &lt; 11">
									<xsl:apply-templates select="." mode="enquiry">
										<xsl:with-param name="postfix">
											<xsl:text>ENQ</xsl:text>
											<xsl:value-of select="$iter"/>
										</xsl:with-param>
									</xsl:apply-templates>
								</xsl:if>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<xsl:for-each select="ancestor::Sequence/preceding-sibling::Sequence[1]/Outputs/Iteration[(@number=$iteration)]/Script//RECEIVED[contains(@Command,'-ExecuteDrillAction')]">
								<xsl:if test="position() &lt; 11">
									<xsl:apply-templates select="." mode="enquiry">
										<xsl:with-param name="postfix">
											<xsl:text>ENQ</xsl:text>
											<xsl:value-of select="$iter"/>
										</xsl:with-param>
									</xsl:apply-templates>
								</xsl:if>
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
					
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="executeEnquiry" select="count(ancestor::Sequence/Outputs/Script//RECEIVED[contains(@Command,'-ExecuteEnquiry')])"/>
					<xsl:choose>
						<xsl:when test="$executeEnquiry>0">
							<xsl:for-each select="ancestor::Sequence/Outputs/Script//RECEIVED[contains(@Command,'-ExecuteEnquiry')]">
								<xsl:if test="position() &lt; 11">
									<xsl:apply-templates select="." mode="enquiry">
										<xsl:with-param name="postfix">
											<xsl:text>ENQ</xsl:text>
											<xsl:value-of select="$iter"/>
										</xsl:with-param>
									</xsl:apply-templates>
								</xsl:if>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<xsl:for-each select="ancestor::Sequence/preceding-sibling::Sequence[1]/Outputs/Script//RECEIVED[contains(@Command,'-ExecuteDrillAction')]">
								<xsl:if test="position() &lt; 11">
									<xsl:apply-templates select="." mode="enquiry">
										<xsl:with-param name="postfix">
											<xsl:text>ENQ</xsl:text>
											<xsl:value-of select="$iter"/>
										</xsl:with-param>
									</xsl:apply-templates>
								</xsl:if>
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
					
					
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>

	<xsl:template name="createEnqResultTable">
		<div class="fs" name="fs">
			<xsl:attribute name="id">
				<xsl:text>fs</xsl:text>
				<xsl:value-of select="generate-id(.)"/>
			</xsl:attribute>
			<h3>Filter(s):</h3>

			<table width="100%" border="2">
				<thead>
					<tr>
						<th>Field name</th>
						<th>Operator</th>
						<th>Value</th>
						<xsl:if test="$isCompare=1">
							<th>Baseline value</th>
						</xsl:if>
					</tr>
				</thead>
				<tbody>
					<xsl:for-each select=".//FilterFields/FilterField">
						<tr>
							<td>
								<xsl:choose>
									<xsl:when test="@name!=''">
										<xsl:value-of select="@name"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="@Baseline_name"/>
									</xsl:otherwise>
								</xsl:choose>
							</td>

							<td>
								<xsl:choose>
									<xsl:when test="@operator!=''">
										<xsl:value-of select="@operator"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="@Baseline_operator"/>
									</xsl:otherwise>
								</xsl:choose>
							</td>
							<td>
								<xsl:value-of select="@value"/>
							</td>
							<xsl:if test="$isCompare=1">
								<td>
									<xsl:value-of select="@Baseline_value"/>
								</td>
							</xsl:if>
						</tr>
					</xsl:for-each>
				</tbody>
			</table>
		</div>

		<div class="eo" name="eo">
			<xsl:attribute name="id">
				<xsl:text>eo</xsl:text>
				<xsl:value-of select="generate-id(.)"/>
			</xsl:attribute>
			<h4>Expected output(s)</h4>
			<xsl:for-each select="ExpectedOutput">

				<table width="63%" border="2">
					<xsl:if test="$isCompare=1">
						<thead>
							<tr>
								<th/>
								<th>value</th>
								<th>baseline value</th>
							</tr>
						</thead>
					</xsl:if>
					<tbody>
						<tr>
							<td>
								<strong>Expected result:</strong>
							</td>
							<td>
								<xsl:value-of select="@expectedResult"/>
							</td>
							<xsl:if test="$isCompare=1">
								<td>
									<xsl:value-of select="@Baseline_expectedResult"/>
								</td>
							</xsl:if>
						</tr>
						<tr>
							<td>
								<strong>Pop up menu action:</strong>
							</td>
							<td>
								<xsl:value-of select="@popUpMenu"/>
							</td>
							<xsl:if test="$isCompare=1">
								<td>
									<xsl:value-of select="@Baseline_popUpMenu"/>
								</td>
							</xsl:if>
						</tr>
					</tbody>
				</table>


				<xsl:if test="Field">
					<h4>Expected value(s) to be checked:</h4>

					<table width="100%" border="2">
						<thead>
							<tr>
								<th>Field</th>
								<th>Expected Operator</th>
								<th>Filter Operator</th>
								<th>Filter Value</th>
								<th>Expected Value</th>
								<xsl:if test="$isCompare=1">
									<th>Baseline filter value</th>
									<th>Baseline expected value</th>
								</xsl:if>
							</tr>
						</thead>
						<tbody>
							<xsl:for-each select="Field">
								<tr>
									<td>
										<xsl:value-of select="@name"/>
									</td>
									<td>
										<xsl:value-of select="@expectedOperator"/>
									</td>
									<td>
										<xsl:value-of select="@filterOperator"/>
									</td>
									<td>
										<xsl:value-of select="@filterValue"/>
									</td>
									<td>
										<xsl:value-of select="@expectedValue"/>
									</td>
									<xsl:if test="$isCompare=1">
										<td>
											<xsl:value-of select="@Baseline_filterValue"/>
										</td>
										<td>
											<xsl:value-of select="@Baseline_expectedValue"/>
										</td>
									</xsl:if>
								</tr>
							</xsl:for-each>
						</tbody>
					</table>
				</xsl:if>
			</xsl:for-each>
		</div>

		<h3>Result(s):</h3>

		<xsl:choose>
			<xsl:when test="ancestor::InputMessage/@iteration">
				<xsl:variable name="iteration" select="ancestor::InputMessage/@iteration"/>
				<xsl:call-template name="createEnqResultTableForEach">
					<xsl:with-param name="select" select="ancestor::Sequence/Outputs/Iteration[(@number=$iteration)]/Script/SelectionResult"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="createEnqResultTableForEach">
					<xsl:with-param name="select" select="ancestor::Sequence/Outputs/Script/SelectionResult"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!--Used by createEnqResultTable template-->
	<xsl:template name="createEnqResultTableForEach">
		<xsl:param name="select"/>
		<xsl:for-each select="$select">
			<xsl:variable name="maxColumns">
				<xsl:number value="6" format="1"/>
			</xsl:variable>
			<xsl:variable name="firstRow" select="./Row[1]"/>

			<xsl:for-each select="./Row[1]/Field[not(@Row)]">
				<xsl:variable name="columnPos"/>
				<xsl:if test="((position() mod ($maxColumns)) = 1)">
					<xsl:variable name="columnPos">
						<xsl:number value="position()"/>
					</xsl:variable>
					<table width="100%" border="2" style="table-layout:auto;">
						<thead>
							<tr style="height:28px">
								<xsl:if test="$isCompare=1">
									<xsl:if test="count(Field[not(@Row)])&gt;0">
										<th style="width:70px"/>
									</xsl:if>
								</xsl:if>

								<xsl:for-each select="../Field[not(@Row) and (position() &gt;= $columnPos) and (position() &lt; ($columnPos+$maxColumns))]">
									<!-- columns -->
									<th>
										<xsl:if test="$isCompare=1">
											<xsl:if test="contains(@TestManager_DiffType,'Changed')">
												<xsl:attribute name="class">changed</xsl:attribute>
											</xsl:if>
											<xsl:if test="contains(@TestManager_DiffType,'Added')">
												<xsl:attribute name="class">added</xsl:attribute>
											</xsl:if>
											<xsl:if test="contains(@TestManager_DiffType,'Removed')">
												<xsl:attribute name="class">removed</xsl:attribute>
											</xsl:if>
										</xsl:if>
										<xsl:if test="@Name!='' and @Baseline_Name!='' and @Baseline_Name!=@Name">
											<xsl:value-of select="@Name"/>
											<xsl:text>/</xsl:text>
											<xsl:value-of select="@Baseline_Name"/>
										</xsl:if>
										<xsl:if test="(@Name!='' and @Baseline_Name!='' and @Baseline_Name=@Name) or (@Name!='' and (@Baseline_Name='' or not(@Baseline_Name)))">
											<xsl:value-of select="@Name"/>
										</xsl:if>
										<xsl:if test="@Name='' or not(@Name)">
											<xsl:value-of select="@Baseline_Name"/>
										</xsl:if>
									</th>
								</xsl:for-each>
							</tr>
						</thead>
						<tbody>
							<xsl:for-each select="../../Row">
								<xsl:variable name="currentRow" select="current()"/>
								<!-- rows -->
								<tr>
									<xsl:if test="$isCompare=1">
										<xsl:if test="count(Field[not(@Row)])&gt;0">
											<th style="width:70px">
												<xsl:text>Value</xsl:text>
												<hr/>
												<xsl:text>Baseline value</xsl:text>
											</th>
										</xsl:if>
									</xsl:if>
									<xsl:for-each select="utils2:getEnquiryRowNodeList($firstRow, $currentRow)[not(@Row) and (position() &gt;= $columnPos) and (position() &lt; ($columnPos+$maxColumns))]">
										<xsl:choose>
											<xsl:when test=".//Testcase[@Text='Field check failed']">
												<td style="white-space:normal;" bgcolor="#FF0000">
													<xsl:call-template name="resultsRows"/>
												</td>
											</xsl:when>
											<xsl:otherwise>
												<td style="white-space:normal;">
													<xsl:call-template name="resultsRows"/>
												</td>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:for-each>
								</tr>
								<xsl:if test=".//Defect">
									<tr>
										<th>Defects</th>
										<!-- TODO: THIS ISN'T TESTED WITH MY utils2:getEnquiryRowNodeList METHOD -->
										<xsl:for-each select="utils2:getEnquiryRowNodeList($firstRow, $currentRow)[not(@Row) and (position() &gt;= $columnPos) and (position() &lt; ($columnPos+$maxColumns))]">
											<td>
												<xsl:if test="$isCompare=1">
													<xsl:if test="contains(@TestManager_DiffType,'Changed') and @Name=@Baseline_Name">
														<xsl:attribute name="class">
															<xsl:text>changed</xsl:text>
														</xsl:attribute>
													</xsl:if>
													<xsl:if test="contains(@TestManager_DiffType,'Added')">
														<xsl:attribute name="class">
															<xsl:text>added</xsl:text>
														</xsl:attribute>
													</xsl:if>
													<xsl:if test="contains(@TestManager_DiffType,'Removed')">
														<xsl:attribute name="class">
															<xsl:text>removed</xsl:text>
														</xsl:attribute>
													</xsl:if>
												</xsl:if>

												<xsl:if test="./Defect">
													<xsl:for-each select="Defect">
														<xsl:value-of select="@id"/>
														<xsl:text>(</xsl:text>
														<xsl:value-of select="@name"/>
														<xsl:text>)</xsl:text>
														<br/>
													</xsl:for-each>
												</xsl:if>
											</td>
										</xsl:for-each>
									</tr>
								</xsl:if>
							</xsl:for-each>
						</tbody>
					</table>
					<br/>
				</xsl:if>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="resultsRows">
		<xsl:if test="$isCompare=1">
			<xsl:if test="contains(@TestManager_DiffType,'Changed') and @Name=@Baseline_Name">
				<xsl:attribute name="class">
					<xsl:text>changed</xsl:text>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="contains(@TestManager_DiffType,'Added')">
				<xsl:attribute name="class">
					<xsl:text>added</xsl:text>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="contains(@TestManager_DiffType,'Removed')">
				<xsl:attribute name="class">
					<xsl:text>removed</xsl:text>
				</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<xsl:if test="not(@Value)">
			<xsl:text>&#xA0;</xsl:text>
		</xsl:if>
		<xsl:if test="@Value=''">
			<xsl:text>''</xsl:text>
		</xsl:if>
		<xsl:if test="@Value!=''">
			<xsl:value-of select="@Value"/>
		</xsl:if>
		<xsl:if test="@Expected and not( @Expected= '')">, exp:
			<xsl:value-of select="@Expected"/>
		</xsl:if>
		<xsl:if test="Testcase[@Text='Field check failed']">
			<strong>Failed!</strong>
		</xsl:if>
		<xsl:if test="$isCompare=1">
			<hr/>
			<xsl:if test="not(@Baseline_Value)">
				<xsl:text>&#xA0;</xsl:text>
			</xsl:if>
			<xsl:if test="@Baseline_Value=''">
				<xsl:text>''</xsl:text>
			</xsl:if>
			<xsl:if test="@Baseline_Value!=''">
				<xsl:value-of select="@Baseline_Value"/>
			</xsl:if>
			<xsl:if test="@Baseline_Expected and not( @Baseline_Expected= '')">, exp:
				<xsl:value-of select="@Baseline_Expected"/>
			</xsl:if>
			<xsl:if test="Testcase[@Baseline_Text='Field check failed']">
				<strong>Failed!</strong>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="SET_FIELD">
		<tr>
			<td>
				<xsl:if test="@Text!=''">
					<xsl:value-of select="@Text"/>
				</xsl:if>
				<xsl:if test="@Text='' or not(@Text)">
					<xsl:value-of select="@Baseline_Text"/>
				</xsl:if>
			</td>
			<xsl:choose>
				<xsl:when test="count(./Testcase)=1 or contains(@Value,'#ENTER') or contains(@Baseline_Value,'#ENTER')">
					<td>
						<xsl:if test="substring-after(substring-before(current()/@Text,'.)'),'(')=''">
							<xsl:text>'</xsl:text>
							<xsl:value-of select="ancestor::Version/*[contains(name(),'VersionFields')]/descendant::*[contains(current()/@Text,name())]/@value"/>
							<xsl:text>'</xsl:text>
						</xsl:if>
						<xsl:if test="substring-after(substring-before(current()/@Text,'.)'),'(')!=''">
							<xsl:text>'</xsl:text>
							<xsl:value-of select="ancestor::Version/*[contains(name(),'VersionFields')]/descendant::*[contains(current()/@Text,name())][position()=number(substring-before(substring-after(current()/@Text,'('),'.'))]/@value"/>
							<xsl:text>'</xsl:text>
						</xsl:if>
						<xsl:if test="contains(@Value,'#ENTER')">
							<span style="font-weight:bold;">
								<xsl:text> ENTER pushed!</xsl:text>
							</span>
						</xsl:if>
					</td>
					<xsl:if test="$isCompare=1">
						<td>
							<xsl:if test="substring-after(substring-before(current()/@Baseline_Text,'.)'),'(')=''">
								<xsl:text>'</xsl:text>
								<xsl:value-of select="ancestor::Version/*[contains(name(),'VersionFields')]/descendant::*[contains(current()/@Baseline_Text,name())]/@Baseline_value"/>
								<xsl:text>'</xsl:text>
							</xsl:if>
							<xsl:if test="substring-after(substring-before(current()/@Baseline_Text,'.)'),'(')!=''">
								<xsl:text>'</xsl:text>
								<xsl:value-of select="ancestor::Version/*[contains(name(),'VersionFields')]/descendant::*[contains(current()/@Baseline_Text,name())][position()=number(substring-before(substring-after(current()/@Baseline_Text,'('),'.'))]/@Baseline_value"/>
								<xsl:text>'</xsl:text>
							</xsl:if>
							<xsl:if test="contains(@Baseline_Value,'#ENTER')">
								<span style="font-weight:bold;">
									<xsl:text> ENTER pushed!</xsl:text>
								</span>
							</xsl:if>
						</td>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="./*">
						<xsl:if test="starts-with(@Text,'Field value :')">
							<td>
								<xsl:value-of select="substring-before(substring-after(@Text,'Field value :'),' and Expected : ')"/>
								<xsl:if test="substring-before(substring-after(@Text,' and Expected : '),' are not the same!')">
									<span style="font-weight:bold;">
										<xsl:text> </xsl:text>
										<xsl:value-of select="substring-before(substring-after(@Text,' and Expected : '),' are not the same!')"/> Warning
									</span>
								</xsl:if>
							</td>
							<xsl:if test="$isCompare=1">
								<td>
									<xsl:value-of select="substring-before(substring-after(@Baseline_Text,'Field value :'),' and Expected : ')"/>
									<xsl:if test="substring-before(substring-after(@Baseline_Text,' and Expected : '),' are not the same!')">
										<span style="font-weight:bold;">
											<xsl:text> </xsl:text>
											<xsl:value-of select="substring-before(substring-after(@Baseline_Text,' and Expected : '),' are not the same!')"/> Warning
										</span>
									</xsl:if>
								</td>
							</xsl:if>
						</xsl:if>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
	</xsl:template>

	<xsl:template match="Message[@Interface or @Baseline_Interface or not(./Message)]">
		<xsl:if test="(@filename) and (./Info) and (./Info/@Text)">
			<span class="TableHeader">
				<xsl:value-of select="@filename"/>
				<br/>
				<br/>
			</span>
			<xsl:for-each select="./Info">
				<xsl:value-of select="@Text"/>
				<br/>
			</xsl:for-each>
		</xsl:if>
		<xsl:if test="(./Info) and not(./Info/@Text)">
			<span class="TableHeader">
				<xsl:value-of select="@filename"/>
				<br/>
				<br/>
			</span>
			<xsl:for-each select="./Info/@*">
				<xsl:value-of select="name(.)"/>:
				<xsl:value-of select="."/>
				<br/>
			</xsl:for-each>
		</xsl:if>
		<table width="100%" border="2">
			<thead>
				<xsl:if test="@Interface or @Baseline_Interface">
					<tr>
						<td colspan="2" align="center">
							<span class="TableHeader">
								<xsl:choose>
									<xsl:when test="@Interface!=''">
										<xsl:value-of select="@Interface"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="@Baseline_Interface"/>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:if test="@Key or @Baseline_Key">
									<xsl:text>(</xsl:text>
									<xsl:choose>
										<xsl:when test="@Interface!=''">
											<xsl:value-of select="@Key"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="@Baseline_Key"/>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:text>)</xsl:text>
								</xsl:if>
							</span>
						</td>
					</tr>
				</xsl:if>
				<tr>
					<th>Field name</th>
					<th>Value</th>
					<xsl:if test="$isCompare=1">
						<th>Baseline value</th>
					</xsl:if>
				</tr>
			</thead>
			<tbody>
			<xsl:for-each select="./*[not(name()='Metadata') and //@Value]">
				<xsl:apply-templates mode="messageblock"/>
			</xsl:for-each>
			</tbody>
		</table>
		<p/>
		<h3>Result(s):</h3>
		
		<xsl:call-template name="createInterfaceResultTableForEach">
			<xsl:with-param name="select" select=".//Record"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="*" mode="messageblock">
		<xsl:if test="@Value!='' or @Baseline_Value!=''">
			<tr>
				<xsl:if test="$isCompare=1">
					<xsl:if test="contains(@TestManager_DiffType,'Changed')">
						<xsl:attribute name="class">changed</xsl:attribute>
					</xsl:if>
					<xsl:if test="contains(@TestManager_DiffType,'Added')">
						<xsl:attribute name="class">added</xsl:attribute>
					</xsl:if>
					<xsl:if test="contains(@TestManager_DiffType,'Removed')">
						<xsl:attribute name="class">removed</xsl:attribute>
					</xsl:if>
				</xsl:if>
				<td style="width: 30%">
					<xsl:value-of select="name(.)"/>
				</td>
				<td style="width: 35%">
					<xsl:for-each select="@Value">
						<xsl:value-of select="."/>
					</xsl:for-each>
				</td>
				<xsl:if test="$isCompare=1">
					<td style="width: 35%">
						<xsl:for-each select="@Baseline_Value">
							<xsl:value-of select="."/>
						</xsl:for-each>
					</td>
					<xsl:if test="./Defect">
						<td>

							<a>
								<xsl:attribute name="id">
									<xsl:text>def</xsl:text>
									<xsl:number value="count(preceding::Defect)"/>
								</xsl:attribute>
								<xsl:attribute name="name">
									<xsl:text>defect</xsl:text>
									<xsl:value-of select="./Defect/@id"/>
								</xsl:attribute>

								<xsl:for-each select="Defect">
									<xsl:value-of select="@id"/>
									<xsl:text>(</xsl:text>
									<xsl:value-of select="@name"/>
									<xsl:text>)</xsl:text>
									<br/>
								</xsl:for-each>

								<xsl:call-template name="defectButtons">
									<xsl:with-param name="defectnumber" select="count(preceding::Defect)"/>
								</xsl:call-template>
								<input value="x" type="button">
									<xsl:attribute name="onclick">
										<xsl:text>hidingDefectFromDefects('</xsl:text>
										<xsl:value-of select="./Defect/@id"/>
										<xsl:text>');</xsl:text>
									</xsl:attribute>
								</input>
							</a>
						</td>
					</xsl:if>
				</xsl:if>
			</tr>
		</xsl:if>
		<xsl:if test="@FieldValue!='' or @Baseline_FieldValue!=''">
			<tr>
				<xsl:if test="$isCompare=1">
					<xsl:if test="contains(@TestManager_DiffType,'Changed')">
						<xsl:attribute name="class">changed</xsl:attribute>
					</xsl:if>
					<xsl:if test="contains(@TestManager_DiffType,'Added')">
						<xsl:attribute name="class">added</xsl:attribute>
					</xsl:if>
					<xsl:if test="contains(@TestManager_DiffType,'Removed')">
						<xsl:attribute name="class">removed</xsl:attribute>
					</xsl:if>
				</xsl:if>
				<td style="width: 30%">
					<xsl:choose>
						<xsl:when test="@name!=''">
							<xsl:value-of select="@name"/>
						</xsl:when>
						<xsl:when test="@Baseline_name!=''">
							<xsl:value-of select="@Baseline_name"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="name()"/>
						</xsl:otherwise>
					</xsl:choose>
				</td>
				<td style="width: 35%">

					<xsl:for-each select="@FieldValue">
						<xsl:value-of select="."/>
					</xsl:for-each>
				</td>
				<xsl:if test="$isCompare=1">
					<td style="width: 35%">
						<xsl:for-each select="@Baseline_FieldValue">
							<xsl:value-of select="."/>
						</xsl:for-each>
					</td>
					<xsl:if test="./Defect">
						<td>

							<a>
								<xsl:attribute name="id">
									<xsl:text>def</xsl:text>
									<xsl:number value="count(preceding::Defect)"/>
								</xsl:attribute>
								<xsl:attribute name="name">
									<xsl:text>defect</xsl:text>
									<xsl:value-of select="./Defect/@id"/>
								</xsl:attribute>

								<xsl:for-each select="Defect">
									<xsl:value-of select="@id"/>
									<xsl:text>(</xsl:text>
									<xsl:value-of select="@name"/>
									<xsl:text>)</xsl:text>
									<br/>
								</xsl:for-each>

								<xsl:call-template name="defectButtons">
									<xsl:with-param name="defectnumber" select="count(preceding::Defect)"/>
								</xsl:call-template>
								<input value="x" type="button">
									<xsl:attribute name="onclick">
										<xsl:text>hidingDefectFromDefects('</xsl:text>
										<xsl:value-of select="./Defect/@id"/>
										<xsl:text>');</xsl:text>
									</xsl:attribute>
								</input>
							</a>
						</td>
					</xsl:if>
				</xsl:if>
			</tr>
		</xsl:if>
		<!--<xsl:apply-templates mode="messageblock"/> -->
	</xsl:template>

	<xsl:template match="FieldValues[child::node()]" mode="Interface">
		<br/>

		<table width="100%" border="2">
			<thead>
				<tr>
					<th colspan="3" align="center">
						<xsl:text>Interface setting(s)</xsl:text>
					</th>
				</tr>
				<tr>
					<th>Field name</th>
					<th>Value</th>
					<xsl:if test="$isCompare=1">
						<th>Baseline value</th>
					</xsl:if>
				</tr>
			</thead>
			<tbody>
				<xsl:apply-templates select="./*" mode="InterfaceFieldValues"/>
			</tbody>
		</table>
	</xsl:template>

	<xsl:template match="*" mode="InterfaceFieldValues">
		<xsl:choose>
			<xsl:when test="@multivalue='yes'">
				<xsl:for-each select="./item">
					<xsl:apply-templates mode="FieldValues"/>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<tr>
					<xsl:if test="$isCompare=1">
						<xsl:if test="contains(@TestManager_DiffType,'Changed')">
							<xsl:attribute name="class">changed</xsl:attribute>
						</xsl:if>
						<xsl:if test="contains(@TestManager_DiffType,'Added')">
							<xsl:attribute name="class">added</xsl:attribute>
						</xsl:if>
						<xsl:if test="contains(@TestManager_DiffType,'Removed')">
							<xsl:attribute name="class">removed</xsl:attribute>
						</xsl:if>
					</xsl:if>
					<td>
						<xsl:value-of select="name()"/>
					</td>
					<td>
						<xsl:value-of select="@Value"/>
					</td>
					<xsl:if test="$isCompare=1">
						<td>
							<xsl:value-of select="@Baseline_Value"/>
						</td>
						<xsl:if test="./Defect">
							<td>

								<a>
									<xsl:attribute name="id">
										<xsl:text>def</xsl:text>
										<xsl:number value="count(preceding::Defect)"/>
									</xsl:attribute>
									<xsl:attribute name="name">
										<xsl:text>defect</xsl:text>
										<xsl:value-of select="./Defect/@id"/>
									</xsl:attribute>

									<xsl:for-each select="Defect">
										<xsl:value-of select="@id"/>
										<xsl:text>(</xsl:text>
										<xsl:value-of select="@name"/>
										<xsl:text>)</xsl:text>
										<br/>
									</xsl:for-each>

									<xsl:call-template name="defectButtons">
										<xsl:with-param name="defectnumber" select="count(preceding::Defect)"/>
									</xsl:call-template>
									<input value="x" type="button">
										<xsl:attribute name="onclick">
											<xsl:text>hidingDefectFromDefects('</xsl:text>
											<xsl:value-of select="./Defect/@id"/>
											<xsl:text>');</xsl:text>
										</xsl:attribute>
									</input>
								</a>
							</td>
						</xsl:if>
					</xsl:if>
				</tr>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="LogicalAttributes">
		<table width="100%" border="2">
			<thead>
				<tr>
					<th/>
					<th colspan="3">Logical Attributes</th>
				</tr>
				<tr>
					<th/>
					<th>Value</th>
					<th>Baseline value</th>
					<th>Predefined</th>
				</tr>
			</thead>
			<tbody>
				<xsl:for-each select="./LogicalAttribute">
					<tr>
						<th>
							<xsl:value-of select="@path"/>
						</th>
						<td>
							<xsl:if test="string-length(@actual)&gt;=60">
								<xsl:value-of select="substring(@actual,1,60)"/>
								<xsl:text>...</xsl:text>
							</xsl:if>
							<xsl:if test="string-length(@actual)&lt;60">
								<xsl:value-of select="@actual"/>
							</xsl:if>
						</td>
						<td>
							<xsl:if test="string-length(@baseline)&gt;=60">
								<xsl:value-of select="substring(@baseline,1,60)"/>
								<xsl:text>...</xsl:text>
							</xsl:if>
							<xsl:if test="string-length(@baseline)&lt;60">
								<xsl:value-of select="@baseline"/>
							</xsl:if>
						</td>
						<td>
							<xsl:choose>
								<xsl:when test="@predefined='true'">
									<xsl:text>Y</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>N</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</td>
					</tr>
				</xsl:for-each>
			</tbody>
		</table>
	</xsl:template>

	<xsl:template name="defectButtons">
		<xsl:param name="defectnumber"/>
		<input type="button" value="UP">
			<xsl:attribute name="onclick">
				<xsl:text>jumpToPreviousDefectFrom(</xsl:text>
				<xsl:value-of select="$defectnumber"/>
				<xsl:text>)</xsl:text>
			</xsl:attribute>
		</input>
		<input type="button" value="DOWN">
			<xsl:attribute name="onclick">
				<xsl:text>jumpToNextDefectFrom(</xsl:text>
				<xsl:value-of select="$defectnumber"/>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="$numberOfDefect"/>
				<xsl:text>)</xsl:text>
			</xsl:attribute>
		</input>
	</xsl:template>
	
	<!--Used by createInterfaceResultTable template-->
	<xsl:template name="createInterfaceResultTableForEach">
		<xsl:param name="select"/>
		<xsl:for-each select="$select[position() = 1]">
			<xsl:variable name="maxColumns">
				<xsl:number value="6" format="1"/>
			</xsl:variable>
			<xsl:variable name="firstRecord" select="self::node()[position() = 1]"/>

			<xsl:for-each select="self::node()[position() = 1]/*">
				<xsl:variable name="columnPos"/>
				<xsl:if test="((position() mod ($maxColumns)) = 1)">
					<xsl:variable name="columnPos">
						<xsl:number value="position()"/>
					</xsl:variable>
					<table width="100%" border="2" style="table-layout:auto;">
						<thead>
							<tr style="height:28px">
								<xsl:if test="$isCompare=1">
									<xsl:if test="count(../*)&gt;0">
										<th style="width:70px"/>
									</xsl:if>
								</xsl:if>

								<xsl:for-each select="../*[(position() &gt;= $columnPos) and (position() &lt; ($columnPos+$maxColumns))]">
									<!-- columns -->
									<th>
										<xsl:value-of select="name()"/>
									</th>
								</xsl:for-each>
							</tr>
						</thead>
						<tbody>
							<xsl:for-each select="../../Record">
								<xsl:variable name="currentRecord" select="current()"/>
								<!-- rows -->
								<tr>
									<xsl:for-each select="$currentRecord/*[(position() &gt;= $columnPos) and (position() &lt; ($columnPos+$maxColumns))]">
										<td style="white-space:normal;">
											<xsl:value-of select="@Value"/>
										</td>
									</xsl:for-each>
								</tr>
							</xsl:for-each>
						</tbody>
					</table>
					<br/>
				</xsl:if>
				
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>