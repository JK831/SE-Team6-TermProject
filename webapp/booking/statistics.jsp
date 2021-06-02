<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.StringTokenizer" %>
<%@ page import="java.time.LocalTime" %>
<!DOCTYPE HTML>
<html>
<head>
<link rel = "stylesheet"
	href = "https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"/>
	<style>
		table{
			border:1px solid black;
			text-align: center;
		}
	</style>
	<title>이용 통계</title>
</head>
<body>
	<%@ include file="./menu.jsp" %>
	<%@ include file="./connection.jsp" %>
	<%
	  
		Statement stmt = null;
	  	PreparedStatement pstmt = null;
	  	ResultSet rs = null;
	  	ResultSet rs2 = null;
	  	
	  	int totalReservation = 0;
	  	int N = 12; // Month 설정
	  	int[] monthArray = new int[N+1]; // 매달 마다의 사용횟수를 기록하는 자료구조
	  	String data;
	  	String token;
	  	int tableNum = 0;
		int totalCount = 0;
		int lastCustomerId = 0;
		boolean existanceReservation = false;
		
		String sql = "select * from reservation";
		stmt = conn.createStatement();
		rs = stmt.executeQuery(sql);
		while(rs.next()){
			totalReservation++;
		}
		if(totalReservation==0){
			out.println("예약내역이 존재 하지 않습니다");
		}
		else{
	%>
		<table>
		<tr><th>총 예약건수</th><td><%=totalReservation %></td></tr>
		 </table>
	<%	  
		}
		  for(int i = 0; i<=N; i++) // 자료구조 초기화
			  monthArray[i] = 0;
		  
		  sql = "select date from reservation";
		  stmt = conn.createStatement();
		  rs = stmt.executeQuery(sql);
		  
		  
		  while(rs.next()){
			  data = rs.getString("date");
			  StringTokenizer st = new StringTokenizer(data, "-");
			  st.nextToken();
			  token = st.nextToken();
			  
			  if(token != "10") // 10월을 제외하고 01, 02, ... 등에대한 앞글자 0 을 제거한다.
				  token = token.replace("0","");
			  
			  int monthData = Integer.parseInt(token); // 월 에 대한 string을 최종적으로 monthData라는 변수에 int형으로 저장
			  
			  monthArray[monthData]++;
		  }
		%>
		<br>
		<div>올해 월별 이용 횟수</div>
		<table>
		<tr><th>1월</th><th>2월</th><th>3월</th><th>4월</th><th>5월</th><th>6월</th>
		<th>7월</th><th>8월</th><th>9월</th><th>10월</th><th>11월</th><th>12월</th></tr>
		<tr>
		<%
		  for(int i = 1; i <= N; i++) {%>
		  	<td><%=monthArray[i] %></td>
		  <%
		  }
		%>
		</tr>
		</table>
		<br>
		<%
		sql = "select oid from `Table` order by oid desc limit 1";
		pstmt = conn.prepareStatement(sql);
		rs = pstmt.executeQuery();
		while(rs.next()){
			tableNum = rs.getInt("oid");
		}
		
		if(tableNum==0){%>
			<div>테이블이 존재하지 않습니다.</div>
		<%}
		else{
			int[] tableRank = new int[tableNum];
			int[] tableNumber = new int[tableNum];
			int tmp1=0;
			
			for(int i = 0; i <tableNum; i++){
				tableNumber[i]= i+1;
				tableRank[i] = 0;
			}
			
			
			for(int i = 1; i<=tableNum; i++){
				sql = "select * from Reservation where table_id=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1,i);
				rs = pstmt.executeQuery();
				while(rs.next()){
					tableRank[i-1]++;
				}
				
			
			}
			for(int i=0; i < tableNum; i++) { // 선택정렬로 table 순서 내림차순으로 설정
				for(int j=i+1; j< tableNum; j++) {
					if(tableRank[j] > tableRank[i]) {
						int tmp = tableRank[i];
						tmp1 = tableNumber[i];
						tableRank[i] = tableRank[j];
						tableNumber[i] = tableNumber[j];
						tableRank[j] = tmp;
						tableNumber[j]=tmp1;
					}
					
				}
		  }
			
			
			
			%>
			<br>
			<div>많이 이용한 테이블 순서</div>
			<table>
			<tr>
				<th>테이블 번호</th><th>이용횟수</th>
			</tr>
				<%for(int i =0; i < tableNum; i++){%>
				<tr>
				<td><%=tableNumber[i] %></td><td><%=tableRank[i] %></td>
				</tr>
				<%}%>
			</table>
			<%	
		}
		sql = "select oid from Customer order by oid desc limit 1";
		
		
		stmt = conn.createStatement();
		rs = stmt.executeQuery(sql);
		  
		  
		while(rs.next()){
			lastCustomerId = rs.getInt("oid");
		}
		
		if(lastCustomerId==0){
			out.println("고객 정보가 존재하지 않습니다");
		}
		else {
			%>
			<br>
			<div>고객 정보</div>
			<table>
			<tr>
				<th>이름</th><th>전화번호</th><th>마일리지</th><th>이용 횟수</th>
			</tr>
			<%
			for(int i = 1; i < lastCustomerId; i++){%>
				<tr><%
				sql = "select * from Reservation WHERE customer_id=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1,i);
				rs = pstmt.executeQuery();
				while(rs.next()){
					totalCount++;
				}
				
				sql = "select * from Customer WHERE oid=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1,i);
				rs2 = pstmt.executeQuery();
				while(rs2.next()){
					%><td><%=rs2.getString("name") %></td><td><%=rs2.getString("phoneNumber") %></td><td><%=rs2.getInt("mileage") %></td>
					<td><%=totalCount %></td>
					<%
				}
				%>
				</tr>
		<%	
		totalCount=0;
		existanceReservation = true;
		
			}
			%>
			</table>
		<%
		if(!existanceReservation){
			out.println("예약내역이 존재하지 않습니다.");
		}
		
		}
		
	%>
</body>
</html>