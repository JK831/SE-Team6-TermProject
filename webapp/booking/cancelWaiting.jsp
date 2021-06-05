<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="./connection.jsp" %>

<%
	int waitingNum= Integer.valueOf(request.getParameter("waitingNum"));
	
	PreparedStatement pstmt = null;

	String sql = "DELETE FROM waitingList WHERE waiting_number = ?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, waitingNum);
	pstmt.executeUpdate();
	response.sendRedirect("./WaitingList.jsp");
	
%>
