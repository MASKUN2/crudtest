<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	int empNo = Integer.parseInt(request.getParameter("empNo"));
	System.out.println(empNo + "<-- empNo"); // 쿼리 디버깅 
	
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://localhost:3306/gdj72" ;
	String dbuser = "root";
	String dbpw = "java1234";	
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	
	String sql = "DELETE FROM emp WHERE emp_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, empNo);
	System.out.println(stmt + "<-- stmt"); // 쿼리 디버깅 

	int row = stmt.executeUpdate();
	if(row == 1) {
		System.out.println("[SQL]---------삭제성공");
	}else{
		System.out.println("[SQL]---------삭제실패");
	}

	//<-- 아래코드는 컨트롤 레이어 (제어)
	response.sendRedirect(request.getContextPath()+"/empList.jsp");

%>