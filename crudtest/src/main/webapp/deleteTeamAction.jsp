<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//deleteTeamAction.jsp
	
	//Driver 설정
	int teamNo = Integer.parseInt(request.getParameter("teamNo"));	
	Class.forName("org.mariadb.jdbc.Driver");
		System.out.println("[jdbc]-----드라이버 로딩완료");
	String url = "jdbc:mariadb://localhost:3306/gdj72";
	String dbuser = "root";
	String dbpw = "java1234";
		Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	System.out.println("[jdbc]-----db접속성공");

	String sqlForeKeyChck = ("SELECT * FROM student where team_no = ?");
	PreparedStatement stmtChk = conn.prepareStatement(sqlForeKeyChck); // PreparedStatement 안에 쿼리 저장
	stmtChk.setInt(1, teamNo);
	
	ResultSet rs = stmtChk.executeQuery();
	
	if(rs.next()){
		rs.close();
		stmtChk.close();
		
		response.sendRedirect(request.getContextPath()+"/teamList.jsp?teamNo="+teamNo+"&fail=forekey");
		return;
	}
	
	//인자 제외한 쿼리문을 지정
	String sql2 = ("DELETE FROM team WHERE team_no = ?");
	
	// PreparedStatement stmt 안에 쿼리 저장
	PreparedStatement stmt2 = conn.prepareStatement(sql2); 
	
	//stmt쿼리의 빈 인자를 채워서 최종 쿼리문을 완성하기
	stmt2.setInt(1, teamNo);
	System.out.println("[SQL]stmt2--------- \n" + stmt2 + "\n ----------");// 쿼리문의 콘솔디버깅

	//쿼리의 실행결과를 콘솔에 출력하기 1: 성공 0: 실패
	int row = stmt2.executeUpdate();
	
	//db에서 사용된 자원을 반환
	stmt2.close();
	conn.close();
	
	if(row == 1) {
		System.out.println("[SQL]---------삭제성공");
		//완료 후 리스트 페이지로 리다이렉트 요청
		response.sendRedirect(request.getContextPath()+"/teamList.jsp");
		return;
	}else{
		System.out.println("[SQL]---------삭제실패");
		response.sendRedirect(request.getContextPath()+"/teamList.jsp?teamNo="+teamNo+"&fail=true");
	}
	
	
	


%>