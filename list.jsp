<!-- ��ɱ��� 3���� Myungsik Kim
	 1. 10���� ������ ����¡
	 2. �˻���� �ֱ�
	 3. DB �ߴ°Ϳ� �����۸�ũ �޾Ƽ� Ŭ���� �󼼺���
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

<%--����¡����1, MySQL����--%>
<%
	Class.forName("com.mysql.jdbc.Driver"); 

	String PageNum_temp = request.getParameter("PageNum");  //PageNum_temp ���ڿ� �����ؼ� PageNum �Ķ���Ͱ� ����
	if(PageNum_temp==null)PageNum_temp = "1"; //���� ���� NULL���̸� �ʱⰪ�� 1�������� ����
	int PageNum = Integer.parseInt(PageNum_temp); //�� ���� PageNum�� ����
	int PagePerNum = 10; //�������� �Խù� ���� 
	int totalData = 0; //��ü ���� ����
	String searchKey=""; //�˻��� ���ڿ�

	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/test_1","root","123123"); 
	Statement stmt = conn.createStatement(); 
	Statement stmt2 = conn.createStatement();
	
	String sql = "select * from db_list2 limit "+((PageNum-1)*PagePerNum)+","+(PagePerNum)+";";	//limit ������
	String total = "select count(*) cnt from db_list2;";  //��ü ���� ���� ���ϴ� ������
	
	ResultSet rs = stmt.executeQuery(sql); 
	ResultSet rs2 = stmt2.executeQuery(total);
%>

<!-- ������ ���� -->
<%
	if(rs2.next()){ //Data�� ���ձ��ϴ� ��
		totalData = rs2.getInt(1);
  	}
%>
MySQL ���̺� �� �Ѱ���=<%=totalData%>

<!-- �˻���� -->
<form action="search_result.jsp" method="post">
<select name="keyfield">
      <option value="1">�й�</option>
</select>
	  <input type="text" name="searchKey"/>
 	  <input type="submit" value="�˻�"/>
</form>

<!-- �й� �����۸�ũ ���� -->
<%
	String Hak = request.getParameter("Hak");
%>

<!-- �� ���� table ó�� -->
<table border = "1">
	<tr align="center">
		<td width="200">�й�</td>
		<td width="200">�̸�</td>
	</tr>
<%
	while(rs.next()){ 
%>
	<tr align="center">
		<td><a href="test.jsp?Hak=<%=rs.getString(1)%>"><%=rs.getString(1)%></a> </td> <!-- �й� -->
		<td><%=rs.getString(2)%></td> <!-- �̸� -->
	</tr>
<%
	}
%>
</table>

<br><br>

<%--����¡����2, href �ϴ� �׺���̼� ó���κ� --%>
<% 
	int PageBlock = 5; //����¡ �� ���� (5����)
	int pageCount = totalData/PagePerNum+(totalData%PagePerNum==0?0:1);  //����¡ ���� ��ü ī��Ʈ
	int startPage = (PageBlock*((PageNum-1)/PageBlock))+1; //����������
	int endPage = startPage+(PageBlock-1);      		   //��������

	if(pageCount < endPage)  endPage = pageCount;          //������ �������� ��ü ����¡ ���� ���� ũ�� ���� ���� �Ѵ�.
	if(startPage > PageBlock) {                            //���� �������� ���������� ũ�� [����] ��ư ���� 
%>                                                                      
<a href="list.jsp?PageNum=<%=startPage-1%>">[����]</a>
<%
	}
	for(int i=startPage; i<=endPage; i++){                 //���� �������̸� ��ũ ���ִ� ���
		if(PageNum == i){                                  //������������ ���� �������� ������ 
%>
[<%=i%>]                                               <!-- ��ũ�� ���ش�. -->
<%
		}else{ 
%>                                           <!-- ���� �ٸ��� -->
<a href="list.jsp?PageNum=<%=i%>">[<%=i%>]</a>         <!-- ��ũ�� �ɾ��ش�. -->
<% 
		}	
   }
   if(endPage<pageCount) {  						   //������ ���������� ��ü ����¡ ������ ũ��
%>                                                          
<a href="list.jsp?PageNum=<%=startPage+PageBlock%>">[����]</a> <!-- ���� �������� �����ش�. -->
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