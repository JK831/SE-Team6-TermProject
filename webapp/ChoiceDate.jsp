<%@ page contentType="text/html; charset=utf-8" %>
<html>
<head>
<link rel = "stylesheet"
	href = "https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"/>
<link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css"/>
<style>
*{
		margin:0;
		padding:0;
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

</style>

<script src="//code.jquery.com/jquery.min.js"></script>
<script src="//code.jquery.com/ui/1.11.4/jquery-ui.min.js"></script>
<script>
function checkDate(){//유효성 검사
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
	minDate: 0,
    dateFormat: 'yy-mm-dd'
  });
});
</script>
<title>날짜 조회</title>
</head>
<body>
<%@ include file="./menu.jsp" %>
	<% String greeting = "날짜 선택"; 
	String tagline = "예약 날짜를 선택하세요";%>
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
	<div class="calendarContainer">
	<form name="choiceDate" class="center" action="./CheckReservation.jsp">
		<input type="text" name="date" id="datepicker1">
		<input type="button" class="btn btn-primary" value="조회" onclick="checkDate()">
	</form>
	</div>
</body>
</html>