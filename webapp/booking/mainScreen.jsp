<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.StringTokenizer" %>
<html>
<head>
<link rel = "stylesheet"
	href = "../resources/css/bootstrap.min.css"/>
<link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css"/>	
<style>
	
	
	body {
		
	}
	
	.tableNum{
		background:black;
		width:100%;
		color: white;
		text-align: center;
		overflow: hidden;
	}
	
	.title{
		background:black;
		text-align:center;
		color:white;
		margin: 5px;
	}
	
	.reservationContainer{
		background:olivegreen;
		width:100%;
		position: relative;
	}
	
	.reservation {
		float: left;
		background: black;
		width: 300px;
		height: 300px;
		color: white;
		text-align:center;
		margin: 5px;
	}
	.customerName {
		color=orange;
	}
	.calendarContainer{
	width: 300px;
	position:relative;
	left:50%;
	transform: translateX(-50%);
	}
	.center{
	position:relative;
	left:50%;
	transform: translateX(-50%);
	}
	#delete{
		color: red;
	}
	#arrived{
		color: orange;
	}
</style>
<title>Welcome</title>
<script type="text/javascript">
	function deleteConfirm(oid) {
		if(confirm("해당 예약을 삭제합니다!") == true)
			location.href = "./deleteReservation.jsp?oid=" +oid;
		else
			return;
	}
	function checkArrived(oid) {
		if(confirm("고객이 도착하였습니까?") == true){
			alert('입장처리가 완료 되었습니다!');
			location.href = "./customerArrived.jsp?oid=" +oid;
		}
		else
			return;
	}
</script>
<script src="//code.jquery.com/jquery.min.js"></script>
<script src="//code.jquery.com/ui/1.11.4/jquery-ui.min.js"></script>
<script>
function checkDate(){
	var regExpDate = /^\d{4}-\d{2}-\d{2}$/;
	var form = document.choiceDate;
	var date = form.date.value;
	if(!regExpDate.test(date)){
		alert("날짜는 YYYY-MM-DD 형식으로 입력해주세요!");
		return;
	}
	else{
		form.submit();
	}
}

$(function() {
  $( "#datepicker1" ).datepicker({
    dateFormat: 'yy-mm-dd'
  });
});
</script>
</head>
<body>
	<%@ include file="./connection.jsp" %>
	<%@ include file="./menu.jsp" %>
	<%! String greeting = "6조 예약 관리 시스템"; 
	String tagline = "Booking Management";%>
	<div class = "jumbotron">
		<div class = "container">
			<h1 class = "display-3"><%= greeting %>
			</h1>
		</div>
	</div>
		<div class = "text-center">
			<h3>
				<%= tagline %>
			</h3>
		</div>
			<%
				int tableNum = 1;
				ResultSet rs = null;
				Statement stmt = null;
				ResultSet rs2 = null;
				PreparedStatement stmt2 = null;
				ResultSet rs3 = null;
				PreparedStatement stmt3 = null;
				try{
					stmt = conn.createStatement();
					String sqlTable = "SELECT * FROM `Table` order by number desc limit 1";//테이블의 개수를 테이블의 가장 마지막 데이터를 추출하여 알아낸다
					ResultSet rsTable = stmt.executeQuery(sqlTable);
					while (rsTable.next()){
						tableNum = Integer.valueOf(rsTable.getString("number")); //테이블 개수 설정
					}
					rsTable.close();
					stmt.close();
				}catch (SQLException ex) {
					out.println("Table 테이블 호출이 실패했습니다.<br>");
				} finally {
					if(rs != null)
						rs.close();
					if(stmt != null)
						stmt.close();
				}
				%>
				<div class="calendarContainer">
					<form name="choiceDate" class="center" action="./mainScreen.jsp">
						<input type="text" name="date" id="datepicker1">
						<input type="button" class="btn btn-primary" value="선택 날짜 조회" onclick="checkDate()">
					</form>
				</div> 
					
					<%
						try{
						SimpleDateFormat transFormat = new SimpleDateFormat("yyyy-MM-dd");
						LocalDate todaysDate = LocalDate.now();
						Date now;
						if(request.getParameter("date")==null){
							now = Date.valueOf(todaysDate);	
						}
						else{
						now = Date.valueOf(request.getParameter("date"));
						}
						boolean existenceReservation = false;
						
						String sql2 = "SELECT * FROM Reservation WHERE date =? order by time"; //시간 순으로 예약정보 불러 옴
						stmt2 = conn.prepareStatement(sql2);
						stmt2.setString(1,transFormat.format(now));//첫번째 ?를 전달 받은 날짜로 설정.
						rs2 = stmt2.executeQuery();
						%>
						<div class="title">현재 조회중인 날짜:<%=now %></div>
						<%
						while(rs2.next()){
							existenceReservation = true;
							String sTime = rs2.getString("time");// 해당 예약의 예약 시간 불러옴
							String cus_id = rs2.getString("customer_id");//해당 예약의 고객 정보 불러옴
							StringTokenizer st = new StringTokenizer(sTime,":"); // 문자열로 저장 된 시간을 토큰 단위로 분리
							int iHour = Integer.parseInt(st.nextToken());//정수로 변환
							int iMinute = Integer.parseInt(st.nextToken());
						%>
							<div class="reservation">
							<b><%=iHour%>시 <%=iMinute%>분 예약<br></b>
							고객 id:<b><%=cus_id %></b> 
							<%
								
								try{
									String sql3 = "SELECT * FROM Customer WHERE oid =?";//고객 id로 고객 정보를 불러온다
									stmt3 = conn.prepareStatement(sql3);
									stmt3.setString(1,cus_id);
									rs3 = stmt3.executeQuery();
									while(rs3.next()){
							%>
								고객 이름: <b><%=rs3.getString("name")%></b><br>
								전화번호: <b><%=rs3.getString("phoneNumber")%></b><br>
								마일리지: <b><%=rs3.getString("mileage") %></b><br>
							<% 
								} 
							} catch (SQLException ex){
									out.println(ex);
									out.println("고객 정보를 가져오는 데 실패했습니다.");
								} finally{
									if(rs3 != null)
										rs3.close();
									if(stmt3 != null)
										stmt3.close();
								}
								%>
							인원: <%=rs2.getString("covers") %><br>
							테이블 번호: <%=rs2.getString("table_id") %><br>
							이벤트: <%=rs2.getString("event")%><br>
							도착시간: <%=rs2.getString("arrivalTime") %><br>
							<a href="./updateReservation.jsp?id=<%=rs2.getString("oid") %>&table_id=<%=rs2.getString("table_id")%>")="btn btn-secondory" role="button">
							수정 &raquo;></a>
							<a href="#" id="delete" onclick="deleteConfirm('<%=rs2.getString("oid")%>')" class="btn btn-secondory" role="button">
							삭제 &raquo;></a>
							<a href="#" id="arrived" onclick="checkArrived('<%=rs2.getString("oid")%>')" class="btn btn-secondory" role="button">
							도착 &raquo;></a>
							</div>
						<% }
						}catch (SQLException ex){
							out.println(ex);
							out.println("reservation 테이블 호출이 실패했습니다.<br>");	
						}
					%> 
				
					
					<% if(conn != null);
					conn.close();
					if(rs2 != null)
						rs2.close();
					if(stmt2 != null)
						stmt2.close();
					
					%>
</body>
</html>