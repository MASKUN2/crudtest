<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String[] alias = {"empName"}; // 조회할 파라메터를 명세하기
	for(int i = 0; i < alias.length; i += 1){ // 조회한 리퀘스트 파라메터값이 널이거나 공란인경우 ?fail=leak 로 이전페이지로 보냄
		if(request.getParameter(alias[i]) == null || request.getParameter(alias[i]) == ""){
			response.sendRedirect(request.getContextPath()+"/updateEmpForm.jsp?fail=leak&empNo="+request.getParameter("empNo"));
			return;
		}
	}	

	int empNo = Integer.parseInt(request.getParameter("empNo"));
	String empName = request.getParameter("empName");
	
	System.out.println(empNo + "<-- empNo"); // 쿼리 디버깅 
	
	Class.forName("org.mariadb.jdbc.Driver");
	String url = "jdbc:mariadb://localhost:3306/gdj72" ;
	String dbuser = "root";
	String dbpw = "java1234";	
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	
	String sql = "UPDATE emp SET emp_name = ?, updatedate = now() WHERE emp_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(2, empNo);
	stmt.setString(1, empName);
	
	System.out.println(stmt + "<-- stmt"); // 쿼리 디버깅 

	int row = stmt.executeUpdate();
	if(row == 1) {
		System.out.println("[SQL]---------성공");
		response.sendRedirect(request.getContextPath()+"/empList.jsp");
		return;
	}else{
		System.out.println("[SQL]---------실패");
		response.sendRedirect(request.getContextPath()+"/updateEmpForm.jsp?fail=true&empNo="+request.getParameter("empNo"));
		return;
	}

	//<-- 아래코드는 컨트롤 레이어 (제어)
	

%>