<%@ page contentType="text/html; charset=utf-8" %>
<html>
<head>
<link rel = "stylesheet"
	href = "https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"/>
	
<title>예약 확인</title>
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
</style>
<script>
function checkValidation() {
		
		var regExpNum = /^[0-9]*$/;
		var regExpPhoneNum = /^\d{11}$/;
		var form = document.checkSelfReservation;
		var phoneNumber = form.phoneNumber.value;
		if(!regExpNum.test(phoneNumber)||!regExpPhoneNum.test(phoneNumber)){
			alert("전화번호는 11자리 숫자만 입력해주세요!")
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
			<h1>예약 확인</h1>
		</div>
	</div>
		<div class = "text-center">
			<h5>
				전화 번호를 입력하세요
			</h5>
		</div>
		<div class = "text-center">
			<form name="checkSelfReservation" action="./processFindReservation.jsp">
				<label>전화번호</label><input type="text" id="phoneNumber" name="phoneNumber">
				<input type="button" class="btn btn-primary" value="조회" onclick="checkValidation()">
			</form>
		</div>
</body>
</html>