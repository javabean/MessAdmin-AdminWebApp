<?xml version="1.0" encoding="UTF-8"?><%
%><%@page session="false" contentType="text/html; charset=UTF-8" %><%
%><%@page import="clime.messadmin.core.Constants"%><%
%><%@page import="clime.messadmin.model.IServerInfo" %><%
%><%@page import="clime.messadmin.model.DisplayDataHolder"%><%
%><%@page import="clime.messadmin.admin.AdminActionProvider"%><%
%><%@page import="clime.messadmin.admin.actions.WebAppsList"%><%
%><%@page import="clime.messadmin.admin.actions.ReloadServerDataProvider"%><%
%><%@page import="clime.messadmin.admin.actions.ReloadDataProviderHelper"%><%
%><%@page import="clime.messadmin.utils.Files"%><%
%><%@page import="clime.messadmin.utils.JMX"%><%
%><%@taglib prefix="core" uri="http://messadmin.sf.net/core" %><%
%><%@taglib prefix="format" uri="http://messadmin.sf.net/fmt" %>
<%--!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"--%>
<%--!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd"--%>
<!DOCTYPE html 
     PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
     "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--!DOCTYPE html 
     PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
     "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"--%>
<%--!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
 "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"--%>

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%= response.getLocale() %>">
<format:setBundle basename="clime.messadmin.admin.i18n.serverInfos"/>
<% IServerInfo serverInfos = (IServerInfo) request.getAttribute("serverInfos"); %>
<%--c:url value="${pageContext.request.servletPath}" var="submitUrl" scope="page"/--%><%-- can use value="${pageContext.request.servletPath}" because this JSP is include()'ed --%>
<%-- or use directly ${pageContext.request.requestURI} --%>
<% String submitUrl = request.getContextPath() + request.getServletPath(); /* Can use +request.getServletPath() because this JSP is include()'ed */ %>
<head>
	<%@ include file="inc/meta.inc" %>
	<title><format:message key="page.title"><format:param value="<%= serverInfos.getServerName() %>"/></format:message></title>
	<%@ include file="inc/css.inc" %>
	<style type="text/css">
	</style>
	<script type="text/javascript">//<![CDATA[
		function reloadPage() {
			window.location.reload();
		}
	//]]>
	</script>
</head>
<body><% response.flushBuffer(); %>

<div id="menu">
<jsp:include page="inc/menuTools.jsp"/>
<span>
[
<format:message key="menu.serverInfos"/>
|
<a href="<%=submitUrl%>?<%=AdminActionProvider.ACTION_PARAMETER_NAME%>=<%=WebAppsList.ID%>"><format:message key="menu.webAppsList"/></a>
]
</span>
</div>

<h1><format:message key="page.title"><format:param value="<%= serverInfos.getServerName() %>"/></format:message></h1>

<jsp:include page="inc/stuckThreads.jsp"/>
<jsp:include page="inc/systemLoad.jsp"/>
<jsp:include page="inc/diskSpace.jsp"/>

<fieldset>
	<legend><span class="collapsible" id="serverInfo"><format:message key="serverInfo.legend"/></span></legend>
<table id="serverInfo-target" style="text-align: left;" border="0">
	<tr>
		<th><format:message key="serverInfo.serverName"/></th>
		<td title='<format:message key="serverInfo.workingDir">
				<format:param value='<%= serverInfos.getSystemProperties().get("user.dir") %>'/>
				<format:param value='<%= Files.getUsableSpaceForFile((String)serverInfos.getSystemProperties().get("user.dir"))/1024 %>'/>
			</format:message>'><core:out value="<%= getServletConfig().getServletContext().getServerInfo() %>"/></td>
		<th><format:message key="serverInfo.servletVersion"/></th>
		<td><%= getServletConfig().getServletContext().getMajorVersion() %>.<%= getServletConfig().getServletContext().getMinorVersion() %></td>
		<th><format:message key="serverInfo.jspVersion"/></th>
		<td><core:out value="<%= javax.servlet.jsp.JspFactory.getDefaultFactory().getEngineInfo().getSpecificationVersion() %>"/></td>
	</tr>
	<tr>
		<th><format:message key="serverInfo.tempDir"/></th>
		<td title='<format:message key="serverInfo.tempDir.usableSpace">
				<format:param value='<%= Files.getUsableSpaceForFile((String)serverInfos.getSystemProperties().get("java.io.tmpdir"))/1024 %>'/>
			</format:message>'><core:out value='<%= serverInfos.getSystemProperties().get("java.io.tmpdir") %>'/></td>
		<th><format:message key="serverInfo.runAs"/></th>
		<td colspan="2" title='<format:message key="serverInfo.homeDir">
				<format:param value='<%= serverInfos.getSystemProperties().get("user.home") %>'/>
				<format:param value='<%= Files.getUsableSpaceForFile((String)serverInfos.getSystemProperties().get("user.home"))/1024 %>'/>
			</format:message>'><core:out value='<%= serverInfos.getSystemProperties().get("user.name") %>'/></td>
	</tr>
	<tr>
		<th><format:message key="serverInfo.uptime"/></th>
		<td title="<format:message key='serverInfo.startupDate'>
				<format:param><format:formatDate value='<%= serverInfos.getStartupTime() %>' type='both' pattern='yyyy-MM-dd HH:mm:ss'/></format:param>
			</format:message>"><format:formatTimeInterval value="<%= System.currentTimeMillis() - serverInfos.getStartupTime().getTime() %>"/></td>
		<td colspan="4"></td>
	</tr>
