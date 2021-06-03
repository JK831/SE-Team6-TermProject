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
      <title>KG 6 RESTAURANT</title>
      <meta charset="utf-8" />
      <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
      <link rel= "stylesheet"
   href= "./resources/css/checkReservation.css"/>
      <link rel="stylesheet" href="./resources/css/main.css" />
<link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css"/>
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
   <body class="is-preload">

      <!-- Header -->
         <div id="header">

            <div class="top">

               <!-- Logo -->
                  <div id="logo">
                     <span class="image avatar48"><img src="resources/images/avatar.jpg" alt="" /></span>
                     <h1 id="title">KG 6</h1>
                     <p>RESTAURANT.</p>
                  </div>

               <!-- Nav -->
                  <nav id="nav">
                     <ul>
                        <li><a href="#top" id="top-link"><span class="icon solid fa-home">HOME</span></a></li>
                        <li><a href="#portfolio" id="portfolio-link"><span class="icon solid fa-th">ABOUT US</span></a></li>
                        <li><a href="#reservation" id="reservation-link"><span class="icon solid fa-user">RESERVATION</span></a></li>
                        <li><a href="#about" id="about-link"><span class="icon solid fa-user">CONFIRM</span></a></li>
                        <li><a href="#contact" id="contact-link"><span class="icon solid fa-envelope">INFORMATION</span></a></li>
                     </ul>
                  </nav>

            </div>

         </div>

      <!-- Main -->
         <div id="main">

            <!-- Intro -->
               <section id="top" class="one dark cover">
                  <div class="container">

                     <header>
                        <h2 class="alt">WELCOME. <strong>KG 6</strong><br />
                        <h6><p>감성적인 뷰로 둘러쌓여있는 최고급 레스토랑<br />
                           최상의 음식과 서비스로 보답하겠습니다.</p></h6>
                     </header>

                     <footer>
                        <a href="#portfolio" class="button scrolly">NEXT</a>
                     </footer>

                  </div>
               </section>

            <!-- Portfolio -->
               <section id="portfolio" class="two">
                  <div class="container">

                     <header>
                        <h2>ABOUT US</h2>
                     </header>

                     <p>저희 KG 6은 고객님께 최상의 서비스를 제공하기 위하여 항상 최선을 다하겠습니다.<br />
                        수원 광교산과 맞닿아 있어 감성적인 뷰를 자랑하며 감각적인 인테리어와
                        조명으로 <br />무드있고 색다른 분위기를 즐기며 식사하실 수 있는 공간이 마련되어 있습니다.
                        <br />경기대학교 출신 주방장과 셰프들이 고객님들께 최고급 요리를 선사하겠습니다.  
                     </p>

                     <div class="row">
                        <div class="col-4 col-12-mobile">
                           <article class="item">
                              <a href="#" class="image fit"><img src="./resources/images/pic02.jpg" alt="" /></a>
                              <header>
                                 <h3>김동휘</h3>
                              </header>
                           </article>
                           <article class="item">
                              <a href="#" class="image fit"><img src="./resources/images/pic03.jpg" alt="" /></a>
                              <header>
                                 <h3>송준혁</h3>
                              </header>
                           </article>
                        </div>
                        <div class="col-4 col-12-mobile">
                           <article class="item">
                              <a href="#" class="image fit"><img src="./resources/images/pic04.jpg" alt="" /></a>
                              <header>
                                 <h3>이준기</h3>
                              </header>
                           </article>
                        </div>
                        <div class="col-4 col-12-mobile">
                           <article class="item">
                              <a href="#" class="image fit"><img src="./resources/images/pic05.jpg" alt="" /></a>
                              <header>
                                 <h3>김경태</h3>
                              </header>
                           </article>
                           <article class="item">
                              <a href="#" class="image fit"><img src="./resources/images/pic06.jpg" alt="" /></a>
                              <header>
                                 <h3>이예원</h3>
                              </header>
                           </article>
                        </div>
                     </div>

                  </div>
               </section>
               
               <section id="reservation" class="three">
               <header>
                        <h2>RESERVATION</h2>
                     </header>
               <div>
                  <%@ include file="./CheckReservation.jsp" %>
               </div>
               </section>
               
               
               <!-- Contact -->
               <section id="about" class="three">
                  <div class="container">

                     <header>
                        <h2>CONFIRM</h2>
                        <p>예약 조회</p>
                     </header>
                     <form name="checkSelfReservation" action="./processFindReservation.jsp">
                        <label>전화번호</label>
                        <input type="text" id="phoneNumber" name="phoneNumber"><br />
                        <input type="button" class="btn btn-primary" value="조회" onclick="checkValidation()"><br />
                     </form>

                  </div>
                  </section>
                  <section id="contact" class="four">
                     <div class="container">
                        <header>
                           <h2>INFORMATION</h2>
                        </header>
                        <div class="d088-main-hotel-information aem-GridColumn aem-GridColumn--default--12">
                           <div class="d088 common-spacing-top--ss common-spacing-bottom--l">
                              <div class="d088__inner">
                                 <div class="d088-section">
                                    
                                    <div class="d088-section__right">
                                       <div class="d088-map">
                                          <div class="d088-map__area">
                                             <iframe class="d088-map__area" frameborder="0" style="border:0;width:100%;height:100%;" src="https://goo.gl/maps/FHuvAz2GGn3DtLBG7" allowfullscreen="" data-gtm-yt-inspected-1_25="true"></iframe>
                                          </div>
                                          <div class="d088-map__location">
                                             <br /><p>
                                                <span>Location : </span>
                                                <span>경기도 수원시 영통구 원천동 광교산로 154-42.</span>
                                             </p>
                                             <div>
                                                
                                             </div>
                                          </div>
                                       </div>
                                    </div>
                                 </div>
                                 <div class="d088-info">
                                    <div class="d088-info__time">
                                       <p class="d088-info__item">
                                          <strong>Time :</strong>
                                          <span>Lunch hour : from 12:00 ~ 2:00<br>
                                                 &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Dinner hour : from 6:00 ~ 8:00</span>
                                       </p>
                                    </div>
                                    <div class="d088-info__tel">
                                       
                                          <p class="d088-info__item">
                                             <strong>Contact No. :</strong>
                                             <span>+82 10-1234-5678</span>
                                          </p>
                                    </div>
                                 </div>
                              </div>
                           </div>
                     </div>
                     </div>
                  </section>

         </div>
      <!-- Footer -->
         <div id="footer">

            <!-- Copyright -->
               <ul class="copyright">
                  <li>KGU UNIV</li><li>CREATE BY SE@6.</a></li>
               </ul>

         </div>
         <a id="MOVE_TOP_BTN" href="#">TOP</a>
         
         <script>
    $(function() {
        $(window).scroll(function() {
            if ($(this).scrollTop() > 500) {
                $('#MOVE_TOP_BTN').fadeIn();
            } else {
                $('#MOVE_TOP_BTN').fadeOut();
            }
        });
        
        $("#MOVE_TOP_BTN").click(function() {
            $('html, body').animate({
                scrollTop : 0
            }, 600);
            return false;
        });
    });
</script>
<style>
a#MOVE_TOP_BTN {
    position: fixed;
    right: 1%;
    bottom: 50px;
    display: none;
    z-index: 999;
}
</style>

      <!-- Scripts -->
         <script src="./resouces/js/jquery.min.js"></script>
         <script src="./resources/js/jquery.scrolly.min.js"></script>
         <script src="./resources/js/jquery.scrollex.min.js"></script>
         <script src="./resources/js/browser.min.js"></script>
         <script src="./resources/js/breakpoints.min.js"></script>
         <script src="./resources/js/util.js"></script>
         <script src="./resources/js/main.js"></script>

   </body>
</html>