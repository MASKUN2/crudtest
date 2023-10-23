<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String[] alias = {"empName"}; // 조회할 파라메터를 명세하기
	for(int i = 0; i < alias.length; i += 1){ // 조회한 리퀘스트 파라메터값이 널이거나 공란인경우 ?fail=leak 로 이전페이지로 보냄
		if(request.getParameter(alias[i]) == null || request.getParameter(alias[i]) == ""){
			response.sendRedirect(request.getContextPath()+"/addEmpForm.jsp?fail=leak");
			return;
		}
	}

	String empName = request.getParameter("empName");
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("드라이버 로딩성공");
	String url = "jdbc:mariadb://localhost:3306/gdj72" ;
	String dbuser = "root";
	String dbpw = "java1234";
	
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	System.out.println("db접속성공");

	String sql = "INSERT INTO emp(emp_name, createdate, updatedate) VALUES(?, NOW(), NOW())";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, empName);
	System.out.println(stmt + "<-- stmt");
	int row = stmt.executeUpdate();
	if(row == 1) {
		System.out.println("입력성공");
	}else{
		System.out.println("입력실패");
	}
	//DB프로세스 종료 자원 반납 <-- 여기까지가 모델레이어
	stmt.close();
	conn.close();
	
	
	//<-- 아래코드는 컨트롤 레이어 (제어)
	response.sendRedirect(request.getContextPath()+"/empList.jsp");
%>