</table>
</fieldset>

<fieldset>
	<legend><span class="collapsible" id="cpu-memory"><format:message key="cpuMem.legend"/></span></legend>
<table id="cpu-memory-target" style="text-align: left;" border="0">
	<tr>
		<th title="<format:message key='cpuMem.nCpus.TT'/>"><format:message key="cpuMem.nCpus"/></th>
		<td align="center"><format:formatNumber value="<%= serverInfos.getAvailableProcessors() %>" type="number"/></td>
	</tr>
<core:if test="<%= serverInfos.getSystemLoadAverage() >= 0.0 %>">
	<tr>
		<th title="<format:message key='cpuMem.systemLoad.TT'/>"><format:message key="cpuMem.systemLoad"/></th>
		<td align="center"><format:formatNumber value="<%= serverInfos.getSystemLoadAverage() %>" type="number"/></td>
	</tr>
</core:if>
	<tr>
		<th title="<format:message key='cpuMem.freeMem.TT'/>"><format:message key="cpuMem.freeMem"/></th>
		<td class="number"><format:formatNumber value="<%= serverInfos.getFreeMemory() %>" type="bytes"/></td>
		<td rowspan="2">
<table border="0" cellpadding="0" cellspacing="0" width="100px">
	<tr><td bgcolor="red" height="1em" width="<%= (int)((double)(serverInfos.getTotalMemory()-serverInfos.getFreeMemory()) / (double)serverInfos.getTotalMemory() * 100) %>px">&nbsp;</td><td bgcolor="green" height="1em" width="*">&nbsp;</td></tr>
</table>
		</td>
	</tr>
	<tr>
		<th title="<format:message key='cpuMem.totalMem.TT'/>"><format:message key="cpuMem.totalMem"/></th>
		<td class="number"><format:formatNumber value="<%= serverInfos.getTotalMemory() %>" type="bytes"/></td>
	</tr>
	<tr>
		<th title="<format:message key='cpuMem.maxMem.TT'/>"><format:message key="cpuMem.maxMem"/></th>
		<td class="number"><format:formatNumber value="<%= serverInfos.getMaxMemory() %>" type="bytes"/></td>
		<td></td>
	</tr>
<core:if test="<%= JMX.getGCCollectionCount() > 0 && JMX.getGCCollectionTime() > 0 %>">
	<tr>
		<th><format:message key="cpuMem.gc"/></th>
		<td colspan="2"><format:message key="cpuMem.gc.detail">
				<format:param value="<%= JMX.getGCCollectionCount() %>"/>
				<format:param><format:formatTimeInterval value="<%= JMX.getGCCollectionTime() %>"/></format:param>
				<format:param value='<%= JMX.getGCCollectionTime() % 1000 %>'/>
			</format:message></td>
		<td></td>
	</tr>
</core:if>
</table>
</fieldset>

<fieldset>
	<legend><span class="collapsible" id="vmInfo"><format:message key="vmInfo.legend"/></span></legend>
