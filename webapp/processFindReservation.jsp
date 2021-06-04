<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.util.StringTokenizer" %>
<%@ include file="./connection.jsp" %>
<html>
<head>
<link rel = "stylesheet"
	href = "https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"/>
	<title>에약 확인</title>
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
		table.type05 {
			font-size: 2vw;
			border-collapse: separate;
			border-spacing: 1px;
			text-align: left;
			line-height: 1.5;
			border-top: 1px solid #ccc;
			margin-left:auto; 
			margin-right:auto;
			float: left;
		}
		table.type05 th {
			width: 200px;
			padding: 10px;
			font-weight: bold;
			vertical-align: top;
			border-bottom: 1px solid #ccc;
			background: #efefef;
		}
		table.type05 td {
			width: 250px;
			padding: 10px;
			vertical-align: top;
			border-bottom: 1px solid #ccc;
		}
		@media screen and (max-width: 767px){
			table.type05 {
				font-size: 16px;
			}
		}
		.changeColor{
			background-color:#D4F4FA;
		}
		.btn { position:relative; left: 50px; bottom: -50px;
		display:block; width:200px; height:40px; line-height:40px; border:1px #ccc solid; 
		 		margin:15px auto; background-color:#ccc; text-align:center; cursor: pointer; color:#333;
		  		transition:all 0.9s, color 0.3; } 
		.btn:hover{color:#fff;}
		.hover4:hover{ box-shadow: 200px 0 0 0 rgba(0,0,0,0.25) inset, -200px 0 0 0 rgba(0,0,0,0.25) inset; }
		
	</style>
	
</head>
<body>
<%@ include file="./menu.jsp" %>
	<div class = "jumbotron">
		<div class = "container">
			<h1>예약 확인</h1>
		</div>
	</div>
		<div class = "text-center">
			<h5>고객님의 예약 목록</h5>
		</div>
<%
	request.setCharacterEncoding("UTF-8");
	
	
	String phoneNumber = request.getParameter("phoneNumber");
	int cus_id=0;
	int mileage=0;
	boolean existanceReservation = false;
	boolean available = true;
	Date today = Date.valueOf(LocalDate.now());
	String dateToStr = String.format("%1$tY-%1$tm-%1$td", today);
	StringTokenizer st1 = new StringTokenizer(dateToStr,"-");
	
	
	PreparedStatement pstmt = null;
	PreparedStatement pstmt2 = null;
	ResultSet rs = null;
	
	String sql = "SELECT * FROM Customer WHERE phoneNumber=?"; //전화번호로 고객id 가져온다
	pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, phoneNumber);
	rs = pstmt.executeQuery();
	
	while(rs.next()){
		cus_id = rs.getInt("oid");
		mileage = rs.getInt("mileage");
	}
	if(cus_id!=0){
		sql = "SELECT * FROM Reservation WHERE customer_id=? order by oid desc";//고객id로 예약내역을 불러온다.
		pstmt2 = conn.prepareStatement(sql);
		pstmt2.setInt(1, cus_id);
		rs = pstmt2.executeQuery();
	%>
	<script type="text/javascript">
		function checkDelete(oid) {
			if(confirm("예약을 취소하시겠습니까?") == true)
				location.href = "./deleteReservation.jsp?oid="+oid;
			else
				return;
		}
	</script>
	
	<%while(rs.next()){//예약이 존재한다면 출력
		available = true;
		existanceReservation = true;
		StringTokenizer st2 = new StringTokenizer(rs.getString("date"),"-"); 
		
		while(st1.hasMoreTokens()){
			if(!st1.nextToken().equals(st2.nextToken())){
				available = false;
			}
		}
		
		if(available){
		%>
		<table id="table" class="type05">
			<tr>
				<th scope="row">예약번호</th>
				<td><%=rs.getString("oid") %></td>
			</tr>
		</table>
		<table id="table" class="type05">
			<tr>
				<th scope="row">예약날짜</th>
				<td><%=rs.getString("date") %></td>
			</tr>
		</table>
		<table id="table" class="type05">
			<tr>
				<th scope="row">예약인원</th>
				<td><%=rs.getString("covers") %></td>
			</tr>
		</table>
		<table id="table" class="type05">
			<tr>
				<th scope="row">예약시간</th>
				<td><%=rs.getString("time") %></td>
			</tr>
		</table>
		<table id="table" class="type05">
			<tr>
				<th scope="row">예약 테이블</th>
				<td><%=rs.getString("table_id") %></td>
			</tr>
		</table>
		<table id="table" class="type05">
			<tr>
				<th scope="row">마일리지</th>
				<td><%=mileage %></td>
			</tr>
		</table>
		<table id="table" class="type05">
			<tr>
				<th scope="row">이벤트</th>
				<td><%=rs.getString("event") %></td>
			</tr>
		</table>
		<footer>
		<div class="relative">
			<br>
			<br>
			<br>
			<input type="button" class="btn hover4" value="예약 취소" onclick="checkDelete('<%=rs.getInt("oid")%>')">

			<br>
			<br>
			<br>
		</div>
		</footer>
		<%} %>
	<%}
	if(existanceReservation==true && available==false){%>
		<div class="text-center">이용해주셔서 감사합니다. 고객님은 오늘, 오늘 이후의 예약 내역이 존재하지 않습니다.</div>
		<div class="text-center"><a href="./ChoiceDate.jsp">예약하러 가기</a></div>	
	<%}
	}
	
	else{%>
		<div class="text-center">예약 내역이 존재하지 않습니다.</div>
		<div class="text-center"><a href="./ChoiceDate.jsp">예약하러 가기</a></div>
	<%}
	if(rs!=null)
		rs.close();
	if(pstmt!=null)
		pstmt.close();
	if(pstmt2!=null)
		pstmt2.close();
	
%>
</body>
</html>