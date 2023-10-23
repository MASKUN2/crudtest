<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String[] alias = {"teamName", "teamCount", "teamBegin","teamEnd"}; // 조회할 파라메터를 명세하기
	for(int i = 0; i < alias.length; i += 1){ // 조회한 리퀘스트 파라메터값이 널이거나 공란인경우 ?fail=leak 로 이전페이지로 보냄
		if(request.getParameter(alias[i]) == null || request.getParameter(alias[i]) == ""){
			response.sendRedirect(request.getContextPath()+"/updateTeamForm.jsp?fail=leak&teamNo="+request.getParameter("teamNo"));
			return;
		}
	}

	//updateTeamAction.jsp
	int teamNo = Integer.parseInt(request.getParameter("teamNo"));
	String teamName = request.getParameter("teamName");
	int teamCount = Integer.parseInt(request.getParameter("teamCount"));
	String teamBegin = request.getParameter("teamBegin");
	String teamEnd= request.getParameter("teamEnd");

	//Driver 설정
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("-----드라이버 로딩완료");
	String url = "jdbc:mariadb://localhost:3306/gdj72" ;
	String dbuser = "root";
	String dbpw = "java1234";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	System.out.println("-----db접속성공");	
	
	//별칭을 제외한 쿼리문을 지정
	String sql = ("UPDATE team set team_name = ?, team_count = ?, team_begin = ?, team_end = ?, updatedate = NOW() where team_no = ?");
	PreparedStatement stmt = conn.prepareStatement(sql); // PreparedStatement 안에 쿼리 저장
	
	//stmt쿼리의 빈 인자를 String[] alias로 채워서 최종 쿼리문을 완성하기
	stmt.setString(1, teamName);
	stmt.setInt(2,teamCount);
	stmt.setString(3,teamBegin );
	stmt.setString(4,teamEnd );
	stmt.setInt(5, teamNo);
	
	System.out.println(stmt);// 쿼리문의 콘솔디버깅

	System.out.println(stmt + "<-- stmt"); // 쿼리 디버깅 

	int row = stmt.executeUpdate();
	if(row == 1) {
		System.out.println("[SQL]---------성공");
		response.sendRedirect(request.getContextPath()+"/teamList.jsp");
		
	}else{
		System.out.println("[SQL]---------실패");
		response.sendRedirect(request.getContextPath()+"/updateTeamForm.jsp?teamNo="+teamNo+"&fail=true");
		return;
	}
%>