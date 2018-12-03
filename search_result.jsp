<!-- Myungsik Kim -->
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>검색결과</title>
</head>
<body bgcolor=cccccc>
<%
	Class.forName("com.mysql.jdbc.Driver"); 
	String searchKey = request.getParameter("searchKey");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/test_1","root","123123"); 
	Statement stmt = conn.createStatement();
	String search = "select * from db_list2 where num ='"+searchKey+"';"; 
	ResultSet rs = stmt.executeQuery(search);
	
%>

<%
	if(rs.next()){ 
%>
<h3>결과 내용:</h3><br>
<table border = "1">
	<tr align="center">
		<td width="200">학번</td>
		<td width="200">이름</td>
	</tr>

	<tr align="center">
		<td><%=rs.getString(1)%></td> <!-- 학번 -->
		<td><%=rs.getString(2)%></td> <!-- 이름 -->
	</tr>
</table>
	<%}else%><h1>검색결과 없음</h1>
<%
stmt.close();
conn.close();
%>
</body>
</html>