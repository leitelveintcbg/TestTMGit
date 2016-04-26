
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" media-type="text/html"
		doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="DTD/xhtml1-strict.dtd"
		cdata-section-elements="script style" encoding="UTF-8" />

	<xsl:param name="logo"/>
	<xsl:variable name="isCompare">
		<xsl:choose>
			<xsl:when test="Root/@TestManager_isDifference">
				<xsl:number value="1" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:number value="0" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="numberOfDefect">
		<xsl:value-of select="count(//Defect)" />
	</xsl:variable>

	<xsl:template match="/">
		<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
			<head>
				<title>
					<xsl:choose>
						<xsl:when test="./Root/ExecutionLog/@comment!=''">
							<xsl:value-of select="./Root/ExecutionLog/@comment" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="./Root/ExecutionLog/@fileName" />
						</xsl:otherwise>
					</xsl:choose>
				</title>

				<xsl:element name="link">
					<xsl:attribute name="href"><xsl:value-of
						select="concat(//@resourceUrl, 'style.css')" /></xsl:attribute>
					<xsl:attribute name="type">text/css</xsl:attribute>
					<xsl:attribute name="rel">stylesheet</xsl:attribute>
				</xsl:element>

				<xsl:element name="script">
					<xsl:attribute name="src"><xsl:value-of
						select="concat(//@resourceUrl, 'scripts.js')" /></xsl:attribute>
					<xsl:attribute name="type">text/javascript</xsl:attribute>
				</xsl:element>

			</head>
			<body onload="checkCookie()">
				<div id="statDiv001">
					<xsl:attribute name="style">
						<xsl:text>visibility:hidden; position:absolute; border:dotted #000000 thick; top:7.5%; height:404px;width:404px;z-index:1;overflow:auto; background:#FFFFFF; left:</xsl:text>
						<xsl:choose>
							<xsl:when test="$isCompare=1">
								<xsl:text>295</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>155</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:text>px;</xsl:text>
					</xsl:attribute>
					
					
					<div
						style="float: right; background: red; color: white; font: x-small bold; cursor: pointer;"
						onclick="changeVisibility('statDiv001');">X</div>
					<h1 style="text-align:center;">Statistics</h1>
					<xsl:text>Number of testscripts: </xsl:text>
					<xsl:value-of
						select="count(//InputMessage[@class!='hu.fot.testManager.core.scripts.XmlCallScript'])" />
					<br />
					<xsl:text>Number of differences: </xsl:text>
					<xsl:value-of select="count(//*[@TestManager_DiffType!=''])" />
					<br />
					<xsl:text>Number of covered differences: </xsl:text>
					<xsl:value-of select="count(//Defect)" />
					<br />
					<xsl:text>Number of defects: </xsl:text>
					<xsl:value-of select="count(//Defect[not(@id=preceding::Defect/@id)])" />
				</div>
				<div id="formDiv001"
					style="visibility:hidden;position:absolute; border:#000000 dashed medium;left:15px;top:7.5%;height:400px; width:400px;z-index:1;background:#FFFFFF;">
					<div
						style="float: right; background: red; color: white; font: x-small bold; cursor: pointer;"
						onclick="changeVisibility('formDiv001');">X</div>
					<h1 style="text-align:center;">Defects</h1>
					<form id="defectForm" method="post" action="">
						<xsl:for-each select="//Defect[not(@id=preceding::Defect/@id)]">
							<xsl:sort select="@id" />
							<input type="checkbox" checked="checked">
								<xsl:attribute name="value">
									<xsl:text>defect</xsl:text>
									<xsl:value-of select="@id" />
								</xsl:attribute>
								<xsl:attribute name="id">
									<xsl:text>checkbox</xsl:text>
									<xsl:value-of select="@id" />
								</xsl:attribute>
							</input>
							<xsl:value-of select="@id" />
							<xsl:text> - </xsl:text>
							<xsl:value-of select="@name" />
							<br />
						</xsl:for-each>
						<input name="submit" type="button" value="OK"
							onclick="processDefectFilter('defectForm');" />
						<input name="reset" type="reset" value="Reset" />
					</form>
				</div>
				<div id="tocDiv001">
					<xsl:attribute name="style">
						<xsl:text>visibility:hidden; position:absolute; border:dotted #000000 thick; top:7.5%; height:404px;width:404px;z-index:1;overflow:auto; background:#FFFFFF; left:</xsl:text>
						<xsl:choose>
							<xsl:when test="$isCompare=1">
								<xsl:text>155</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>15</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:text>px;</xsl:text>
					</xsl:attribute>
					<div
						style="float: right; background: red; color: white; font: x-small bold; cursor: pointer;"
						onclick="changeVisibility('tocDiv001');">Close[X]</div>
					<h1 style="text-align:center;">Open...</h1>
					<script language="javascript">
						<xsl:text disable-output-escaping="yes">
              document.getElementById('tocDiv001').innerHTML += "&lt;iframe src='Menu.html' id='iframe001' scrolling='auto' height='95%' width='100%' frameborder='0'&gt; &lt;/iframe&gt;";
              document.close();
            </xsl:text>
					</script>
				</div>
				<div id="reportDiv001">
					<xsl:attribute name="style">
						<xsl:text>visibility:hidden; position:absolute; border:dotted #000000 thick; top:7.5%; height:404px;width:404px;z-index:1;overflow:auto; background:#FFFFFF; left:</xsl:text>
						<xsl:choose>
							<xsl:when test="$isCompare=1">
								<xsl:text>435</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>295</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:text>px;</xsl:text>
					</xsl:attribute>
					<div
						style="float: right; background: red; color: white; font: x-small bold; cursor: pointer;"
						onclick="changeVisibility('reportDiv001');">Close[X]</div>
					<h1 style="text-align:center;">Show in report...</h1>
					<form action="" method="post" id="reportForm001">
						<xsl:if test="$isCompare=1">
							<h3>
								<xsl:text>General:</xsl:text>
							</h3>
							<ul type="disc">
								<li>
									<input type="checkbox" value="la" checked="checked" />
									Logical Attributes
								</li>
							</ul>
							<hr />
						</xsl:if>
						<h3>
							<xsl:text>Versions:</xsl:text>
						</h3>
						<ul type="disc">
							<li>
								<input type="checkbox" value="odoid" id="checkboxODOID"
									checked="checked" />
								<xsl:text>Original design of input data</xsl:text>
							</li>
							<li>
								<input type="checkbox" value="sfv" id="checkboxSFV"
									onchange="changeSubCheckboxes();" checked="checked" />
								<xsl:text>Setting field value(s)</xsl:text>
							</li>

							<ul>
								<li>
									<input type="checkbox" value="ti" id="checkboxTI"
										onchange="changeUpperCheckBox();" checked="checked" />
									<xsl:text>Transaction id</xsl:text>
								</li>
								<li>
									<input type="checkbox" value="fvs" id="checkboxFVS"
										onchange="changeUpperCheckBox();" checked="checked" />
									<xsl:text>Field value setting</xsl:text>
								</li>
								<li>
									<input type="checkbox" value="or" id="checkboxOR"
										onchange="changeUpperCheckBox();" checked="checked" />
									<xsl:text>Override reason(s)</xsl:text>
								</li>
								<li>
									<input type="checkbox" value="em" id="checkboxEM"
										onchange="changeUpperCheckBox();" checked="checked" />
									<xsl:text>Error message(s)</xsl:text>
								</li>
								<li>
									<input type="checkbox" value="erdc" id="checkboxERDC"
										onchange="changeUpperCheckBox();" checked="checked" />
									<xsl:text>Error reason(s) during commit</xsl:text>
								</li>
								<li>
									<input type="checkbox" value="com" id="checkboxCOM"
										onchange="changeUpperCheckBox();" checked="checked" />
									<xsl:text>Commit</xsl:text>
								</li>
								<li>
									<input type="checkbox" value="glomes" id="checkboxGLOME"
										onchange="changeUpperCheckBox();" checked="checked" />
									<xsl:text>GLOBUS message(s)</xsl:text>
								</li>
								<li>
									<input type="checkbox" value="txncom" id="checkboxTXNCOM"
										onchange="changeUpperCheckBox();" checked="checked" />
									<xsl:text>TXN COMPLETED</xsl:text>
								</li>
							</ul>
							<li>
								<input type="checkbox" value="sbc" id="checkboxSBC"
									checked="checked" />
								<xsl:text>Snapshot of non-empty fields before commit</xsl:text>
							</li>
							<li>
								<input type="checkbox" value="sac" id="checkboxSAC"
									checked="checked" />
								<xsl:text>Snapshot of non-empty fields after commit</xsl:text>
							</li>
						</ul>
						<hr />
						<h3>
							<xsl:text>Enquiries:</xsl:text>
						</h3>
						<ul type="disc">
							<li>
								<input type="checkbox" value="fs" id="checkboxFs" checked="checked" />
								<xsl:text>Filters</xsl:text>
							</li>
							<li>
								<input type="checkbox" value="eo" id="checkboxEO" checked="checked" />
								<xsl:text>Expected output(s)</xsl:text>
							</li>
							<li>
								<input type="checkbox" value="rs" id="checkboxRs" checked="checked" />
								<xsl:text>Result(s)</xsl:text>
							</li>
						</ul>
						<hr />
						<h3>
							<xsl:text>Reports:</xsl:text>
						</h3>
						<ul type="disc">
							<li>
								<input type="checkbox" value="rep" id="checkboxREP"
									checked="checked" />
								<xsl:text>Report</xsl:text>
							</li>
						</ul>
						<hr />
						<h3>
							<xsl:text>Interfaces:</xsl:text>
						</h3>
						<ul type="disc">
							<li>
								<input type="checkbox" value="im" id="checkboxIM" checked="checked" />
								<xsl:text>Interface message</xsl:text>
							</li>
						</ul>
						<input name="submit" type="button" value="OK"
							onclick="processReportFilter('reportForm001')" />
						<input name="reset" type="reset" value="Reset" />
					</form>
				</div>

				<div id="dayFilterDiv001">
					<xsl:attribute name="style">
						<xsl:text>visibility:hidden; position:absolute; border:dotted #000000 thick; top:7.5%; height:404px;width:404px;z-index:1;overflow:auto; background:#FFFFFF; left:</xsl:text>
						<xsl:choose>
							<xsl:when test="$isCompare=1">
								<xsl:text>575</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>435</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:text>px;</xsl:text>
					</xsl:attribute>
					<div
						style="float: right; background: red; color: white; font: x-small bold; cursor: pointer;"
						onclick="changeVisibility('dayFilterDiv001');">Close[X]</div>
					<h1 style="text-align:center;">Show in report...</h1>
					<form action="" method="post" id="dayFilter001">
						<ul>
							<xsl:for-each select=".//Day[./Sequence/Inputs/InputMessage]">
								<li>
									<input type="checkbox" checked="checked">
										<xsl:attribute name="value">

											<xsl:text>daydiv</xsl:text>
											<xsl:value-of select="generate-id(.)" />
										</xsl:attribute>
									</input>
									<xsl:choose>
										<xsl:when test="@value!=''">
											<xsl:value-of select="@value" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="@Baseline_value" />
										</xsl:otherwise>
									</xsl:choose>
									<xsl:text>. day, </xsl:text>
									<xsl:choose>
										<xsl:when test="@phase!=''">
											<xsl:value-of select="@phase" />
										</xsl:when>
										<xsl:when test="@Baseline_phase!=''">
											<xsl:value-of select="@Baseline_phase" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>main</xsl:text>
										</xsl:otherwise>
									</xsl:choose>
								</li>
							</xsl:for-each>
						</ul>
						<input name="submit" type="button" value="OK"
							onclick="processDayFilter('dayFilter001')" />
						<input name="reset" type="reset" value="Reset" />
					</form>
				</div>

				<div id="headerMenu"
					style="position:absolute;left:0%;width:100%;top:0%;height:9.99%; background:#FFFFFF;overflow:hidden;">
					<!-- issue 3661 - hide some functions -->
					
					<xsl:if test="$isCompare=1 and false">
						<input onclick="changeVisibility('formDiv001');" value="Filter Defects..."
							type="button" style="width:140px" />
						<input onclick="changeVisibility('tocDiv001');" value="Open File..."
							style="width:140px" type="button" />
						<input onclick="changeVisibility('statDiv001');" value="Statistics"
							style="width:140px" type="button" />
					</xsl:if>
					<input onclick="changeVisibility('reportDiv001');" value="Filter Report..."
						style="width:140px" type="button" />
					<input onclick="changeVisibility('dayFilterDiv001');" value="Filter Report by day..."
						style="width:140px" type="button" />
					<input type="button" onclick="printReport()" value="Print Report"
						style="width:140px" />
						
						
				</div>

				
				<!-- table of contents -->
				<div
					style="position:absolute;left:0%;width:19.99%;top:10%;height:89.5%; z-index:0;overflow:auto;"
					class="menucat" id="tocPage">
					
					<xsl:if test="$isCompare=1">

						<h2>
							<a class="daypage" href="#logicalAttribute" id="menuLogicalAttribute">
								<xsl:text>Logical attributes</xsl:text>
							</a>
						</h2>
					</xsl:if>
					<xsl:for-each select=".//Day[./Sequence/Inputs/InputMessage]">
						<h2>
							<a class="daypage">
								<xsl:attribute name="href">
									<xsl:text>#day</xsl:text>
									<xsl:choose>
										<xsl:when test="@value!=''">
											<xsl:value-of select="@value" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="@Baseline_value" />
										</xsl:otherwise>
									</xsl:choose>

									<xsl:choose>
										<xsl:when test="@phase!=''">
											<xsl:text>_</xsl:text>
											<xsl:value-of select="@phase" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>_</xsl:text>
											<xsl:value-of select="@Baseline_phase" />
										</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>
								<xsl:choose>
									<xsl:when test="@value!=''">
										<xsl:value-of select="@value" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="@Baseline_value" />
									</xsl:otherwise>
								</xsl:choose>
								<xsl:text>. day, </xsl:text>
								<xsl:choose>
									<xsl:when test="@phase!=''">
										<xsl:value-of select="@phase" />
									</xsl:when>
									<xsl:when test="@Baseline_phase!=''">
										<xsl:value-of select="@Baseline_phase" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>main</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
							</a>
						</h2>
						<div class="daydiv" name="daydiv">
							<xsl:attribute name="id">
								<xsl:text>daydiv</xsl:text>
								<xsl:value-of select="generate-id(.)" />
							</xsl:attribute>
							<xsl:for-each
								select=".//Sequence[not(.//Call) and ./Inputs/InputMessage[not(.//Call)]]">
								<xsl:variable name="seqNo">
									<xsl:for-each select="ancestor-or-self::Sequence">
										<xsl:choose>
											<xsl:when test="@number!=''">
												<xsl:value-of select="@number" />
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="@Baseline_number" />
											</xsl:otherwise>
										</xsl:choose>
										<xsl:text>.</xsl:text>
									</xsl:for-each>
								</xsl:variable>
								<xsl:if test=".//RunLog">
									<xsl:for-each select="./Inputs/InputMessage/FieldValues">
										<a href="#{generate-id(.)}" class="versionpage">
											<xsl:attribute name="id">
												<xsl:text>menu</xsl:text>
												<xsl:value-of select="generate-id(.)" />
											</xsl:attribute>

											<xsl:value-of select="$seqNo" />
											<xsl:text>: </xsl:text>
											<xsl:choose>
												<xsl:when test="@version!=''">
													<xsl:value-of select="@version" />
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="@Baseline_version" />
												</xsl:otherwise>
											</xsl:choose>
											<xsl:text>, </xsl:text>
											<xsl:choose>
												<xsl:when test="@Mode!=''">
													<xsl:value-of select="@Mode" />
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="@Baseline_Mode" />
												</xsl:otherwise>
											</xsl:choose>
											<xsl:if
												test="../@iteration or ../@Baseline_iteration or ancestor::Iteration">
												<xsl:text> Iteration: </xsl:text>

												<xsl:choose>
													<xsl:when test="ancestor::Iteration/@number!=''">
														<xsl:value-of select="ancestor::Iteration/@number" />
													</xsl:when>
													<xsl:when test="ancestor::Iteration/@Baseline_number!=''">
														<xsl:value-of select="ancestor::Iteration/@Baseline_number" />
													</xsl:when>
													<xsl:when test="../@iteration!=''">
														<xsl:value-of select="../@iteration" />
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="../@Baseline_iteration" />
													</xsl:otherwise>
												</xsl:choose>
											</xsl:if>
										</a>
										<br />
									</xsl:for-each>
								</xsl:if>
								<xsl:if test=".//EnquiryData">
									<xsl:for-each select="./Inputs/InputMessage/EnquiryData">
										<a href="#{generate-id(.)}" class="enquirypage">
											<xsl:attribute name="id">
												<xsl:text>menu</xsl:text>
												<xsl:value-of select="generate-id(.)" />
											</xsl:attribute>

											<xsl:value-of select="$seqNo" />
											<xsl:text>: ENQ </xsl:text>
											<xsl:choose>
												<xsl:when test="@name!=''">
													<xsl:value-of select="@name" />
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="@Baseline_name" />
												</xsl:otherwise>
											</xsl:choose>
										</a>
										<br />
									</xsl:for-each>
								</xsl:if>
								<xsl:if test=".//FieldValues[@Interface or @Baseline_Interface]">
									<xsl:for-each select="./Inputs/InputMessage/FieldValues">
										<a href="#{generate-id(.)}" class="interfacepage">
											<xsl:attribute name="id">
												<xsl:text>menu</xsl:text>
												<xsl:value-of select="generate-id(.)" />
											</xsl:attribute>
											<xsl:value-of select="$seqNo" />
											<xsl:text>: Message </xsl:text>
											<xsl:choose>
												<xsl:when test="@version!=''">
													<xsl:value-of select="@version" />
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="@Baseline_version" />
												</xsl:otherwise>
											</xsl:choose>
										</a>
										<br />
									</xsl:for-each>
								</xsl:if>
								<xsl:if test=".//REPORT">
									<xsl:for-each select=".//Outputs[Script/REPORT]">
										<a href="#{generate-id(.)}" class="reportpage">
											<xsl:attribute name="id">
												<xsl:text>menu</xsl:text>
												<xsl:value-of select="generate-id(.)" />
											</xsl:attribute>

											<xsl:value-of select="$seqNo" />
											<xsl:text>: Report</xsl:text>
										</a>
										<br />
									</xsl:for-each>
								</xsl:if>
							</xsl:for-each>
						</div>
					</xsl:for-each>
				</div>
				<!-- table of contents -->
				<div
					style="position:absolute;left:20%; width:80%;top:10%;height:89.5%; z-index:0;overflow:auto;"
					id="mainPage">
					<a id="main" />
					<xsl:for-each select=".//ExecutionLog">
						<xsl:if test="@comment != ''">
							<xsl:for-each select="@comment">
								<h1>
									<xsl:value-of select="." />
								</h1>
							</xsl:for-each>
						</xsl:if>
						<h3>
							<xsl:value-of select=".//ExecutionLog/@fileName" />
						</h3>
						<p />
					</xsl:for-each>
					<xsl:for-each select="Root">
						<xsl:apply-templates mode="Root" />
					</xsl:for-each>
				</div>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="ExecutionLog" mode="Root">
		<xsl:if test="$isCompare=1">
			<div class="la" name="la">
				<xsl:attribute name="id">
					<xsl:text>la</xsl:text>
					<xsl:value-of select="generate-id(.)" />
				</xsl:attribute>
				<xsl:attribute name="onmouseover">
					<xsl:text>menuInJump('menuLogicalAttribute');</xsl:text>
				</xsl:attribute>
				<xsl:attribute name="ondblclick">
					<xsl:text>bookmarkSequence('menuLogicalAttribute');</xsl:text>
				</xsl:attribute>
				<h2>
					<a class="daypage" id="logicalAttribute" />
					<xsl:text>Logical Attributes</xsl:text>
				</h2>
				<xsl:apply-templates select=".//LogicalAttributes" />
			</div>
		</xsl:if>
		<xsl:apply-templates mode="ExecutionLog" />
	</xsl:template>

	<xsl:template match="Day[./Sequence/Inputs/InputMessage]"
		mode="ExecutionLog">
		<xsl:variable name="currentDay">
			<xsl:choose>
				<xsl:when test="@value!=''">
					<xsl:value-of select="@value" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@Baseline_value" />
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>. day, </xsl:text>
			<xsl:choose>
				<xsl:when test="@phase!=''">
					<xsl:value-of select="@phase" />
				</xsl:when>
				<xsl:when test="@Baseline_phase!=''">
					<xsl:value-of select="@Baseline_phase" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>main</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text> phase</xsl:text>
		</xsl:variable>
		<hr />
		<a class="daypage">
			<xsl:attribute name="id">
				<xsl:text>day</xsl:text>
				<xsl:choose>
					<xsl:when test="@value!=''">
						<xsl:value-of select="@value" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="@Baseline_value" />
					</xsl:otherwise>
				</xsl:choose>

				<xsl:choose>
					<xsl:when test="@phase!=''">
						<xsl:text>_</xsl:text>
						<xsl:value-of select="@phase" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>_</xsl:text>
						<xsl:value-of select="@Baseline_phase" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
		</a>
		<h1>
			<xsl:value-of select="$currentDay" />
			<xsl:text>:</xsl:text>
		</h1>
		<div class="daydiv" name="daydiv">
			<xsl:attribute name="id">
				<xsl:text>daydiv</xsl:text>
				<xsl:value-of select="generate-id(.)" />
			</xsl:attribute>
			<xsl:apply-templates
				select=".//Sequence[not(.//Call) and ./Inputs/InputMessage[not(.//Call)]]"
				mode="Day">
				<xsl:with-param name="day" select="$currentDay" />
			</xsl:apply-templates>
		</div>
	</xsl:template>

	<xsl:template
		match="Sequence[not(.//Call) and ./Inputs/InputMessage[not(.//Call)]]"
		mode="Day">
		<xsl:param name="day" />

		<xsl:variable name="seqNo">
			<xsl:value-of select="$day" />
			<xsl:text>, sequence </xsl:text>
			<xsl:for-each select="ancestor-or-self::Sequence">
				<xsl:choose>
					<xsl:when test="@number!=''">
						<xsl:value-of select="@number" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="@Baseline_number" />
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text>.</xsl:text>
			</xsl:for-each>
		</xsl:variable>

		<xsl:if test=".//RunLog">
			<xsl:for-each select="./Inputs/InputMessage/FieldValues">
				<xsl:variable name="itId">
					<xsl:choose>
						<xsl:when test="../@iteration!=''">
							<xsl:value-of select="../@iteration" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="../@Baseline_iteration" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="menuId">
					<xsl:value-of select="generate-id(.)" />
				</xsl:variable>

				<xsl:variable name="versionMode">
					<xsl:choose>
						<xsl:when test="./@Mode!=''">
							<xsl:value-of select="./@Mode" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="./@Baseline_Mode" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>


				<div style="margin-left:15px">
					<xsl:attribute name="onmouseover">
						<xsl:text>menuInJump('menu</xsl:text>
						<xsl:value-of select="$menuId" />
						<xsl:text>');</xsl:text>
					</xsl:attribute>
					<xsl:attribute name="ondblclick">
						<xsl:text>bookmarkSequence('menu</xsl:text>
						<xsl:value-of select="$menuId" />
						<xsl:text>');</xsl:text>
					</xsl:attribute>
					<a>
						<xsl:attribute name="id">
							<xsl:value-of select="$menuId" />
						</xsl:attribute>
					</a>

					<h2>
						<xsl:value-of select="$seqNo" />
						<xsl:text>: Open </xsl:text>
						<xsl:choose>
							<xsl:when test="@version!=''">
								<xsl:value-of select="@version" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="@Baseline_version" />
							</xsl:otherwise>
						</xsl:choose>
						<xsl:text> version in </xsl:text>
						<xsl:choose>
							<xsl:when test="@Mode!=''">
								<xsl:value-of select="@Mode" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="@Baseline_Mode" />
							</xsl:otherwise>
						</xsl:choose>
						<xsl:text> mode</xsl:text>
						<xsl:if test="@usergroup or @Baseline_usergroup">
							<xsl:text> with </xsl:text>
							<xsl:choose>
								<xsl:when test="@usergroup!=''">
									<xsl:value-of select="@usergroup" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="@Baseline_usergroup" />
								</xsl:otherwise>
							</xsl:choose>
							<xsl:text> user</xsl:text>
						</xsl:if>
						<xsl:if test="@bpUsergroup or @Baseline_bpUserGroup">
							<xsl:text> with </xsl:text>
							<xsl:choose>
								<xsl:when test="@bpUsergroup!=''">
									<xsl:value-of select="@bpUsergroup" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="@Baseline_bpUsergroup" />
								</xsl:otherwise>
							</xsl:choose>
							<xsl:text> user</xsl:text>
						</xsl:if>
						<xsl:text>, commit has to be </xsl:text>
						<xsl:choose>
							<xsl:when test="@Commit!=''">
								<xsl:value-of select="@Commit" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="@Baseline_Commit" />
							</xsl:otherwise>
						</xsl:choose>
						<xsl:if
							test="../@iteration or ../@Baseline_iteration or ancestor::Iteration">
							<xsl:text> Iteration: </xsl:text>
							<xsl:choose>
								<xsl:when test="ancestor::Iteration/@number!=''">
									<xsl:value-of select="ancestor::Iteration/@number" />
								</xsl:when>
								<xsl:when test="ancestor::Iteration/@Baseline_number!=''">
									<xsl:value-of select="ancestor::Iteration/@Baseline_number" />
								</xsl:when>
								<xsl:when test="../@iteration!=''">
									<xsl:value-of select="../@iteration" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="../@Baseline_iteration" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:if>
					</h2>

					<div class="odoid" name="odoid">
						<xsl:attribute name="id">
							<xsl:text>odoid</xsl:text>
							<xsl:value-of select="$menuId" />
						</xsl:attribute>
						<p />
						<h3>
							<xsl:text>Original design of input data:</xsl:text>
						</h3>
						<xsl:apply-templates select="." mode="RunLog" />
					</div>

					<xsl:choose>
						<xsl:when test="../../../Outputs/Iteration">
							<xsl:for-each
								select="../../../Outputs/Iteration[@number=$itId  or @Baseline_number=$itId]">
								<div class="sfv" name="sfv">
									<xsl:attribute name="id">
										<xsl:text>sfv</xsl:text>
										<xsl:value-of select="$menuId" />
									</xsl:attribute>
									<h3>
										<xsl:text>Setting field value(s)</xsl:text>
									</h3>


									<xsl:for-each
										select=".//TransactionID[not(preceding-sibling::TransactionID)]">
										<div class="ti" name="ti">
											<xsl:attribute name="id">
												<xsl:text>ti</xsl:text>
												<xsl:value-of select="$menuId" />
											</xsl:attribute>
											<table width="95%" border="2">
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
															<xsl:value-of select="@id" />
														</td>
														<xsl:if test="$isCompare=1">
															<td>
																<xsl:value-of select="@Baseline_id" />
															</td>
														</xsl:if>
													</tr>
												</tbody>
											</table>
										</div>
									</xsl:for-each>


									<xsl:if test=".//SET_FIELD">
										<div class="fvs" name="fvs">
											<xsl:attribute name="id">
												<xsl:text>fvs</xsl:text>
												<xsl:value-of select="$menuId" />
											</xsl:attribute>
											<table width="95%" border="2">
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
													<xsl:apply-templates select=".//SET_FIELD" />
												</tbody>
											</table>
										</div>
									</xsl:if>

									<xsl:for-each select=".//Testcase[starts-with(@Text,'Commit')]">
										<xsl:if
											test="preceding-sibling::Testcase[starts-with(@Text,'Override reason')]">
											<div class="or" name="or">
												<xsl:attribute name="id">
													<xsl:text>or</xsl:text>
													<xsl:value-of select="generate-id(.)" />
												</xsl:attribute>

												<table width="95%" border="2">
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
														<xsl:for-each
															select="preceding-sibling::Testcase[starts-with(@Text,'Override reason')]">
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
																	<xsl:value-of select="@Text" />
																</td>
																<xsl:if test="$isCompare=1">
																	<td>
																		<xsl:value-of select="@Baseline_Text" />
																	</td>
																	<xsl:if test="./Defect">
																		<td>
																			<a>
																				<xsl:attribute name="id">
																					<xsl:text>def</xsl:text>
																					<xsl:number value="count(preceding::Defect)" />
																				</xsl:attribute>
																				<xsl:attribute name="name">
																					<xsl:text>defect</xsl:text>
																					<xsl:value-of select="./Defect/@id" />
																				</xsl:attribute>

																				<xsl:for-each select="Defect">
																					<xsl:value-of select="@id" />
																					<xsl:text>(</xsl:text>
																					<xsl:value-of select="@name" />
																					<xsl:text>)</xsl:text>
																					<br />
																				</xsl:for-each>

																				<xsl:call-template name="defectButtons">
																					<xsl:with-param name="defectnumber"
																						select="count(preceding::Defect)" />
																				</xsl:call-template>
																				<!-- issue 3661 - hide some functions <input value="x" 
																					type="button"> <xsl:attribute name="onclick"> <xsl:text>hidingDefectFromDefects('</xsl:text> 
																					<xsl:value-of select="./Defect/@id" /> <xsl:text>');</xsl:text> </xsl:attribute> 
																					</input> -->
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
										<xsl:if test="../../../VersionFields//*[@errorText!='']">
											<div class="em" name="em">
												<xsl:attribute name="id">
													<xsl:text>em</xsl:text>
													<xsl:value-of select="generate-id(.)" />
												</xsl:attribute>
												<table width="95%" border="2">
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
														<xsl:for-each select="../../../VersionFields//*[@errorText!='']">
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
																			<xsl:value-of select="@fieldNumber1" />
																		</xsl:when>
																		<xsl:otherwise>
																			<xsl:value-of select="@Baseline_fieldNumber1" />
																		</xsl:otherwise>
																	</xsl:choose>
																	<xsl:for-each select="ancestor::Value">
																		<xsl:text>.</xsl:text>
																		<xsl:choose>
																			<xsl:when test="@number!=''">
																				<xsl:value-of select="@number" />
																			</xsl:when>
																			<xsl:otherwise>
																				<xsl:value-of select="@Baseline_number" />
																			</xsl:otherwise>
																		</xsl:choose>
																	</xsl:for-each>
																	<xsl:text>) </xsl:text>
																	<xsl:value-of select="name()" />
																</td>
																<td>
																	<xsl:value-of select="@errorText" />
																</td>
																<xsl:if test="$isCompare=1">
																	<td>
																		<xsl:value-of select="@Baseline_errorText" />
																	</td>
																	<xsl:if test="./Defect">
																		<td>

																			<a>
																				<xsl:attribute name="id">
																					<xsl:text>def</xsl:text>
																					<xsl:number value="count(preceding::Defect)" />
																				</xsl:attribute>
																				<xsl:attribute name="name">
																					<xsl:text>defect</xsl:text>
																					<xsl:value-of select="./Defect/@id" />
																				</xsl:attribute>

																				<xsl:for-each select="Defect">
																					<xsl:value-of select="@id" />
																					<xsl:text>(</xsl:text>
																					<xsl:value-of select="@name" />
																					<xsl:text>)</xsl:text>
																					<br />
																				</xsl:for-each>


																				<xsl:call-template name="defectButtons">
																					<xsl:with-param name="defectnumber"
																						select="count(preceding::Defect)" />
																				</xsl:call-template>
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

										<xsl:if
											test="preceding-sibling::INFO[starts-with(@Text,'Error message')]">
											<div class="erdc" name="erdc">
												<xsl:attribute name="id">
													<xsl:text>erdc</xsl:text>
													<xsl:value-of select="generate-id(.)" />
												</xsl:attribute>
												<table width="95%" border="2">
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
														<xsl:for-each
															select="preceding-sibling::INFO[starts-with(@Text,'Error message')]">
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
																	<xsl:value-of select="@Text" />
																</td>
																<xsl:if test="$isCompare=1">
																	<td>
																		<xsl:value-of select="@Baseline_Text" />
																	</td>
																	<xsl:if test="./Defect">
																		<td>

																			<a>
																				<xsl:attribute name="id">
																					<xsl:text>def</xsl:text>
																					<xsl:number value="count(preceding::Defect)" />
																				</xsl:attribute>
																				<xsl:attribute name="name">
																					<xsl:text>defect</xsl:text>
																					<xsl:value-of select="./Defect/@id" />
																				</xsl:attribute>

																				<xsl:for-each select="Defect">
																					<xsl:value-of select="@id" />
																					<xsl:text>(</xsl:text>
																					<xsl:value-of select="@name" />
																					<xsl:text>)</xsl:text>
																					<br />
																				</xsl:for-each>

																				<xsl:call-template name="defectButtons">
																					<xsl:with-param name="defectnumber"
																						select="count(preceding::Defect)" />
																				</xsl:call-template>
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
										<div class="com" name="com">
											<xsl:attribute name="id">
												<xsl:text>com</xsl:text>
												<xsl:value-of select="generate-id(.)" />
											</xsl:attribute>
											<table width="95%" border="2">
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
															<xsl:value-of select="@Text" />
														</td>
														<xsl:if test="$isCompare=1">
															<td>
																<xsl:value-of select="@Baseline_Text" />
															</td>
															<xsl:if test="./Defect">
																<td>

																	<a>
																		<xsl:attribute name="id">
																			<xsl:text>def</xsl:text>
																			<xsl:number value="count(preceding::Defect)" />
																		</xsl:attribute>
																		<xsl:attribute name="name">
																			<xsl:text>defect</xsl:text>
																			<xsl:value-of select="./Defect/@id" />
																		</xsl:attribute>

																		<xsl:for-each select="Defect">
																			<xsl:value-of select="@id" />
																			<xsl:text>(</xsl:text>
																			<xsl:value-of select="@name" />
																			<xsl:text>)</xsl:text>
																			<br />
																		</xsl:for-each>

																		<xsl:call-template name="defectButtons">
																			<xsl:with-param name="defectnumber"
																				select="count(preceding::Defect)" />
																		</xsl:call-template>
																	</a>
																</td>
															</xsl:if>
														</xsl:if>
													</tr>
												</tbody>
											</table>
										</div>
									</xsl:for-each>

									<xsl:for-each
										select="Script/Version[(@mode=$versionMode) or (@Baseline_mode=$versionMode)]/RunLog/Testcase[starts-with(@Text,'Globus message')]">
										<div class="glomes" name="glomes">
											<xsl:attribute name="id">
												<xsl:text>glomes</xsl:text>
												<xsl:value-of select="$menuId" />
											</xsl:attribute>
											<table width="95%" border="2">
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
															<xsl:value-of select="@Text" />
														</td>
														<xsl:if test="$isCompare=1">
															<td>
																<xsl:value-of select="@Baseline_Text" />
															</td>
															<xsl:if test="./Defect">
																<td>
																	<a>
																		<xsl:attribute name="id">
																			<xsl:text>def</xsl:text>
																			<xsl:number value="count(preceding::Defect)" />
																		</xsl:attribute>
																		<xsl:attribute name="name">
																			<xsl:text>defect</xsl:text>
																			<xsl:value-of select="./Defect/@id" />
																		</xsl:attribute>

																		<xsl:for-each select="Defect">
																			<xsl:value-of select="@id" />
																			<xsl:text>(</xsl:text>
																			<xsl:value-of select="@name" />
																			<xsl:text>)</xsl:text>
																			<br />
																		</xsl:for-each>

																		<xsl:call-template name="defectButtons">
																			<xsl:with-param name="defectnumber"
																				select="count(preceding::Defect)" />
																		</xsl:call-template>															
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
												<xsl:value-of select="$menuId" />
											</xsl:attribute>
											<table width="95%" border="2">
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
															<xsl:value-of select="@Text" />
														</td>
														<xsl:if test="$isCompare=1">
															<td>
																<xsl:value-of select="@Baseline_Text" />
															</td>
															<xsl:if test="./Defect">
																<td>

																	<a>
																		<xsl:attribute name="id">
																			<xsl:text>def</xsl:text>
																			<xsl:number value="count(preceding::Defect)" />
																		</xsl:attribute>
																		<xsl:attribute name="name">
																			<xsl:text>defect</xsl:text>
																			<xsl:value-of select="./Defect/@id" />
																		</xsl:attribute>

																		<xsl:for-each select="Defect">
																			<xsl:value-of select="@id" />
																			<xsl:text>(</xsl:text>
																			<xsl:value-of select="@name" />
																			<xsl:text>)</xsl:text>
																			<br />
																		</xsl:for-each>

																		<xsl:call-template name="defectButtons">
																			<xsl:with-param name="defectnumber"
																				select="count(preceding::Defect)" />
																		</xsl:call-template>
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

								<xsl:if
									test="Script/Version[(@mode=$versionMode) or (@Baseline_mode=$versionMode)]/VersionFields/descendant::*[@value!='' or @Baseline_value!='']">
									<div class="sbc" name="sbc">
										<xsl:attribute name="id">
											<xsl:text>sbc</xsl:text>
											<xsl:value-of select="$menuId" />
										</xsl:attribute>
										<h3>
											<xsl:text>Snapshot of non-empty fields before commit</xsl:text>
										</h3>

										<xsl:for-each
											select="Script/Version[(@mode=$versionMode) or (@Baseline_mode=$versionMode)]/VersionFields">

											<table width="95%" border="2">
												<thead>
													<tr>
														<th colspan="4" align="center">
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
													<xsl:apply-templates
														select=".//*[@value!='' or @Baseline_value!='']" mode="VersionFields" />
												</tbody>
											</table>
										</xsl:for-each>
									</div>
								</xsl:if>

								<xsl:if
									test="Script/Version[@mode='S']/RunLog/INFO[@Text='Checking output fields']">
									<h3>
										<xsl:text>Checking of output fields</xsl:text>
									</h3>
									<xsl:for-each
										select="Script/Version[@mode='S']/RunLog/INFO[@Text='Checking output fields']">
										<table width="95%" border="2">
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
															<xsl:value-of select="substring-after(@Text,'Output field: ')" />
														</td>
														<td>
															<xsl:value-of select="./Testcase/@Text" />
														</td>
													</tr>
												</xsl:for-each>
											</tbody>
										</table>
									</xsl:for-each>
								</xsl:if>


								<xsl:if
									test="($versionMode!='S') and Script/Version[(@mode='S') or (@Baseline_mode='S')]/VersionFields/descendant::*[@value!='' or @Baseline_value!='']">
									<div class="sac" name="sac">
										<xsl:attribute name="id">
											<xsl:text>sac</xsl:text>
											<xsl:value-of select="$menuId" />
										</xsl:attribute>
										<h3>
											<xsl:text>Snapshot of non-empty fields after commit</xsl:text>
										</h3>
										<xsl:for-each
											select="Script/Version[(@mode='S') or (@Baseline_mode='S')]/VersionFields">

											<table width="95%" border="2">
												<thead>
													<tr>
														<th colspan="4" align="center">
															<xsl:text>Field value settings</xsl:text>
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
													<xsl:apply-templates
														select=".//*[@Baseline_value!='' or @value!='']" mode="VersionFields" />
												</tbody>
											</table>
										</xsl:for-each>
									</div>
								</xsl:if>
							</xsl:for-each>
						</xsl:when>

						<xsl:otherwise>
							<xsl:for-each select="../../../Outputs">
								<div class="sfv" name="sfv">
									<xsl:attribute name="id">
										<xsl:text>sfv</xsl:text>
										<xsl:value-of select="$menuId" />
									</xsl:attribute>
									<h3>
										<xsl:text>Setting field value(s)</xsl:text>
									</h3>

									<xsl:for-each
										select=".//TransactionID[not(preceding-sibling::TransactionID)]">
										<div class="ti" name="ti">
											<xsl:attribute name="id">
												<xsl:text>ti</xsl:text>
												<xsl:value-of select="$menuId" />
											</xsl:attribute>
											<table width="95%" border="2">
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
															<xsl:value-of select="@id" />
														</td>
														<xsl:if test="$isCompare=1">
															<td>
																<xsl:value-of select="@Baseline_id" />
															</td>
														</xsl:if>
													</tr>
												</tbody>
											</table>
										</div>
									</xsl:for-each>

									<xsl:if test=".//SET_FIELD">
										<div class="fvs" name="fvs">
											<xsl:attribute name="id">
												<xsl:text>fvs</xsl:text>
												<xsl:value-of select="$menuId" />
											</xsl:attribute>
											<table width="95%" border="2">
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
													<xsl:apply-templates select=".//SET_FIELD" />
												</tbody>
											</table>
										</div>
									</xsl:if>

									<xsl:for-each select=".//Testcase[starts-with(@Text,'Commit')]">
										<xsl:if
											test="preceding-sibling::Testcase[starts-with(@Text,'Override reason')]">
											<div class="or" name="or">
												<xsl:attribute name="id">
													<xsl:text>or</xsl:text>
													<xsl:value-of select="$menuId" />
												</xsl:attribute>
												<table width="95%" border="2">
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
														<xsl:for-each
															select="preceding-sibling::Testcase[starts-with(@Text,'Override reason')]">
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
																	<xsl:value-of select="@Text" />
																</td>
																<xsl:if test="$isCompare=1">
																	<td>
																		<xsl:value-of select="@Baseline_Text" />
																	</td>
																	<xsl:if test="./Defect">
																		<td>

																			<a>
																				<xsl:attribute name="id">
																					<xsl:text>def</xsl:text>
																					<xsl:number value="count(preceding::Defect)" />
																				</xsl:attribute>
																				<xsl:attribute name="name">
																					<xsl:text>defect</xsl:text>
																					<xsl:value-of select="./Defect/@id" />
																				</xsl:attribute>

																				<xsl:for-each select="Defect">
																					<xsl:value-of select="@id" />
																					<xsl:text>(</xsl:text>
																					<xsl:value-of select="@name" />
																					<xsl:text>)</xsl:text>
																					<br />
																				</xsl:for-each>

																				<xsl:call-template name="defectButtons">
																					<xsl:with-param name="defectnumber"
																						select="count(preceding::Defect)" />
																				</xsl:call-template>
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
										<xsl:if test="../../../VersionFields//*[@errorText!='']">
											<div class="em" name="em">
												<xsl:attribute name="id">
													<xsl:text>em</xsl:text>
													<xsl:value-of select="$menuId" />
												</xsl:attribute>
												<table width="95%" border="2">
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
														<xsl:for-each select="../../../VersionFields//*[@errorText!='']">
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
																			<xsl:value-of select="@fieldNumber1" />
																		</xsl:when>
																		<xsl:otherwise>
																			<xsl:value-of select="@Baseline_fieldNumber1" />
																		</xsl:otherwise>
																	</xsl:choose>
																	<xsl:for-each select="ancestor::Value">
																		<xsl:text>.</xsl:text>
																		<xsl:choose>
																			<xsl:when test="@number!=''">
																				<xsl:value-of select="@number" />
																			</xsl:when>
																			<xsl:otherwise>
																				<xsl:value-of select="@Baseline_number" />
																			</xsl:otherwise>
																		</xsl:choose>
																	</xsl:for-each>
																	<xsl:text>) </xsl:text>
																	<xsl:value-of select="name()" />
																</td>
																<td>
																	<xsl:value-of select="@errorText" />
																</td>
																<xsl:if test="$isCompare=1">
																	<td>
																		<xsl:value-of select="@Baseline_errorText" />
																	</td>
																	<xsl:if test="./Defect">
																		<td>

																			<a>
																				<xsl:attribute name="id">
																					<xsl:text>def</xsl:text>
																					<xsl:number value="count(preceding::Defect)" />
																				</xsl:attribute>
																				<xsl:attribute name="name">
																					<xsl:text>defect</xsl:text>
																					<xsl:value-of select="./Defect/@id" />
																				</xsl:attribute>

																				<xsl:for-each select="Defect">
																					<xsl:value-of select="@id" />
																					<xsl:text>(</xsl:text>
																					<xsl:value-of select="@name" />
																					<xsl:text>)</xsl:text>
																					<br />
																				</xsl:for-each>

																				<xsl:call-template name="defectButtons">
																					<xsl:with-param name="defectnumber"
																						select="count(preceding::Defect)" />
																				</xsl:call-template>
																				
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

										<xsl:if
											test="preceding-sibling::INFO[starts-with(@Text,'Error message')]">
											<div class="erdc" name="erdc">
												<xsl:attribute name="id">
													<xsl:text>erdc</xsl:text>
													<xsl:value-of select="$menuId" />
												</xsl:attribute>
												<table width="95%" border="2">
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
														<xsl:for-each
															select="preceding-sibling::INFO[starts-with(@Text,'Error message')]">
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
																	<xsl:value-of select="@Text" />
																</td>
																<xsl:if test="$isCompare=1">
																	<td>
																		<xsl:value-of select="@Baseline_Text" />
																	</td>
																	<xsl:if test="./Defect">
																		<td>

																			<a>
																				<xsl:attribute name="id">
																					<xsl:text>def</xsl:text>
																					<xsl:number value="count(preceding::Defect)" />
																				</xsl:attribute>
																				<xsl:attribute name="name">
																					<xsl:text>defect</xsl:text>
																					<xsl:value-of select="./Defect/@id" />
																				</xsl:attribute>

																				<xsl:for-each select="Defect">
																					<xsl:value-of select="@id" />
																					<xsl:text>(</xsl:text>
																					<xsl:value-of select="@name" />
																					<xsl:text>)</xsl:text>
																					<br />
																				</xsl:for-each>

																				<xsl:call-template name="defectButtons">
																					<xsl:with-param name="defectnumber"
																						select="count(preceding::Defect)" />
																				</xsl:call-template>
																				
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
										<div class="com" name="com">
											<xsl:attribute name="id">
												<xsl:text>com</xsl:text>
												<xsl:value-of select="$menuId" />
											</xsl:attribute>
											<table width="95%" border="2">
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
															<xsl:value-of select="@Text" />
														</td>
														<xsl:if test="$isCompare=1">
															<td>
																<xsl:value-of select="@Baseline_Text" />
															</td>
															<xsl:if test="./Defect">
																<td>

																	<a>
																		<xsl:attribute name="id">
																			<xsl:text>def</xsl:text>
																			<xsl:number value="count(preceding::Defect)" />
																		</xsl:attribute>
																		<xsl:attribute name="name">
																			<xsl:text>defect</xsl:text>
																			<xsl:value-of select="./Defect/@id" />
																		</xsl:attribute>

																		<xsl:for-each select="Defect">
																			<xsl:value-of select="@id" />
																			<xsl:text>(</xsl:text>
																			<xsl:value-of select="@name" />
																			<xsl:text>)</xsl:text>
																			<br />
																		</xsl:for-each>

																		<xsl:call-template name="defectButtons">
																			<xsl:with-param name="defectnumber"
																				select="count(preceding::Defect)" />
																		</xsl:call-template>
																	</a>
																</td>
															</xsl:if>
														</xsl:if>
													</tr>
												</tbody>
											</table>
										</div>
									</xsl:for-each>

									<xsl:for-each
										select="Script/Version[(@mode=ancestor::Sequence/Inputs/InputMessage/FieldValues/@Mode) or (@Baseline_mode=ancestor::Sequence/Inputs/InputMessage/FieldValues/@Baseline_Mode)]/RunLog/Testcase[starts-with(@Text,'Globus message')]">
										<div class="glomes" name="glomes">
											<xsl:attribute name="id">
												<xsl:text>glomes</xsl:text>
												<xsl:value-of select="$menuId" />
											</xsl:attribute>
											<table width="95%" border="2">
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
															<xsl:value-of select="@Text" />
														</td>
														<xsl:if test="$isCompare=1">
															<td>
																<xsl:value-of select="@Baseline_Text" />
															</td>
															<xsl:if test="./Defect">
																<td>

																	<a>
																		<xsl:attribute name="id">
																			<xsl:text>def</xsl:text>
																			<xsl:number value="count(preceding::Defect)" />
																		</xsl:attribute>
																		<xsl:attribute name="name">
																			<xsl:text>defect</xsl:text>
																			<xsl:value-of select="./Defect/@id" />
																		</xsl:attribute>

																		<xsl:for-each select="Defect">
																			<xsl:value-of select="@id" />
																			<xsl:text>(</xsl:text>
																			<xsl:value-of select="@name" />
																			<xsl:text>)</xsl:text>
																			<br />
																		</xsl:for-each>

																		<xsl:call-template name="defectButtons">
																			<xsl:with-param name="defectnumber"
																				select="count(preceding::Defect)" />
																		</xsl:call-template>
																		
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
												<xsl:value-of select="$menuId" />
											</xsl:attribute>
											<table width="95%" border="2">
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
															<xsl:value-of select="@Text" />
														</td>
														<xsl:if test="$isCompare=1">
															<td>
																<xsl:value-of select="@Baseline_Text" />
															</td>
															<xsl:if test="./Defect">
																<td>

																	<a>
																		<xsl:attribute name="id">
																			<xsl:text>def</xsl:text>
																			<xsl:number value="count(preceding::Defect)" />
																		</xsl:attribute>
																		<xsl:attribute name="name">
																			<xsl:text>defect</xsl:text>
																			<xsl:value-of select="./Defect/@id" />
																		</xsl:attribute>

																		<xsl:for-each select="Defect">
																			<xsl:value-of select="@id" />
																			<xsl:text>(</xsl:text>
																			<xsl:value-of select="@name" />
																			<xsl:text>)</xsl:text>
																			<br />
																		</xsl:for-each>

																		<xsl:call-template name="defectButtons">
																			<xsl:with-param name="defectnumber"
																				select="count(preceding::Defect)" />
																		</xsl:call-template>
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
								<xsl:if
									test="Script/Version[(@mode=ancestor::Sequence/Inputs/InputMessage/FieldValues/@Mode) or (@Baseline_mode=ancestor::Sequence/Inputs/InputMessage/FieldValues/@Baseline_Mode)]/VersionFields/descendant::*[@value!='' or @Baseline_value!='']">
									<div class="sbc" name="sbc">
										<xsl:attribute name="id">
											<xsl:text>sbc</xsl:text>
											<xsl:value-of select="$menuId" />
										</xsl:attribute>
										<h3>
											<xsl:text>Snapshot of non-empty fields before commit</xsl:text>
										</h3>

										<xsl:for-each
											select="Script/Version[(@mode=ancestor::Sequence/Inputs/InputMessage/FieldValues/@Mode) or (@Baseline_mode=ancestor::Sequence/Inputs/InputMessage/FieldValues/@Baseline_Mode)]/VersionFields">

											<table width="95%" border="2">
												<thead>
													<tr>
														<th colspan="4" align="center">
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
													<xsl:apply-templates
														select=".//*[@Baseline_value!='' or @value!='']" mode="VersionFields" />
												</tbody>
											</table>
										</xsl:for-each>
									</div>
								</xsl:if>

								<xsl:if
									test="Script/Version[@mode='S']/RunLog/INFO[@Text='Checking output fields']">
									<h3>
										<xsl:text>Checking of output fields</xsl:text>
									</h3>
									<xsl:for-each
										select="Script/Version[@mode='S']/RunLog/INFO[@Text='Checking output fields']">
										<table width="95%" border="2">
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
															<xsl:value-of select="substring-after(@Text,'Output field: ')" />
														</td>
														<td>
															<xsl:value-of select="./Testcase/@Text" />
														</td>
													</tr>
												</xsl:for-each>
											</tbody>
										</table>
									</xsl:for-each>
								</xsl:if>

								<xsl:if
									test="Script/Version[(@mode='S') or (@Baseline_mode='S')]/VersionFields/descendant::*[@value!='' or @Baseline_value!=''] and (ancestor::Sequence/Inputs/InputMessage/FieldValues/@Mode!='S' or ancestor::Sequence/Inputs/InputMessage/FieldValues/@Baseline_Mode!='S')">
									<div class="sac" name="sac">
										<xsl:attribute name="id">
											<xsl:text>sac</xsl:text>
											<xsl:value-of select="$menuId" />
										</xsl:attribute>
										<h3>
											<xsl:text>Snapshot of non-empty fields after commit</xsl:text>
										</h3>
										<xsl:for-each
											select="Script/Version[(@mode='S') or (@Baseline_mode='S')]/VersionFields">

											<table width="95%" border="2">
												<thead>
													<tr>
														<th colspan="4" align="center">
															<xsl:text>Field value settings</xsl:text>
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
													<xsl:apply-templates
														select=".//*[@Baseline_value!='' or @value!='']" mode="VersionFields" />
												</tbody>
											</table>
										</xsl:for-each>
									</div>
								</xsl:if>
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
				</div>
				<a href="#main">
					<span style="text-align: right">Top</span>
				</a>
				<hr />
			</xsl:for-each>
		</xsl:if>

		<xsl:if test=".//EnquiryData">
			<xsl:for-each select="./Inputs/InputMessage/EnquiryData">
				<xsl:variable name="menuId">
					<xsl:value-of select="generate-id(.)" />
				</xsl:variable>

				<div style="margin-left:15px">
					<xsl:attribute name="onmouseover">
						<xsl:text>menuInJump('menu</xsl:text>
						<xsl:value-of select="$menuId" />
						<xsl:text>');</xsl:text>
					</xsl:attribute>
					<xsl:attribute name="ondblclick">
						<xsl:text>bookmarkSequence('menu</xsl:text>
						<xsl:value-of select="$menuId" />
						<xsl:text>');</xsl:text>
					</xsl:attribute>

					<a>
						<xsl:attribute name="id">
							<xsl:value-of select="$menuId" />
						</xsl:attribute>
					</a>

					<h2>
						<xsl:value-of select="$seqNo" />
						<xsl:text>: Enquiry </xsl:text>
						<xsl:choose>
							<xsl:when test="@name!=''">
								<xsl:value-of select="@name" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="@Baseline_name" />
							</xsl:otherwise>
						</xsl:choose>
						<xsl:if test="@usergroup or @Baseline_usergroup">
							<xsl:text> with </xsl:text>
							<xsl:choose>
								<xsl:when test="@usergroup!=''">
									<xsl:value-of select="@usergroup" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="@Baseline_usergroup" />
								</xsl:otherwise>
							</xsl:choose>
							<xsl:text> user</xsl:text>
						</xsl:if>
						<xsl:if test="@resultSelection or @Baseline_resultSelection">
							<xsl:text>, result selection is </xsl:text>
							<xsl:choose>
								<xsl:when test="@resultSelection!=''">
									<xsl:value-of select="@resultSelection" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="@Baseline_resultSelection" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:if>
					</h2>

					<xsl:apply-templates select="." mode="SelectionResult" />
					<div class="rs" name="rs">
						<xsl:attribute name="id">
							<xsl:text>rs</xsl:text>
							<xsl:value-of select="generate-id(.)" />
						</xsl:attribute>
						<xsl:choose>
							<xsl:when test="not(ancestor::Sequence/Outputs/Iteration)">
								<h3>Result(s):</h3>
								<xsl:if
									test="ancestor::Sequence/Outputs/Script/SelectionResult/Testcase[contains(@Text,'no result!') or contains(@Baseline_Text,'no result!') or contains(@Text,'No records!') or contains(@Baseline_Text,'No records!')]">

									<table width="95%" border="2" style="table-layout:auto;">
										<thead>
											<tr>
												<th colspan="2">Enquiry message</th>
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
													<xsl:if
														test="ancestor::Sequence/Outputs/Script/SelectionResult/Testcase[@Text='Result selection returned no result!']">
														Result selection returned no result!
													</xsl:if>
													<xsl:if
														test="ancestor::Sequence/Outputs/Script/Testcase[@Text='Script stopped (No records!)!']">
														Result selection returned no result!
													</xsl:if>
													<xsl:if
														test="ancestor::Sequence/Outputs/Script/SelectionResult/Testcase[@Text='Expecting one or more rows! Result selection returned no result!']">
														Expecting one or more rows! Result selection returned no
														result!
													</xsl:if>
												</td>
												<xsl:if test="$isCompare=1">
													<td>
														<xsl:if
															test="ancestor::Sequence/Outputs/Script/SelectionResult/Testcase[@Baseline_Text='Result selection returned no result!']">
															Result selection returned no result!
														</xsl:if>
														<xsl:if
															test="ancestor::Sequence/Outputs/Script/Testcase[@Baseline_Text='Script stopped (No records!)!']">
															Result selection returned no result!
														</xsl:if>
														<xsl:if
															test="ancestor::Sequence/Outputs/Script/SelectionResult/Testcase[@Baseline_Text='Expecting one or more rows! Result selection returned no result!']">
															Expecting one or more rows! Result selection returned no
															result!
														</xsl:if>
													</td>
												</xsl:if>
											</tr>
										</tbody>
									</table>
								</xsl:if>
								<xsl:if
									test="ancestor::Sequence/Outputs/Script/SelectionResult/Row/Field">
									<xsl:for-each
										select="ancestor::Sequence/Outputs/Script/SelectionResult">

										<xsl:for-each select="Row">
											<xsl:if test="position() = 1">
												<xsl:value-of select="substring-before(@Text,'_______')" />
											</xsl:if>
											<table width="95%" border="2" style="table-layout:auto;">
												<thead>
													<tr style="height:28px">
														<xsl:if test="$isCompare=1">
															<xsl:if test="count(Field[not(@Row)])&gt;0">
																<th style="width:70px" />
															</xsl:if>
														</xsl:if>
														<xsl:for-each select="Field[not(@Row)]">
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
																<xsl:if
																	test="@Name!='' and @Baseline_Name!='' and @Baseline_Name!=@Name">
																	<xsl:value-of select="@Name" />
																	<xsl:text>/</xsl:text>
																	<xsl:value-of select="@Baseline_Name" />
																</xsl:if>
																<xsl:if
																	test="(@Name!='' and @Baseline_Name!='' and @Baseline_Name=@Name) or (@Name!='' and (@Baseline_Name='' or not(@Baseline_Name)))">
																	<xsl:value-of select="@Name" />
																</xsl:if>
																<xsl:if test="@Name='' or not(@Name)">
																	<xsl:value-of select="@Baseline_Name" />
																</xsl:if>
															</th>
														</xsl:for-each>
													</tr>
												</thead>
												<tbody>
													<tr>
														<xsl:if test="$isCompare=1">
															<xsl:if test="count(Field[not(@Row)])&gt;0">
																<th style="width:70px">
																	<xsl:text>Value</xsl:text>
																	<hr />
																	<xsl:text>Baseline value</xsl:text>
																</th>
															</xsl:if>
														</xsl:if>
														<xsl:for-each select="Field[not(@Row)]">
															<td>
																<xsl:if test="$isCompare=1">
																	<xsl:if
																		test="contains(@TestManager_DiffType,'Changed') and @Name=@Baseline_Name">
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
																	<xsl:value-of select="@Value" />
																</xsl:if>
																<xsl:if test="@Expected and not( @Expected= '')">
																	, exp:
																	<xsl:value-of select="@Expected" />
																</xsl:if>
																<xsl:if test="Testcase[@Text='Field check failed']">
																	<strong>Failed!</strong>
																</xsl:if>
																<xsl:if test="$isCompare=1">
																	<hr />
																	<xsl:if test="not(@Baseline_Value)">
																		<xsl:text>&#xA0;</xsl:text>
																	</xsl:if>
																	<xsl:if test="@Baseline_Value=''">
																		<xsl:text>''</xsl:text>
																	</xsl:if>
																	<xsl:if test="@Baseline_Value!=''">
																		<xsl:value-of select="@Baseline_Value" />
																	</xsl:if>
																	<xsl:if
																		test="@Baseline_Expected and not( @Baseline_Expected= '')">
																		, exp:
																		<xsl:value-of select="@Baseline_Expected" />
																	</xsl:if>
																	<xsl:if test="Testcase[@Baseline_Text='Field check failed']">
																		<strong>Failed!</strong>
																	</xsl:if>
																</xsl:if>
															</td>
														</xsl:for-each>
													</tr>
													<xsl:if test=".//Defect">
														<tr>
															<th>Defects</th>
															<xsl:for-each select="Field[not(@Row)]">
																<td>

																	<xsl:if test="$isCompare=1">
																		<xsl:if
																			test="contains(@TestManager_DiffType,'Changed') and @Name=@Baseline_Name">
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
																		<a>
																			<xsl:attribute name="id">
																				<xsl:text>def</xsl:text>
																				<xsl:number value="count(preceding::Defect)" />
																			</xsl:attribute>
																			<xsl:attribute name="name">
																				<xsl:text>defect</xsl:text>
																				<xsl:value-of select="./Defect/@id" />
																			</xsl:attribute>

																			<xsl:for-each select="Defect">
																				<xsl:value-of select="@id" />
																				<xsl:text>(</xsl:text>
																				<xsl:value-of select="@name" />
																				<xsl:text>)</xsl:text>
																				<br />
																			</xsl:for-each>

																			<xsl:call-template name="defectButtons">
																				<xsl:with-param name="defectnumber"
																					select="count(preceding::Defect)" />
																			</xsl:call-template>
																		</a>
																	</xsl:if>
																</td>
															</xsl:for-each>
														</tr>
													</xsl:if>
												</tbody>
											</table>
										</xsl:for-each>
									</xsl:for-each>
								</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:variable name="iter" select="../@iteration" />
								<h3>Result(s):</h3>
								<xsl:if
									test="ancestor::Sequence/Outputs/Iteration[@number=$iter]/Script/SelectionResult/Testcase[contains(@Text,'no result!') or contains(@Baseline_Text,'no result!') or contains(@Text,'No records!') or contains(@Baseline_Text,'No records!')]">

									<table width="95%" border="2" style="table-layout:auto;">
										<thead>
											<tr>
												<th colspan="2">Enquiry message</th>
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
													<xsl:if
														test="ancestor::Sequence/Outputs/Iteration[@number=$iter]/Script/SelectionResult/Testcase[@Text='Result selection returned no result!']">
														Result selection returned no result!
													</xsl:if>
													<xsl:if
														test="ancestor::Sequence/Outputs/Iteration[@number=$iter]/Script/Testcase[@Text='Script stopped (No records!)!']">
														Result selection returned no result!
													</xsl:if>
													<xsl:if
														test="ancestor::Sequence/Outputs/Iteration[@number=$iter]/Script/SelectionResult/Testcase[@Text='Expecting one or more rows! Result selection returned no result!']">
														Expecting one or more rows! Result selection returned no
														result!
													</xsl:if>
												</td>
												<xsl:if test="$isCompare=1">
													<td>
														<xsl:if
															test="ancestor::Sequence/Outputs/Iteration[@number=$iter]/Script/SelectionResult/Testcase[@Baseline_Text='Result selection returned no result!']">
															Result selection returned no result!
														</xsl:if>
														<xsl:if
															test="ancestor::Sequence/Outputs/Iteration[@number=$iter]/Script/Testcase[@Baseline_Text='Script stopped (No records!)!']">
															Result selection returned no result!
														</xsl:if>
														<xsl:if
															test="ancestor::Sequence/Outputs/Iteration[@number=$iter]/Script/SelectionResult/Testcase[@Baseline_Text='Expecting one or more rows! Result selection returned no result!']">
															Expecting one or more rows! Result selection returned no
															result!
														</xsl:if>
													</td>
												</xsl:if>
											</tr>
										</tbody>
									</table>
								</xsl:if>

								<xsl:if
									test="ancestor::Sequence/Outputs/Iteration[@number=$iter]/Script/SelectionResult/Row/Field">
									<xsl:for-each
										select="ancestor::Sequence/Outputs/Iteration[@number=$iter]/Script/SelectionResult">

										<xsl:for-each select="Row">
											<xsl:if test="position() = 1">
												<xsl:value-of select="substring-before(@Text,'_______')" />
											</xsl:if>
											<table width="95%" border="2" style="table-layout:auto;">
												<thead>
													<tr>
														<xsl:if test="$isCompare=1">
															<xsl:if test="count(Field[not(@Row)])&gt;0">
																<th style="width:70px" />
															</xsl:if>
														</xsl:if>
														<xsl:for-each select="Field[not(@Row)]">
															<th style="border-bottom-width:5;">
																<xsl:if test="@Name!=''">
																	<xsl:value-of select="@Name" />
																</xsl:if>
																<xsl:if test="@Name='' or not(@Name)">
																	<xsl:value-of select="@Baseline_Name" />
																</xsl:if>
															</th>
														</xsl:for-each>
													</tr>
												</thead>
												<tbody>
													<tr>
														<xsl:if test="$isCompare=1">
															<xsl:if test="count(Field[not(@Row)])&gt;0">
																<td style="width:70px">
																	<xsl:text>Value</xsl:text>
																	<hr />
																	<xsl:text>Baseline value</xsl:text>
																</td>
															</xsl:if>
														</xsl:if>
														<xsl:for-each select="Field[not(@Row)]">
															<td>
																<xsl:if test="$isCompare=1">
																	<xsl:if
																		test="contains(@TestManager_DiffType,'Changed') and @Name=@Baseline_Name">
																		<xsl:attribute name="class">changed</xsl:attribute>
																	</xsl:if>
																	<xsl:if test="contains(@TestManager_DiffType,'Added')">
																		<xsl:attribute name="class">added</xsl:attribute>
																	</xsl:if>
																	<xsl:if test="contains(@TestManager_DiffType,'Removed')">
																		<xsl:attribute name="class">removed</xsl:attribute>
																	</xsl:if>
																</xsl:if>
																<xsl:if test="not(@Value)">
																	<xsl:text>&#xA0;</xsl:text>
																</xsl:if>
																<xsl:if test="@Value=''">
																	<xsl:text>''</xsl:text>
																</xsl:if>
																<xsl:if test="@Value!=''">
																	<xsl:value-of select="@Value" />
																</xsl:if>
																<xsl:if test="@Expected and not( @Expected= '')">
																	, exp:
																	<xsl:value-of select="@Expected" />
																</xsl:if>
																<xsl:if test="Testcase[@Text='Field check failed']">
																	<strong>Failed!</strong>
																</xsl:if>
																<xsl:if test="$isCompare=1">
																	<hr />
																	<xsl:if test="not(@Baseline_Value)">
																		<xsl:text>&#xA0;</xsl:text>
																	</xsl:if>
																	<xsl:if test="@Baseline_Value=''">
																		<xsl:text>''</xsl:text>
																	</xsl:if>
																	<xsl:if test="@Baseline_Value!=''">
																		<xsl:value-of select="@Baseline_Value" />
																	</xsl:if>
																	<xsl:if
																		test="@Baseline_Expected and not( @Baseline_Expected= '')">
																		, exp:
																		<xsl:value-of select="@Baseline_Expected" />
																	</xsl:if>
																	<xsl:if test="Testcase[@Baseline_Text='Field check failed']">
																		<strong>Failed!</strong>
																	</xsl:if>
																</xsl:if>
															</td>
														</xsl:for-each>
													</tr>
												</tbody>
											</table>
										</xsl:for-each>
									</xsl:for-each>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</div>
				</div>
				<a href="#main">
					<span style="text-align: right">Top</span>
				</a>
				<hr />
			</xsl:for-each>
		</xsl:if>

		<xsl:if test=".//FieldValues[@Interface or @Baseline_Interface]">

			<xsl:for-each select="./Inputs/InputMessage">
				<xsl:variable name="menuId">
					<xsl:value-of select="generate-id(./FieldValues)" />
				</xsl:variable>

				<xsl:variable name="itIdInterface">
					<xsl:choose>
						<xsl:when test="./@iteration!=''">
							<xsl:value-of select="./@iteration" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="./@Baseline_iteration" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<div style="margin-left:15px">
					<xsl:attribute name="onmouseover">
						<xsl:text>menuInJump('menu</xsl:text>
						<xsl:value-of select="$menuId" />
						<xsl:text>');</xsl:text>
					</xsl:attribute>
					<xsl:attribute name="ondblclick">
						<xsl:text>bookmarkSequence('menu</xsl:text>
						<xsl:value-of select="$menuId" />
						<xsl:text>');</xsl:text>
					</xsl:attribute>
					<a>
						<xsl:attribute name="id">
							<xsl:value-of select="$menuId" />
						</xsl:attribute>
					</a>

					<h2>
						<xsl:value-of select="$seqNo" />
						<xsl:text>: </xsl:text>
						<xsl:choose>
							<xsl:when test="./FieldValues/@version!=''">
								<xsl:value-of select="./FieldValues/@version" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="./FieldValues/@Baseline_version" />
							</xsl:otherwise>
						</xsl:choose>

						<xsl:if
							test=".//FieldValues[@Interface='I' or @Baseline_Interface='I']">
							<xsl:text> in-coming interface message</xsl:text>
						</xsl:if>

						<xsl:if
							test="./FieldValues/@Interface='O' or ./FieldValues/@Baseline_Interface='O'">
							<xsl:text> out-going interface message</xsl:text>
						</xsl:if>
					</h2>

					<div class="im" name="im">
						<xsl:attribute name="id">
							<xsl:text>im</xsl:text>
							<xsl:value-of select="generate-id(.)" />
						</xsl:attribute>
						<xsl:if
							test=".//FieldValues[@Interface='I' or @Baseline_Interface='I']">
							<xsl:apply-templates select=".//FieldValues"
								mode="Interface" />
						</xsl:if>

						<xsl:if
							test=".//FieldValues[@Interface='O' or @Baseline_Interface='O']">
							<xsl:for-each select="../../Outputs">
								<!--If the Interface is not iteration -->
								<xsl:choose>
									<xsl:when test="not(.//Iteration)">
										<xsl:for-each select=".//Message[not(./Message)]">
											<xsl:apply-templates select="." />
										</xsl:for-each>
									</xsl:when>

									<!--If the Interface is iteration! -->
									<xsl:otherwise>
										<xsl:for-each
											select=".//Iteration[@number=$itIdInterface or @Baseline_number=$itIdInterface]">
											<xsl:apply-templates select=".//Message[not(./Message)]" />
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
				<hr />
			</xsl:for-each>
		</xsl:if>

		<xsl:if test=".//REPORT">
			<xsl:for-each select=".//Outputs[Script/REPORT]">
				<xsl:variable name="menuId">
					<xsl:value-of select="generate-id(.)" />
				</xsl:variable>

				<div style="margin-left:15px">
					<xsl:attribute name="onmouseover">
						<xsl:text>menuInJump('menu</xsl:text>
						<xsl:value-of select="$menuId" />
						<xsl:text>');</xsl:text>
					</xsl:attribute>
					<xsl:attribute name="ondblclick">
						<xsl:text>bookmarkSequence('menu</xsl:text>
						<xsl:value-of select="$menuId" />
						<xsl:text>');</xsl:text>
					</xsl:attribute>
					<a>
						<xsl:attribute name="id">
							<xsl:value-of select="$menuId" />
						</xsl:attribute>
					</a>

					<h2>
						<xsl:value-of select="$seqNo" />
						<xsl:text>: Report:</xsl:text>
					</h2>

					<div class="rep" name="rep">
						<xsl:attribute name="id">
							<xsl:text>rep</xsl:text>
							<xsl:value-of select="generate-id(.)" />
						</xsl:attribute>
						<table width="95%" border="2">
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
												<xsl:value-of select="@Text"
													disable-output-escaping="yes" />
											</pre>
										</td>
										<xsl:if test="$isCompare=1">
											<td>
												<pre>
													<xsl:value-of select="@Baseline_Text"
														disable-output-escaping="yes" />
												</pre>
											</td>
											<xsl:if test="./Defect">
												<td>

													<a>
														<xsl:attribute name="id">
															<xsl:text>def</xsl:text>
															<xsl:number value="count(preceding::Defect)" />
														</xsl:attribute>
														<xsl:attribute name="name">
															<xsl:text>defect</xsl:text>
															<xsl:value-of select="./Defect/@id" />
														</xsl:attribute>

														<xsl:for-each select="Defect">
															<xsl:value-of select="@id" />
															<xsl:text>(</xsl:text>
															<xsl:value-of select="@name" />
															<xsl:text>)</xsl:text>
															<br />
														</xsl:for-each>

														<xsl:call-template name="defectButtons">
															<xsl:with-param name="defectnumber"
																select="count(preceding::Defect)" />
														</xsl:call-template>
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
				<hr />
			</xsl:for-each>
		</xsl:if>
	</xsl:template>

	<xsl:template match="FieldValues" mode="RunLog">
		<br />

		<table width="95%" border="2">
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
				<xsl:apply-templates select="./*" mode="FieldValues" />
			</tbody>
		</table>
	</xsl:template>

	<xsl:template match="*" mode="FieldValues">
		<xsl:choose>
			<xsl:when test="@multivalue='yes' or @Baseline_multivalue='yes'">
				<xsl:for-each select="./item">
					<xsl:apply-templates mode="FieldValues" />
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<tr>
					<td>
						<xsl:value-of select="name()" />
					</td>
					<td>
						<xsl:value-of select="@Value" />
					</td>
					<td>
						<xsl:value-of select="@Expected" />
					</td>
					<xsl:if test="$isCompare=1">
						<td>
							<xsl:value-of select="@Baseline_Value" />
						</td>
						<td>
							<xsl:value-of select="@Baseline_Expected" />
						</td>
					</xsl:if>
				</tr>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*[@Baseline_value!='' or @value!='']"
		mode="VersionFields">
		<xsl:choose>
			<xsl:when test="@multivalue='yes' or @Baseline_multivalue='yes'">
				<xsl:for-each select="./Value">
					<xsl:apply-templates mode="VersionFields" />
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
								<xsl:value-of select="@fieldNumber1" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="@Baseline_fieldNumber1" />
							</xsl:otherwise>
						</xsl:choose>
						<xsl:for-each select="ancestor::Value">
							<xsl:text>.</xsl:text>
							<xsl:choose>
								<xsl:when test="@number!=''">
									<xsl:value-of select="@number" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="@Baseline_number" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
						<xsl:text>) </xsl:text>
						<xsl:value-of select="name()" />
					</td>
					<xsl:if test="not(contains(@TestManager_DiffType,'Changed'))">
						<td>
							<xsl:choose>
								<xsl:when test="@desc1!=''">
									<xsl:choose>
										<xsl:when test="@value=@desc1">
											<xsl:value-of select="@desc1" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="@desc1" />
											<xsl:text> ('</xsl:text>
											<xsl:value-of select="@value" />
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
											<xsl:value-of select="@desc1" />
											<xsl:text> ('</xsl:text>
											<xsl:value-of select="@value" />
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
											<xsl:value-of select="@Baseline_desc1" />
										</xsl:if>
										<xsl:if test="@Baseline_value!=@Baseline_desc1">
											<xsl:value-of select="@Baseline_desc1" />
											<xsl:text> ('</xsl:text>
											<xsl:value-of select="@Baseline_value" />
											<xsl:text>')</xsl:text>
										</xsl:if>
									</xsl:when>
									<xsl:otherwise>
										<xsl:if test="@Baseline_value=@Baseline_desc1">
											<xsl:text>''</xsl:text>
										</xsl:if>
										<xsl:if test="@Baseline_value!=@Baseline_desc1">
											<xsl:value-of select="@Baseline_desc1" />
											<xsl:text> ('</xsl:text>
											<xsl:value-of select="@Baseline_value" />
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
											<xsl:number value="count(preceding::Defect)" />
										</xsl:attribute>
										<xsl:attribute name="name">
											<xsl:text>defect</xsl:text>
											<xsl:value-of select="./Defect/@id" />
										</xsl:attribute>

										<xsl:for-each select="Defect">
											<xsl:value-of select="@id" />
											<xsl:text>(</xsl:text>
											<xsl:value-of select="@name" />
											<xsl:text>)</xsl:text>
											<br />
										</xsl:for-each>

										<xsl:call-template name="defectButtons">
											<xsl:with-param name="defectnumber"
												select="count(preceding::Defect)" />
										</xsl:call-template>										
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
										<xsl:value-of select="@desc1" />
									</xsl:if>
									<xsl:if test="@value!=@desc1">
										<xsl:value-of select="@desc1" />
										<xsl:text> ('</xsl:text>
										<xsl:value-of select="@value" />
										<xsl:text>')</xsl:text>
									</xsl:if>
								</xsl:when>
								<xsl:otherwise>
									<xsl:if test="@value=@desc1">
										<xsl:text>''</xsl:text>
									</xsl:if>
									<xsl:if test="@value!=@desc1">
										<xsl:value-of select="@desc1" />
										<xsl:text> ('</xsl:text>
										<xsl:value-of select="@value" />
										<xsl:text>')</xsl:text>
									</xsl:if>
								</xsl:otherwise>
							</xsl:choose>

							<xsl:if test="@desc2!=@Baseline_desc2">
								<br />
								<xsl:text>desc2: </xsl:text>
								<xsl:choose>
									<xsl:when test="@desc2=''">
										<xsl:text>''</xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="@desc2" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if>
							<xsl:if test="@errorText!=@Baseline_errorText">
								<br />
								<xsl:text>errorText: </xsl:text>
								<xsl:choose>
									<xsl:when test="@errorText=''">
										<xsl:text>''</xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="@errorText" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if>
							<xsl:if test="@fieldDescription!=@Baseline_fieldDescription">
								<br />
								<xsl:text>fieldDescription: </xsl:text>
								<xsl:choose>
									<xsl:when test="@fieldDescription=''">
										<xsl:text>''</xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="@fieldDescription" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if>
						</td>
						<td>
							<xsl:choose>
								<xsl:when test="@Baseline_desc1!=''">
									<xsl:if test="@Baseline_value=@Baseline_desc1">
										<xsl:value-of select="@Baseline_desc1" />
									</xsl:if>
									<xsl:if test="@Baseline_value!=@Baseline_desc1">
										<xsl:value-of select="@Baseline_desc1" />
										<xsl:text> ('</xsl:text>
										<xsl:value-of select="@Baseline_value" />
										<xsl:text>')</xsl:text>
									</xsl:if>
								</xsl:when>
								<xsl:otherwise>
									<xsl:if test="@Baseline_value=@Baseline_desc1">
										<xsl:text>''</xsl:text>
									</xsl:if>
									<xsl:if test="@Baseline_value!=@Baseline_desc1">
										<xsl:value-of select="@Baseline_desc1" />
										<xsl:text> ('</xsl:text>
										<xsl:value-of select="@Baseline_value" />
										<xsl:text>')</xsl:text>
									</xsl:if>
								</xsl:otherwise>
							</xsl:choose>

							<xsl:if test="@desc2!=@Baseline_desc2">
								<br />
								<xsl:text>desc2: </xsl:text>
								<xsl:choose>
									<xsl:when test="@Baseline_desc2=''">
										<xsl:text>''</xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="@Baseline_desc2" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if>
							<xsl:if test="@errorText!=@Baseline_errorText">
								<br />
								<xsl:text>errorText: </xsl:text>
								<xsl:choose>
									<xsl:when test="@Baseline_errorText=''">
										<xsl:text>''</xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="@Baseline_errorText" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if>
							<xsl:if test="@fieldDescription!=@Baseline_fieldDescription">
								<br />
								<xsl:text>fieldDescription: </xsl:text>
								<xsl:choose>
									<xsl:when test="@Baseline_fieldDescription=''">
										<xsl:text>''</xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="@Baseline_fieldDescription" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if>
						</td>
						<xsl:if test="./Defect">
							<td>
								<a>
									<xsl:attribute name="id">
										<xsl:text>def</xsl:text>
										<xsl:number value="count(preceding::Defect)" />
									</xsl:attribute>
									<xsl:attribute name="name">
										<xsl:text>defect</xsl:text>
										<xsl:value-of select="./Defect/@id" />
									</xsl:attribute>

									<xsl:for-each select="Defect">
										<xsl:value-of select="@id" />
										<xsl:text>(</xsl:text>
										<xsl:value-of select="@name" />
										<xsl:text>)</xsl:text>
										<br />
									</xsl:for-each>

									<xsl:call-template name="defectButtons">
										<xsl:with-param name="defectnumber" select="count(preceding::Defect)" />
									</xsl:call-template>
								</a>
							</td>
						</xsl:if>
					</xsl:if>
				</tr>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="EnquiryData" mode="SelectionResult">
		<div class="fs" name="fs">
			<xsl:attribute name="id">
				<xsl:text>fs</xsl:text>
				<xsl:value-of select="generate-id(.)" />
			</xsl:attribute>
			<h3>Filter(s):</h3>

			<table width="95%" border="2">
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
										<xsl:value-of select="@name" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="@Baseline_name" />
									</xsl:otherwise>
								</xsl:choose>
							</td>

							<td>
								<xsl:choose>
									<xsl:when test="@operator!=''">
										<xsl:value-of select="@operator" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="@Baseline_operator" />
									</xsl:otherwise>
								</xsl:choose>
							</td>
							<td>
								<xsl:value-of select="@value" />
							</td>
							<xsl:if test="$isCompare=1">
								<td>
									<xsl:value-of select="@Baseline_value" />
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
				<xsl:value-of select="generate-id(.)" />
			</xsl:attribute>
			<h4>Expected output(s)</h4>
			<xsl:for-each select="ExpectedOutput">

				<table width="63%" border="2">
					<xsl:if test="$isCompare=1">
						<thead>
							<tr>
								<th />
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
								<xsl:value-of select="@expectedResult" />
							</td>
							<xsl:if test="$isCompare=1">
								<td>
									<xsl:value-of select="@Baseline_expectedResult" />
								</td>
							</xsl:if>
						</tr>
						<tr>
							<td>
								<strong>Pop up menu action:</strong>
							</td>
							<td>
								<xsl:value-of select="@popUpMenu" />
							</td>
							<xsl:if test="$isCompare=1">
								<td>
									<xsl:value-of select="@Baseline_popUpMenu" />
								</td>
							</xsl:if>
						</tr>
					</tbody>
				</table>

				<xsl:if test="Field">
					<p />
					Expected value(s) to be checked:

					<table width="95%" border="2">
						<thead>
							<tr>
								<th>Field</th>
								<th>Filter value</th>
								<th>Expected value</th>
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
										<xsl:value-of select="@name" />
									</td>
									<td>
										<xsl:value-of select="@filterValue" />
									</td>
									<td>
										<xsl:value-of select="@expectedValue" />
									</td>
									<xsl:if test="$isCompare=1">
										<td>
											<xsl:value-of select="@Baseline_filterValue" />
										</td>
										<td>
											<xsl:value-of select="@Baseline_expectedValue" />
										</td>
									</xsl:if>
								</tr>
							</xsl:for-each>
						</tbody>
					</table>
				</xsl:if>
			</xsl:for-each>
		</div>
	</xsl:template>

	<xsl:template match="SET_FIELD">
		<tr>
			<td>
				<xsl:if test="@Text!=''">
					<xsl:value-of select="@Text" />
				</xsl:if>
				<xsl:if test="@Text='' or not(@Text)">
					<xsl:value-of select="@Baseline_Text" />
				</xsl:if>
			</td>
			<xsl:choose>
				<xsl:when
					test="count(./Testcase)=1 or contains(@Value,'#ENTER') or contains(@Baseline_Value,'#ENTER')">
					<td>
						<xsl:if
							test="substring-after(substring-before(current()/@Text,'.)'),'(')=''">
							<xsl:text>'</xsl:text>
							<xsl:value-of
								select="ancestor::Version/VersionFields/descendant::*[contains(current()/@Text,name())]/@value" />
							<xsl:text>'</xsl:text>
						</xsl:if>
						<xsl:if
							test="substring-after(substring-before(current()/@Text,'.)'),'(')!=''">
							<xsl:text>'</xsl:text>
							<xsl:value-of
								select="ancestor::Version/VersionFields/descendant::*[contains(current()/@Text,name())][position()=number(substring-before(substring-after(current()/@Text,'('),'.'))]/@value" />
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
							<xsl:if
								test="substring-after(substring-before(current()/@Baseline_Text,'.)'),'(')=''">
								<xsl:text>'</xsl:text>
								<xsl:value-of
									select="ancestor::Version/VersionFields/descendant::*[contains(current()/@Baseline_Text,name())]/@Baseline_value" />
								<xsl:text>'</xsl:text>
							</xsl:if>
							<xsl:if
								test="substring-after(substring-before(current()/@Baseline_Text,'.)'),'(')!=''">
								<xsl:text>'</xsl:text>
								<xsl:value-of
									select="ancestor::Version/VersionFields/descendant::*[contains(current()/@Baseline_Text,name())][position()=number(substring-before(substring-after(current()/@Baseline_Text,'('),'.'))]/@Baseline_value" />
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
								<xsl:value-of
									select="substring-before(substring-after(@Text,'Field value :'),' and Expected : ')" />
								<xsl:if
									test="substring-before(substring-after(@Text,' and Expected : '),' are not the same!')">
									<span style="font-weight:bold;">
										<xsl:text> </xsl:text>
										<xsl:value-of
											select="substring-before(substring-after(@Text,' and Expected : '),' are not the same!')" />
										Warning
										(
										<xsl:value-of select="@Status" />
										).
									</span>
								</xsl:if>
							</td>
							<xsl:if test="$isCompare=1">
								<td>
									<xsl:value-of
										select="substring-before(substring-after(@Baseline_Text,'Field value :'),' and Expected : ')" />
									<xsl:if
										test="substring-before(substring-after(@Baseline_Text,' and Expected : '),' are not the same!')">
										<span style="font-weight:bold;">
											<xsl:text> </xsl:text>
											<xsl:value-of
												select="substring-before(substring-after(@Baseline_Text,' and Expected : '),' are not the same!')" />
											Warning
											(
											<xsl:value-of select="@Baseline_Status" />
											).
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

	<xsl:template
		match="Message[@Interface or @Baseline_Interface or not(./Message)]">
		<xsl:if test="(@filename) and (./Info) and (./Info/@Text)">
			<span class="TableHeader">
				<xsl:value-of select="@filename" />
				<br />
				<br />
			</span>
			<xsl:for-each select="./Info">
				<xsl:value-of select="@Text" />
				<br />
			</xsl:for-each>
		</xsl:if>
		<xsl:if test="(./Info) and not(./Info/@Text)">
			<span class="TableHeader">
				<xsl:value-of select="@filename" />
				<br />
				<br />
			</span>
			<xsl:for-each select="./Info/@*">
				<xsl:value-of select="name(.)" />
				:
				<xsl:value-of select="." />
				<br />
			</xsl:for-each>
		</xsl:if>
		<table width="95%" border="2">
			<thead>
				<xsl:if test="@Interface or @Baseline_Interface">
					<tr>
						<td colspan="2" align="center">
							<span class="TableHeader">
								<xsl:choose>
									<xsl:when test="@Interface!=''">
										<xsl:value-of select="@Interface" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="@Baseline_Interface" />
									</xsl:otherwise>
								</xsl:choose>
								<xsl:if test="@Key or @Baseline_Key">
									<xsl:text>(</xsl:text>
									<xsl:choose>
										<xsl:when test="@Interface!=''">
											<xsl:value-of select="@Key" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="@Baseline_Key" />
										</xsl:otherwise>
									</xsl:choose>
									<xsl:text>)</xsl:text>
								</xsl:if>
							</span>
						</td>
					</tr>
				</xsl:if>
				<tr>
					<th />
					<th>Value</th>
					<xsl:if test="$isCompare=1">
						<th>Baseline value</th>
					</xsl:if>
				</tr>
			</thead>
			<tbody>
				<xsl:apply-templates mode="messageblock" />
			</tbody>
		</table>
		<p />
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
					<xsl:value-of select="name(.)" />
				</td>
				<td style="width: 35%">
					<xsl:for-each select="@Value">
						<xsl:value-of select="." />
					</xsl:for-each>
				</td>
				<xsl:if test="$isCompare=1">
					<td style="width: 35%">
						<xsl:for-each select="@Baseline_Value">
							<xsl:value-of select="." />
						</xsl:for-each>
					</td>
					<xsl:if test="./Defect">
						<td>

							<a>
								<xsl:attribute name="id">
									<xsl:text>def</xsl:text>
									<xsl:number value="count(preceding::Defect)" />
								</xsl:attribute>
								<xsl:attribute name="name">
									<xsl:text>defect</xsl:text>
									<xsl:value-of select="./Defect/@id" />
								</xsl:attribute>

								<xsl:for-each select="Defect">
									<xsl:value-of select="@id" />
									<xsl:text>(</xsl:text>
									<xsl:value-of select="@name" />
									<xsl:text>)</xsl:text>
									<br />
								</xsl:for-each>

								<xsl:call-template name="defectButtons">
									<xsl:with-param name="defectnumber" select="count(preceding::Defect)" />
								</xsl:call-template>
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
							<xsl:value-of select="@name" />
						</xsl:when>
						<xsl:when test="@Baseline_name!=''">
							<xsl:value-of select="@Baseline_name" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="name()" />
						</xsl:otherwise>
					</xsl:choose>
				</td>
				<td style="width: 35%">

					<xsl:for-each select="@FieldValue">
						<xsl:value-of select="." />
					</xsl:for-each>
				</td>
				<xsl:if test="$isCompare=1">
					<td style="width: 35%">
						<xsl:for-each select="@Baseline_FieldValue">
							<xsl:value-of select="." />
						</xsl:for-each>
					</td>
					<xsl:if test="./Defect">
						<td>

							<a>
								<xsl:attribute name="id">
									<xsl:text>def</xsl:text>
									<xsl:number value="count(preceding::Defect)" />
								</xsl:attribute>
								<xsl:attribute name="name">
									<xsl:text>defect</xsl:text>
									<xsl:value-of select="./Defect/@id" />
								</xsl:attribute>

								<xsl:for-each select="Defect">
									<xsl:value-of select="@id" />
									<xsl:text>(</xsl:text>
									<xsl:value-of select="@name" />
									<xsl:text>)</xsl:text>
									<br />
								</xsl:for-each>

								<xsl:call-template name="defectButtons">
									<xsl:with-param name="defectnumber" select="count(preceding::Defect)" />
								</xsl:call-template>
							</a>
						</td>
					</xsl:if>
				</xsl:if>
			</tr>
		</xsl:if>
		<!--<xsl:apply-templates mode="messageblock"/> -->
	</xsl:template>

	<xsl:template match="FieldValues[child::node()]" mode="Interface">
		<br />

		<table width="95%" border="2">
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
				<xsl:apply-templates select="./*"
					mode="InterfaceFieldValues" />
			</tbody>
		</table>
	</xsl:template>

	<xsl:template match="*" mode="InterfaceFieldValues">
		<xsl:choose>
			<xsl:when test="@multivalue='yes'">
				<xsl:for-each select="./item">
					<xsl:apply-templates mode="FieldValues" />
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
						<xsl:value-of select="name()" />
					</td>
					<td>
						<xsl:value-of select="@Value" />
					</td>
					<xsl:if test="$isCompare=1">
						<td>
							<xsl:value-of select="@Baseline_Value" />
						</td>
						<xsl:if test="./Defect">
							<td>

								<a>
									<xsl:attribute name="id">
										<xsl:text>def</xsl:text>
										<xsl:number value="count(preceding::Defect)" />
									</xsl:attribute>
									<xsl:attribute name="name">
										<xsl:text>defect</xsl:text>
										<xsl:value-of select="./Defect/@id" />
									</xsl:attribute>

									<xsl:for-each select="Defect">
										<xsl:value-of select="@id" />
										<xsl:text>(</xsl:text>
										<xsl:value-of select="@name" />
										<xsl:text>)</xsl:text>
										<br />
									</xsl:for-each>

									<xsl:call-template name="defectButtons">
										<xsl:with-param name="defectnumber" select="count(preceding::Defect)" />
									</xsl:call-template>
								</a>
							</td>
						</xsl:if>
					</xsl:if>
				</tr>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="LogicalAttributes">
		<table width="95%" border="2">
			<thead>
				<tr>
					<th />
					<th colspan="3">Logical Attributes</th>
				</tr>
				<tr>
					<th />
					<th>Value</th>
					<th>Baseline value</th>
					<th>Predefined</th>
				</tr>
			</thead>
			<tbody>
				<xsl:for-each select="./LogicalAttribute">
					<tr>
						<th>
							<xsl:value-of select="@path" />
						</th>
						<td>
							<xsl:if test="string-length(@actual)&gt;=60">
								<xsl:value-of select="substring(@actual,1,60)" />
								<xsl:text>...</xsl:text>
							</xsl:if>
							<xsl:if test="string-length(@actual)&lt;60">
								<xsl:value-of select="@actual" />
							</xsl:if>
						</td>
						<td>
							<xsl:if test="string-length(@baseline)&gt;=60">
								<xsl:value-of select="substring(@baseline,1,60)" />
								<xsl:text>...</xsl:text>
							</xsl:if>
							<xsl:if test="string-length(@baseline)&lt;60">
								<xsl:value-of select="@baseline" />
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
		<xsl:param name="defectnumber" />
		<input type="button" value="&#171;">
			<xsl:attribute name="onclick">
				<xsl:text>jumpToPreviousDefectFrom(</xsl:text>
				<xsl:value-of select="$defectnumber" />
				<xsl:text>)</xsl:text>
			</xsl:attribute>
		</input>
		<input type="button" value="&#187;">
			<xsl:attribute name="onclick">
				<xsl:text>jumpToNextDefectFrom(</xsl:text>
				<xsl:value-of select="$defectnumber" />
				<xsl:text>,</xsl:text>
				<xsl:value-of select="$numberOfDefect" />
				<xsl:text>)</xsl:text>
			</xsl:attribute>
		</input>
	</xsl:template>
</xsl:stylesheet>