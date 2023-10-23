<%@page import="vo.Emp"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("드라이버 로딩성공");
	String url = "jdbc:mariadb://localhost:3306/gdj72" ;
	String dbuser = "root";
	String dbpw = "java1234";
	
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	System.out.println("db접속성공");
	
	int empNo = Integer.parseInt(request.getParameter("empNo"));
	Emp e = new Emp();
	
	String sql = "SELECT emp_no AS empNo, emp_name AS empName, createdate, updatedate FROM emp WHERE emp_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, empNo);
	
	ResultSet rs = stmt.executeQuery();
	//여기까지가 모델레이어.
	
	if(rs.next()){
		e.empNo = rs.getInt("empNo");
		e.empName = rs.getString("empName");
		e.createdate = rs.getString("createdate");
		e.updatedate = rs.getString("updatedate");
	}
%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<div class="container pt-5">
	<h1>emp 수정</h1>
	<form action="<%=request.getContextPath()%>/updateEmpAction.jsp">
		<table  class="table table-striped">
			<tr>
				<td>emp_no</td>
				<td>
				<input type="text" name="empNo" value="<%=e.empNo%>" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td>emp_name</td>
				<td>
					<input type="text" name="empName" value="<%=e.empName%>">
				</td>
			</tr>
			<tr>
				<td>createdate</td>
				<td><%=e.createdate %></td>
			</tr>
			<tr>
				<td>updatedate</td>
				<td><%=e.updatedate %></td>
			</tr>
			<tr>
				<td colspan="2"><button type="submit">수정</button></td>
			</tr>
		</table>
	</form>
	<%
		// 액션 페이지에서 ?fail= 값을 받으면 아래의 알림을 출력함
		if(request.getParameter("fail") != null) {
			String faillog = request.getParameter("fail");
			switch(faillog){
			
			case "leak" :
	%>
				<h3 style="color: red;"> 실패: 빈 값이 입력되었습니다.</h3>
	<%
				break;
		
			case "true" :
	%>
				<h3 style="color: red;"> 실패: 비밀번호가 틀렸습니다.</h3>
	<%
				break;		
			}
		}
	%>
</div>
</body>
</html>