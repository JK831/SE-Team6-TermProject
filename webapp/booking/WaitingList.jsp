<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
<link rel = "stylesheet"
href = "https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"/>
<title>Waiting List</title>
</head>
<script type="text/javascript">
	function checkAddWaiting() {
		var regExpName = /^[a-zA-Z가-힣]*$/;
		var regExpNum = /^[0-9]*$/;
		var form = document.addWaiting;
		
		var name = form.name.value;
		var phoneNumber = form.phoneNumber.value;
		
		if(!regExpName.test(name)){ //공백값도 막자
			alert("이름 다시 입력해주세요!");
			form.name.focus();
			return;
		}
		if(!regExpNum.test(phoneNumber)){ // 공백값도 막자
			alert("전화번호는 숫자만 입력해주세요!");
			return;
		}
		alert('대기자 등록이 완료되었습니다!');
		form.submit();
		
	}
	function enter(phoneNumber){
		if(confirm("고객이 입장 가능합니까?") == true){
			alert('입장처리가 완료 되었습니다!');
			location.href = "./enterToTable.jsp?phoneNumber="+phoneNumber;
		}
		else
			return;
	}
	function del(waitingNum){
		if(confirm("웨이팅을 취소하시겠습니까?") == true){
			
			location.href = "./cancelWaiting.jsp?waitingNum="+ waitingNum;
		}
		else
			return;
	}
	function cancelAll(){
		if(confirm("웨이팅을 전부 없애시겠습니까?") == true){
			if(confirm("전부 삭제됩니다.")){
				alert('웨이팅 삭제가 완료 되었습니다!');
				location.href = "./cancelAllWaiting.jsp";
			}
			else
				return;
		}
		else
			return;
	}
</script>

<body>
<%@ include file="./connection.jsp" %>
<%@ include file="./menu.jsp" %>
<% String greeting = "대기자 명단"; 
String tagline = "대기자 등록 및 확인";%>
<div class = "jumbotron">
	<div class = "container">
		<h1 class = "display-3"><%= greeting %>
		</h1>
	</div>
</div>
<div class = "text-center">
	<h2>
		<%= tagline %>
	</h2>
</div>
<div>
<div class="row" align="center">
			<div class="col-md-7">
				<form name="addWaiting" action="./processAddWaiting.jsp"
					class="form-horizontal" method="post">
					<div class="form-group row">
						<label class="col-sm-3">이름</label>
						<div class="col-sm-3">
							<input type="text" id="name"
							name="name" class="form-control">
						</div>
					</div>
					<div class="form-group row">
						<label class="col-sm-3">전화번호</label>
						<div class="col-sm-3">
							<input type="text" id="phoneNumber"
							name="phoneNumber" class="form-control">
						</div>
					</div>
					<div class="form-group row">
					<div class="col-sm-offset-2 col-sm-10 ">
					<input type="button" class="btn btn-primary" value="등록" onclick="checkAddWaiting()">
					</div>
				</div>
			</form>
		</div>
	</div>
	<input type="button" value="웨이팅 리스트 초기화" onclick='cancelAll()'>
	<% 
	String sql = "SELECT * FROM waitingList";
	Statement stmt = conn.createStatement();
	ResultSet rs = stmt.executeQuery(sql);
	while(rs.next()){ %>
	<hr>
	대기번호: <%=rs.getInt("waiting_number") %>
	이름: <%=rs.getString("name") %>
	전화번호: <%=rs.getString("phoneNumber") %>
	<input type="button" value="입장" onclick="enter(<%=rs.getString("phoneNumber")%>">
	<input type="button" value="취소" onclick="del(<%=rs.getInt("waiting_number")%>">
	<hr>
	<%
	}
	if(rs!=null)
		rs.close();
	if(stmt!=null)
		stmt.close();
	%>
</div>
</body>
</html>