<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.StringTokenizer" %>
<%@ page import="java.time.LocalTime" %>
   <% String greeting = "예약";
   
   String tagline;
   if(request.getParameter("date")==null){
      tagline = "";
   }
   else{
   tagline = request.getParameter("date");
   }%>
   <div class = "jumbotron">
      <div class = "container">
         <p><%= greeting %></p>
         
      </div>
   </div>
   <div class = "text-center">
         <p>
            <%= tagline %> 
         </p>
   </div>
   <div class="visibleInMobile">
      <div class="cannotColor"></div><div>예약불가</div>
   </div>
   <div class="calendarContainer">
   <form name="choiceDate" class="center" action="./Main.jsp">
      <input type="text" name="date" id="datepicker1" placeholder="년-월-일"><br />
      <input type="button" class="btn btn-primary" value="조회" onclick="checkDate()">
   </form>
   </div>
<%@ include file="./connection.jsp" %>
   <%
   int reservationNum = 0;
   int tableNum = 0;
   int operatingHour = 20;//30분 단위로 출력할 것이므로 시간 * 2 를 해준 값이다.
   int openTime = 11;
   int overTime = 21;
   String requestDate = request.getParameter("date");
   
   
   
   SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
   SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm:ss");
   
   if(requestDate == null){
      requestDate = dateFormat.format(java.sql.Date.valueOf(LocalDate.now()));//요청받은 날짜가 따로 없다면 오늘 날짜로 설정
   }
   
   Date dateNow = new Date();
   String[] nowDateSet = dateFormat.format(dateNow).split("-");
   String[] nowTimeSet = timeFormat.format(dateNow).split(":");//현재 시간을 토큰 단위로 문리하여 문자열로 저장
   String[] requestDateSet = requestDate.split("-");//요청 받은 날짜를 토큰 단위로 분리하여 저장
   
   int year = Integer.valueOf(nowDateSet[0]);
   int month = Integer.valueOf(nowDateSet[1]);
   int today = Integer.valueOf(nowDateSet[2]);
   int nowTime = Integer.valueOf(nowTimeSet[0]); //현재 시간
   
   int requestYear = Integer.valueOf(requestDateSet[0]);
   int requestMonth = Integer.valueOf(requestDateSet[1]);
   int requestDay = Integer.valueOf(requestDateSet[2]);
   
   Statement stmt = null;
   ResultSet rs = null;
   PreparedStatement pstmt = null;
   ResultSet rs2 = null;
   
   
   String sql = "SELECT * FROM operatingHour";
   stmt=conn.createStatement();
   rs = stmt.executeQuery(sql);
   while(rs.next()){
      openTime = rs.getInt("open_time");
      overTime = rs.getInt("over_Time");
   }
   
   operatingHour = (overTime - openTime) * 2;
   
   stmt= conn.createStatement();
   sql = "select * from `Table` order by number desc limit 1";
   rs = stmt.executeQuery(sql);
   while(rs.next()){
      tableNum = Integer.valueOf(rs.getString("number"));
   }
   
   java.sql.Date date;
   LocalDate todaysDate = LocalDate.now();
   
   if(request.getParameter("date")==null){
      date = java.sql.Date.valueOf(todaysDate);
   }
   else{
      date = java.sql.Date.valueOf(request.getParameter("date"));
   }
   
   String sql2 = "select * from Reservation where date=? and table_id = ? order by time";//해당 날짜, 테이블 번호의 예약내역
   
   boolean flag[][] = new boolean[tableNum][operatingHour];//예약 가능 여부를 판단하는 flag
   for(int i = 0; i < tableNum; i++){
      for(int j = 0; j < operatingHour ; j++){
         flag[i][j] = true;//먼저 true로 설정해준다.
      }
   }
   
   if(Integer.valueOf(requestDateSet[0])<year || Integer.valueOf(requestDateSet[1])<month || Integer.valueOf(requestDateSet[2])<today){
      for(int i = 0; i < tableNum; i++){
         for(int j = 0; j < operatingHour ; j++){
            flag[i][j] = false;//오늘 이전의 날짜는 모두 false로 만들어 준다.
         }
      }
   }
   
   for(int i = 0; i < tableNum; i++){
      
   }
      
   
   for(int i = 1; i <= tableNum; i++){
      pstmt = null;
      pstmt = conn.prepareStatement(sql2);
      pstmt.setDate(1,date);
      pstmt.setInt(2,i);
      rs2 = pstmt.executeQuery();
      int j = 0;
      int x = 0;
      
      if(Integer.valueOf(nowTimeSet[0])>overTime)
         nowTime = overTime;
      
      if(requestDay==today){//오늘의 예약들은
      for(int k = 0; k < (nowTime - openTime); k++){//현재 시간 이전의 예약은 비 활성화 
         if(k< nowTime){
         flag[i-1][2*k] = false;
         flag[i-1][2*k+1] = false;
         }
         else{
            flag[i-1][2*k] = false;
         if(Integer.valueOf(nowTimeSet[1])<=10)// 해당 예약시간 20분 전까지만 예약 가능
            flag[i-1][2*k+1] = true;
         if(Integer.valueOf(nowTimeSet[1])<=40)// 마찬가지
            flag[i-1][2*k+2] = true;
         }
      }
      }
      while(rs2.next()){
         String time = rs2.getString("time");
         String[] timeSet = time.split(":");
         StringTokenizer st = new StringTokenizer(time,":");
         time = st.nextToken();//hh:mm:ss에서 hh, 시간을 받아온다
         String minute = st.nextToken();
         int intTime = Integer.valueOf(timeSet[0]) - openTime; //11시가 오픈타임으로 가정
         
         if(timeSet[1].equals("00")){//해당 시간 정각에 예약이 있다면
            if (intTime==0){
            flag[i-1][intTime] = false; //오픈 시간 예약이라면
            flag[i-1][intTime+1] = false;//30분 후의 예약 비활성화
            }
            else{
               flag[i-1][2*intTime] = false;
               flag[i-1][2*intTime-1] = false;//30분 전의 예약 비활성화
               flag[i-1][2*intTime+1] = false;//30분 후의 예약 비활성화
            }
         }
         else if(timeSet[1].equals("30")){//30분에 예약이 있다면
            
            //intTime은 똑같지만 30분 예약이므로 intTime(intTime:00:00)과 자기자신(intTime:30:00), 30분 후의 예약 비활성화   
            flag[i-1][2*intTime] = false;//30분 전의 예약 비활성화
            flag[i-1][2*intTime+1] = false;
            flag[i-1][2*intTime+2] = false;//30분 후의 예약 비활성화
         
         }
         x+=2;
      }
      
      if(pstmt!=null)
         pstmt.close();
   }
   %>
   <div class="containerTable">
   <%for(int i = 1; i <= tableNum; i++){
      int x=0;
   %>
   <div class="title">
      <div class="tableNum"><%=i %>번 테이블</div>
      <%for(int j = 0; j < operatingHour; j++){
         %>
      <%if(flag[i-1][j]==true){%>
         <div class="reservation">
         <%if(j%2==0){%>
            <div class="visibleAlways"><a href="./CustomerReservation.jsp?date=<%=date %>&tableNum=<%=i %>&time=<%=j+openTime-x %>:00:00"><%=j+openTime-x %>:00</a></div>
            <div class="hiddenInMobile">
            <a href="./CustomerReservation.jsp?date=<%=date %>&tableNum=<%=i %>&time=<%=j+openTime-x %>:00:00" class="btn btn-secondory" role="button">
                     예약하기 &raquo;></a></div>
         <%
         x++;//j가 정각을 나타낼 때 2씩 증가하므로 그에 맞춰 x를 1씩 증가시킨다.
         }
         else{%>
            <div class="visibleAlways"><a href="./CustomerReservation.jsp?date=<%=date %>&tableNum=<%=i %>&time=<%=j+openTime-x %>:30:00"><%=j+openTime-x %>:30</a></div>
            <div class="hiddenInMobile">
            <a href="./CustomerReservation.jsp?date=<%=date %>&tableNum=<%=i %>&time=<%=j+openTime-x %>:30:00" class="btn btn-secondory" role="button">
                     예약하기 &raquo;></a></div>
            
         <% }%>
         </div>
      <%   
      }
      else{%>
      <div class="cannotReservation">
         <%if(j%2==0){%>
            <div class="visibleAlways"><%=j+openTime-x %>:00</div>
            <div class="hiddenInMobile"><p>예약 불가능<br></p></div>
         <%
         x++;//j가 정각을 나타낼 때 2씩 증가하므로 그에 맞춰 x를 1씩 증가시킨다.
         }
         else{%>
            <div class="visibleAlways"><%=j+openTime-x %>:30<br></div>
            <div class="hiddenInMobile"><p>예약 불가능<br></p></div>
         <%}%>
         </div>
      <%}
      }%>
      </div>
   <%}
      %>
   </div>
   <%
   if(conn != null);
   conn.close();
   if(rs != null)
      rs.close();
   if(stmt != null)
      stmt.close();
   if(rs2 != null)
      rs2.close();
   if(pstmt != null)
      stmt.close();
   if(conn!=null)
      conn.close();
   %>