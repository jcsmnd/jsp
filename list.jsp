<!-- 기능구현 3가지 Myungsik Kim
	 1. 10개씩 나누고 페이징
	 2. 검색기능 넣기
	 3. DB 뜨는것에 하이퍼링크 달아서 클릭시 상세보기
 -->
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>MAIN</title>
</head>
<body bgcolor=cccccc>

<%--페이징세팅1, MySQL연결--%>
<%
	Class.forName("com.mysql.jdbc.Driver"); 

	String PageNum_temp = request.getParameter("PageNum");  //PageNum_temp 문자열 생성해서 PageNum 파라미터값 받음
	if(PageNum_temp==null)PageNum_temp = "1"; //만약 값이 NULL값이면 초기값을 1페이지로 세팅
	int PageNum = Integer.parseInt(PageNum_temp); //그 값을 PageNum에 대입
	int PagePerNum = 10; //페이지당 게시물 갯수 
	int totalData = 0; //전체 행의 갯수
	String searchKey=""; //검색할 문자열

	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/test_1","root","123123"); 
	Statement stmt = conn.createStatement(); 
	Statement stmt2 = conn.createStatement();
	
	String sql = "select * from db_list2 limit "+((PageNum-1)*PagePerNum)+","+(PagePerNum)+";";	//limit 쿼리문
	String total = "select count(*) cnt from db_list2;";  //전체 행의 갯수 구하는 쿼리문
	
	ResultSet rs = stmt.executeQuery(sql); 
	ResultSet rs2 = stmt2.executeQuery(total);
%>

<!-- 데이터 총합 -->
<%
	if(rs2.next()){ //Data의 총합구하는 식
		totalData = rs2.getInt(1);
  	}
%>
MySQL 테이블 행 총개수=<%=totalData%>

<!-- 검색기능 -->
<form action="search_result.jsp" method="post">
<select name="keyfield">
      <option value="1">학번</option>
</select>
	  <input type="text" name="searchKey"/>
 	  <input type="submit" value="검색"/>
</form>

<!-- 학번 하이퍼링크 세팅 -->
<%
	String Hak = request.getParameter("Hak");
%>

<!-- 행 내용 table 처리 -->
<table border = "1">
	<tr align="center">
		<td width="200">학번</td>
		<td width="200">이름</td>
	</tr>
<%
	while(rs.next()){ 
%>
	<tr align="center">
		<td><a href="test.jsp?Hak=<%=rs.getString(1)%>"><%=rs.getString(1)%></a> </td> <!-- 학번 -->
		<td><%=rs.getString(2)%></td> <!-- 이름 -->
	</tr>
<%
	}
%>
</table>

<br><br>

<%--페이징세팅2, href 하단 네비게이션 처리부분 --%>
<% 
	int PageBlock = 5; //페이징 블럭 갯수 (5개씩)
	int pageCount = totalData/PagePerNum+(totalData%PagePerNum==0?0:1);  //페이징 개수 전체 카운트
	int startPage = (PageBlock*((PageNum-1)/PageBlock))+1; //시작페이지
	int endPage = startPage+(PageBlock-1);      		   //끝페이지

	if(pageCount < endPage)  endPage = pageCount;          //마지막 페이지가 전체 페이징 개수 보다 크면 값을 같게 한다.
	if(startPage > PageBlock) {                            //시작 페이지가 블럭갯수보다 크면 [이전] 버튼 생성 
%>                                                                      
<a href="list.jsp?PageNum=<%=startPage-1%>">[이전]</a>
<%
	}
	for(int i=startPage; i<=endPage; i++){                 //현재 페이지이면 링크 없애는 기능
		if(PageNum == i){                                  //시작페이지가 현재 페이지와 같으면 
%>
[<%=i%>]                                               <!-- 링크를 없앤다. -->
<%
		}else{ 
%>                                           <!-- 만악 다르면 -->
<a href="list.jsp?PageNum=<%=i%>">[<%=i%>]</a>         <!-- 링크를 걸어준다. -->
<% 
		}	
   }
   if(endPage<pageCount) {  						   //마지막 페이지보다 전체 페이징 개수가 크면
%>                                                          
<a href="list.jsp?PageNum=<%=startPage+PageBlock%>">[다음]</a> <!-- 다음 페이지를 보여준다. -->
<% 
   }
%>

<%
stmt.close();
stmt2.close();
conn.close();
%>
</body>
</html>