<!-- extracted properties from System.getProperties() (see JavaDoc) -->
<table id="vmInfo-target" style="text-align: left;" border="0">
	<%--caption>VM Info</caption--%>
	<tr>
		<th><format:message key="vmInfo.javaVM"/></th>
		<td>
			<core:out value='<%= serverInfos.getSystemProperties().get("java.vm.vendor") %>'/>
			<core:out value='<%= serverInfos.getSystemProperties().get("java.vm.name") %>'/>
			<core:out value='<%= serverInfos.getSystemProperties().get("java.vm.version") %>'/>
		</td>
	</tr>
	<tr>
		<th><format:message key="vmInfo.javaRE"/></th>
		<td>
			<a href="<%= serverInfos.getSystemProperties().get("java.vendor.url") %>"><core:out value='<%= serverInfos.getSystemProperties().get("java.vendor") %>'/></a>
			<core:out value='<%= serverInfos.getSystemProperties().get("java.version") %>'/> @ <core:out value='<%= serverInfos.getSystemProperties().get("java.home") %>'/>
		</td>
	</tr>
	<tr>
		<th><format:message key="vmInfo.platform"/></th>
		<td>
			<core:out value='<%= serverInfos.getSystemProperties().get("os.name") %>'/>/<core:out value='<%= serverInfos.getSystemProperties().get("os.arch") %>'/>
			<core:out value='<%= serverInfos.getSystemProperties().get("os.version") %>'/>
		</td>
	</tr>
</table>
</fieldset>

<p class="noprint" style="text-align: center;"><button type="button" onclick="window.location.reload()"><format:message key="refresh"/></button></p>

<div class="error"><core:out value='<%= request.getAttribute("error") %>'/></div>
<div class="message"><core:out value='<%= request.getAttribute("message") %>'/></div>

<div id="extraServerAttributes">
<% int index = 0; %>
<core:forEach items="<%= serverInfos.getServerSpecificData() %>" var="serverSpecificData" varStatus="status">
<%	DisplayDataHolder serverSpecificData = (DisplayDataHolder) pageContext.getAttribute("serverSpecificData");
	String dataTitle = serverSpecificData.getTitle();
	String dataXHTML = serverSpecificData.getXHTMLData();
	String refreshTitleURL = submitUrl + '?' + AdminActionProvider.ACTION_PARAMETER_NAME + '=' + ReloadServerDataProvider.ID + '&' + ReloadDataProviderHelper.PARAM_PROVIDER + '=' + serverSpecificData.getHTMLId() + '&' + ReloadDataProviderHelper.PARAM_SCOPE + '=' + ReloadDataProviderHelper.SCOPE_TITLE;
	String refreshDataURL = submitUrl + '?' + AdminActionProvider.ACTION_PARAMETER_NAME + '=' + ReloadServerDataProvider.ID + '&' + ReloadDataProviderHelper.PARAM_PROVIDER + '=' + serverSpecificData.getHTMLId() + '&' + ReloadDataProviderHelper.PARAM_SCOPE + '=' + ReloadDataProviderHelper.SCOPE_CONTENT;
	if (dataTitle != null && dataXHTML != null) {
		++index; %>
	<fieldset><%--
Refresh
0x21BA	8634	ANTICLOCKWISE OPEN CIRCLE ARROW	↺
0x21BB	8635	CLOCKWISE OPEN CIRCLE ARROW	↻
0x21B9	8633	LEFTWARDS ARROW TO BAR OVER RIGHTWARDS ARROW TO BAR	↹
0x21C4	8644	RIGHTWARDS ARROW OVER LEFTWARDS ARROW	⇄
0x21C6	8646	LEFTWARDS ARROW OVER RIGHTWARDS ARROW	⇆
--%>
		<legend><a href="#" title="<format:message key='refresh'/>" style="text-decoration: none;" onclick="javascript:/*jah('<%=refreshTitleURL%>','extraServerAttributes-<%=index%>');*/jah('<%=refreshDataURL%>','<%=serverSpecificData.getHTMLId()%>');return false;">&#8635;</a><span class="collapsible" id="extraServerAttributes-<%=index%>"><%= dataTitle %></span></legend>
		<div id="extraServerAttributes-<%=index%>-target"><div id="<%=serverSpecificData.getHTMLId()%>"><%= dataXHTML %></div></div>
	</fieldset>
<% } %>
</core:forEach>
</div>

<jsp:include page="inc/footer.jsp"/>

<%@ include file="inc/js.inc" %>
</body>
</html>