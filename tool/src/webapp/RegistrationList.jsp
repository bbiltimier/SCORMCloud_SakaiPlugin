<?xml version="1.0" encoding="UTF-8" ?>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="org.springframework.web.context.WebApplicationContext" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="com.rusticisoftware.scormcloud.tool.ScormCloudToolBean" %>
<%@ page import="com.rusticisoftware.scormcloud.model.ScormCloudPackage" %>
<%@ page import="com.rusticisoftware.scormcloud.model.ScormCloudRegistration" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>
<%
    // Get the backing bean from the spring context
    WebApplicationContext context = 
        WebApplicationContextUtils.getWebApplicationContext(application);
    ScormCloudToolBean bean = (ScormCloudToolBean)context.getBean("scormCloudToolBean");
    
    bean.doPageChecks(request, response);
    pageContext.setAttribute("bean", bean);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script src="/library/js/headscripts.js" language="JavaScript" type="text/javascript"></script>
<link media="all" href="/library/skin/tool_base.css" rel="stylesheet" type="text/css"/>
<link media="all" href="/library/skin/default/tool.css" rel="stylesheet" type="text/css"/>
<link media="all" href="css/ScormCloud.css" rel="stylesheet" type="text/css"/>
<title>SCORM Cloud Registrations</title>
</head>
<body onload="<%= request.getAttribute("sakai.html.body.onload") %>">
<div class="portletBody">

<%@ include file="Menu.jsp" %>

<h3 class="insColor insBak insBorder">
	SCORM Cloud Registrations
	<c:if test="${not empty pkg}">
		for Resource ${pkg.title}
	</c:if>
</h3>

<%@ include file="Messages.jsp" %>

<div class="instruction">Use the inputs below to ${empty pkg ? "search for" : "filter the"} results.</div>

<form name=searchRegistrationsForm" actions="controller?action=searchRegistrations" method="post">
	<c:if test="${not empty pkg}">
		<input type="hidden" id="packageId" name="packageId" value="${pkg.id}" />
	</c:if>
	<table>
		<tr>
			<td>
				<label for="userSearch">${empty pkg ? "Search" : "Filter"} By Student Name</label>
				<input type="text" id="userSearch" name="userSearch" value="${userSearch}" size="40" />
			</td>
			<td>
				<label for="assignmentSearch">${empty pkg ? "Search" : "Filter"} By Assignment Name</label>
				<input type="text" id="assignmentSearch" name="assignmentSearch" value="${assignmentSearch}" size="40" />
			</td>
			<td style="vertical-align:bottom">
				<input type="submit" id="searchSubmit" name="searchSubmit" value="Search" />
			</td>
		</tr>
	</table>
</form>


<c:if test="${not empty regList}">
	<form name="listItemsForm" action="controller?action=processRegistrationListAction" method="post">
		<c:if test="${not empty pkg}">
			<input type="hidden" id="packageId" name="packageId" value="${pkg.id}" />
		</c:if>
	    <table class="listHier">
	        <thead>
	            <tr>
	                <th></th>
	                <th>User Name</th>
	                <th>Assignment Name</th>
	                <th>Resource Name</th>
	                <th>Complete</th>
	                <th>Success</th>
	                <th>Score</th>
	                <th>Time Spent</th>
	                <th>Detailed Reports</th>
	                <th>Creation Date</th>
	            </tr>
	        </thead>
	        <tbody>
	            <c:forEach var="reg" items="${regList}">
	                <% ScormCloudRegistration reg = (ScormCloudRegistration)pageContext.getAttribute("reg"); %>
	                <tr>
	                    <td>
	                        <input name="select-item" value="${reg.id}" type="checkbox" />
	                    </td>
	                    <td>
	                        <span>${reg.userDisplayName}</span>                 
	                    </td>
	                    <td>
	                    	<span>${reg.assignmentName}</span>
	                    </td>
	                    <td>
	                    	<span>${reg.packageTitle}</span>
	                    </td>
	                    <td>
	                    	<span>${reg.complete}</span>
	                    </td>
	                    <td>
	                    	<span>${reg.success}</span>
	                    </td>
	                    <td>
	                    	<span>${(reg.score == "unknown") ? "unknown" : reg.score}</span>
	                    </td>
	                    <td>
	                    	<span><%= bean.formatSeconds(reg.getTotalTime()) %></span>
	                    </td>
	                    <td style="white-space:nowrap;">
	                    	<a href="controller?action=viewActivityReport&registrationId=${reg.id}">Activity Report</a>
							<br />
	                    	<a href="controller?action=viewLaunchHistoryReport&registrationId=${reg.id}">Launch History</a>
	                    	<br />
	                    	<a href="controller?action=viewLearnerReport&registrationId=${reg.id}">Learner Report</a>
	                    	<br />
	                    	<a href="controller?action=viewRegistrationReport&registrationId=${reg.id}">Registration Report</a>
	                    </td>
	                    <td>
	                        <fmt:formatDate value="${reg.dateCreated}" type="both" 
	                            dateStyle="medium" timeStyle="medium" />
	                    </td>
	                </tr>
	            </c:forEach>
	        </tbody>
	    </table>
	
	    <p class="act">
	    	<input name="update-items" type="submit" value="Update Results" />
	    	<input name="reset-items" type="submit" value="Reset" />
	        <input name="delete-items" type="submit" value="Delete" />
	    </p>
    
	</form>
</c:if>

</div>
</body>
</html>
