<%@ page contentType="text/html; charset=utf-8" %>

<html>
<head>
	<link rel = "stylesheet"
	href = "https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"/>
	<title>레스토랑 관리 페이지</title>
	<script>
		function deleteTable(){
			if(confirm("테이블을 삭제할까요?")==true){
				alert('테이블 삭제가 완료 되었습니다!');
				location.href= "./processDeleteTable.jsp";
			}
			else
				return;
			
		}
	</script>
</head>
<body>
	<%@ include file="./menu.jsp" %>
	<% String greeting = "6조 레스토랑"; 
	String tagline = "테이블 관리";%>
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
		
		<div class = "text-center">
			<a href="./addTable.jsp"><h3>
				테이블 추가
			</h3></a>
		</div>
		<div class = "text-center">
			<a href="./updatePlaces.jsp"><h3>
				테이블 별 수용 인원 변경
			</h3></a>
		</div>
		<div class = "text-center">
			<input type="button" onclick="deleteTable();" value="테이블 삭제">
		</div>
</body>
</html>