<%@ page import="java.sql.*"%>
<html>
<head>
<title>Database SQL</title>
</head>
<body>
	<%
		Connection conn = null;
		try {
			String url = "jdbc:mariadb://127.0.0.1:3306/restaurant_booksys";
			String user = "rhe";
			String password = "ad972530";
			
			Class.forName("org.mariadb.jdbc.Driver");
			conn = DriverManager.getConnection(url, user, password);
		} catch (SQLException ex) {
			out.println("데이터베이스 연결이 실패했습니다.<br>");
			out.println("SQLException: "+ ex.getMessage());
		} finally {
			
		}
	%>
</body>
</html>