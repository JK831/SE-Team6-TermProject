<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>

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
		
		.row{
			justify-content: center;
		}
		@media screen and (min-width: 761px){
			.container p{
				font-size:calc(1.525rem + 3.3vw);
				font-weight:300;
				line-height:1.2
			}
			.text-center p{
				font-size:calc(1.2rem + 2.2vw);
				font-weight:150;
				line-height:1.2;
			}
		}
	
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
		
	
	}
	</style>
<title>예약 등록</title>
<script type="text/javascript">
	function checkAddReservation() {
		
		var regExpName = /^[a-z|A-Z|가-힣]*$/;
		var regExpNum = /^[0-9]*$/;
		var form = document.addReservation;
		
		var name = form.name.value;
		var phoneNumber = form.phoneNumber.value;
		
		if(name ==""){
			alert("이름을 입력해주세요");
			form.name.focus();
			return;
		}
		
		if(phoneNumber == ""){
			alert("전화번호를 입력해주세요");
			form.phoneNumber.focus();
			return;
		}
		
		if(!regExpName.test(name)){
			alert("이름은 알파벳, 한글만 입력해주세요!");
			form.name.focus();
			return;
		}
		else if(!regExpNum.test(phoneNumber)){
			alert("전화번호는 숫자만 입력해주세요!");
			form.phoneNumber.focus();
			return;
		}
		else{
			form.submit();
		}
		
	}
</script>

</head>
<body>
<%@ include file="./menu.jsp" %>
	<div class = "jumbotron">
		<div class = "container">
			<h1>예약 등록</h1>
		</div>
	</div>
	<div class = "text-center">
		<h5>정보를 입력하세요</h5>
	</div>
	<%@ include file="./connection.jsp" %>
	<%
		String date = request.getParameter("date"); //예약 날짜
		int tableNum = Integer.valueOf(request.getParameter("tableNum")); //테이블 번호
		String time = request.getParameter("time"); //예약 시간
		int covers = 0;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "select * from `Table` where oid = ?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, tableNum);
		rs = pstmt.executeQuery();
		if(rs.next()){
			covers = Integer.valueOf(rs.getString("places"));//해당 테이블의 수용 가능 인원을 불러온다.
		}
	%>
	
	
	<div class="container">
		<br>
		<div class="row" align="center">
			<div class="col-md-7">
				<form name="addReservation" action="./processAddReservation.jsp?date=<%=date %>&time=<%=time %>&tableNum=<%=tableNum %>"
					class="form-horizontal" method="post">
					
					<div class="form-group row">
						<label class="col-sm-2">예약 날짜</label>
						<div class="col-sm-3">
							<%=date %>
						</div>
					</div>
					<div class="form-group row">
						<label class="col-sm-2">예약 시간</label>
						<div class="col-sm-3">
							<%=time %>
						</div>
					</div>
					<div class="form-group row">
						<label class="col-sm-2">테이블</label>
						<div class="col-sm-3">
							<%=tableNum %>								
						</div>
					</div>
					<div class="form-group row">
						<label class="col-sm-2">이름</label>
						<div class="col-sm-3">
							<input type="text" id="name"
							name="name" class="form-control">
						</div>
					</div>
					<div class="form-group row">
						<label class="col-sm-2">전화번호</label>
						<div class="col-sm-3">
							<input type="text" id="phoneNumber"
							name="phoneNumber" class="form-control">
						</div>
					</div>
					<div class="form-group row">
						<label class="col-sm-2">인원</label>
						<div class="col-sm-3">
							<select name="covers">
								<%for(int i = 1; i<=covers; i++){ %>
									<option value="<%=i %>"><%=i %></option>
									<%} %>
							</select>
						</div>
					</div>
					<div class="form-group row"><br>이벤트 준비가 필요하다면 적어주세요.</div>
					<div class="form-group row">
						<div class="col-sm-3">
							<textarea name="event" cols="30" rows="3"></textarea>
						</div>
					</div>
					<div class="form-group row">
						<div class="col-sm-offset-2 col-sm-10 ">
							<input type="button" class="btn btn-primary" value="등록" onclick="checkAddReservation()">
						</div>
					</div>
				</form>
			</div>
		</div>
	</div>		
		<%
		if(conn != null);
		conn.close();
		if(rs != null)
			rs.close();
		if(pstmt != null)
			pstmt.close();
		%>
</body>
</html>