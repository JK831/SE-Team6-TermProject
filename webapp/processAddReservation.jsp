<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.sql.Date" %>
<%@ include file="./connection.jsp" %>
<%
	request.setCharacterEncoding("UTF-8");	
	
	
	String name = request.getParameter("name");
	String phoneNumber = request.getParameter("phoneNumber");
	int covers = Integer.valueOf(request.getParameter("covers"));
	String sDate = request.getParameter("date");
	String sTime = request.getParameter("time");
	int tableNum = Integer.valueOf(request.getParameter("tableNum"));
	String event = request.getParameter("event");
	
	Date date = Date.valueOf(sDate); // 문자열로 받은 날짜를 Date 형식으로 바꿔준다
	Time time = Time.valueOf(sTime); // 문자열로 받은 시간을 Time 형식으로 바꿔준다
	
	int cus_id = 0;
	int last_oid = 0;
	
	Statement stmt = null;
	Statement stmt2 = null;
	PreparedStatement pstmt = null;
	PreparedStatement pstmt2 = null;
	PreparedStatement pstmt3 = null;
	PreparedStatement pstmt4 = null;
	ResultSet rs = null;
	
	String sql = "SELECT last_id FROM Oid";
	stmt = conn.createStatement();
	rs = stmt.executeQuery(sql);
	
	while(rs.next()){
		last_oid = rs.getInt("last_id");
		last_oid++;
	}
	if(last_oid != 0){
	sql = "UPDATE Oid SET last_id=?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1,last_oid);
	pstmt.executeUpdate();
	
	sql = "SELECT oid from Customer WHERE phoneNumber=?";
	pstmt2 = conn.prepareStatement(sql);
	pstmt2.setString(1,phoneNumber);
	rs = pstmt.executeQuery();
	
	while(rs.next()){
		cus_id = rs.getInt("oid");
	}
	
	if(cus_id==0){
		sql = "SELECT oid from Customer order by oid desc limit 1";
		stmt2 = conn.createStatement();
		rs = stmt2.executeQuery(sql);
		while(rs.next()){
			cus_id = rs.getInt("oid");
		}
		cus_id++;
		sql = "INSERT INTO Customer (oid, name, phoneNumber) VALUES (?, ?, ?)";
		pstmt4 = conn.prepareStatement(sql);
		pstmt4.setInt(1, cus_id);
		pstmt4.setString(2, name);
		pstmt4.setString(3, phoneNumber);
		pstmt4.executeUpdate();
	}
	
	
	sql = "INSERT INTO Reservation (oid, covers, date, time, table_id, customer_id, event) VALUES (?, ?, ?, ?, ?, ?, ?)";
	pstmt3 = conn.prepareStatement(sql);
	pstmt3.setInt(1,last_oid);
	pstmt3.setInt(2,covers);
	pstmt3.setDate(3,date);
	pstmt3.setTime(4,time);
	pstmt3.setInt(5,tableNum);
	pstmt3.setInt(6, cus_id);
	pstmt3.setString(7,event);
	pstmt3.executeUpdate();
	
	}
	if(rs!=null)
		rs.close();
	if(stmt!=null)
		stmt.close();
	if(pstmt!=null)
		pstmt.close();
	if(pstmt2!=null)
		pstmt2.close();
	if(pstmt3!=null)
		pstmt3.close();
	if(pstmt4!=null)
		pstmt4.close();
%>
<html>
	<head>
	<meta name="viewport" content="width=device-width; initial-scale=1.0">
	<link rel = "stylesheet"
	href = "https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"/>
	<style>
		h1{ 
			text-align:center; 
		}
		h1:after {
			display:block;
			content: '';
			border-bottom: solid 3px #4C4C4C;  
			transform: scaleX(0);  
			transition: transform 250ms ease-in-out;
		}
		h1:hover:after { transform: scaleX(1); }
		@media screen and (max-width: 760px){
		body{
			font-size:11px;
		}
		.container p{
			font-size:calc(1.525rem + 3.3vw);
			font-weight:150;
			line-height:1.2;
		}
		.text-center p{
			font-size:calc(1.2rem + 2.2vw);
			font-weight:120;
			line-height:1.2;
	
	}
	</style>
	<script>
	alert('예약 등록이 완료 되었습니다!');
	</script>
	<title>예약 등록</title>
	</head>
	<body>
	<%@ include file="./menu.jsp" %>
	<% String tagline = "돌아가기";%>
	<div class = "jumbotron">
		<div class = "container">
			<h1>예약이 완료되었습니다.</h1>
		</div>
	</div>
	<div class = "text-center">
		<p><a href="./Main.jsp">
			돌아가기
		</a></p>
	</div>
	</body>
	</html>