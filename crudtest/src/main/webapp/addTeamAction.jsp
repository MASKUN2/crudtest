<%@page import="java.util.Enumeration"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//addTeamAction.jsp
	String parameter[] = {"team_name","team_count","team_begin","team_end"}; // 조회할 파라메터를 명세하기
	for(int i = 0; i < parameter.length; i += 1){ // 조회한 리퀘스트 파라메터값이 널이거나 공란인경우 ?fail=leak 로 이전페이지로 보냄
		if(request.getParameter(parameter[i]) == null
			|| request.getParameter(parameter[i]) == ""){
			response.sendRedirect(request.getContextPath()+"/addTeamForm.jsp?fail=leak");
			return;
		}
	}
	//DB접속
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("드라이버 로딩성공");
	String url = "jdbc:mariadb://localhost:3306/gdj72" ;
	String dbuser = "root";
	String dbpw = "java1234";
	
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	System.out.println("db접속성공");
	
	//컬럼을 결합하기 위한 변수
	String columnsConcat = "";
	//컬럼을 , 단위로 결합하는 알고리즘
	for(int i = 0; i < parameter.length; i += 1){
		columnsConcat += (parameter[i]+", ");
	}
	String sql = "INSERT INTO team("+columnsConcat+"createdate, updatedate) VALUES(?, ?, ?, ?, NOW(), NOW())";
	PreparedStatement stmt = conn.prepareStatement(sql);
	for(int i = 0; i < parameter.length; i += 1){ // 파라메터의 값을 하나씩 받아 SQL인자로 세팅
		stmt.setString(i+1, request.getParameter(parameter[i]));
	}
	
	System.out.println(stmt + "<-- stmt"); // SQL 문을 확인하는 디버깅코드
	
	int row = stmt.executeUpdate(); // 실행하고 인서트 문의 리턴값으로 성공은 1 실패는 0을 받음
	if(row == 1) {
		System.out.println("입력성공");
		response.sendRedirect(request.getContextPath()+"/teamList.jsp"); // 성공하면 이전페이지로
	}else{
		System.out.println("입력실패");
		response.sendRedirect(request.getContextPath()+"/addTeamForm.jsp?fail=true"); //fail=true 값으로 이전페이지로 리턴시킴
		return;
	}	
%>