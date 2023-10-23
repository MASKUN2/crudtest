<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//deleteBoardAction.jsp
	
	//Driver 설정
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));	
	String boardPw = request.getParameter("boardPw");	
	
	Class.forName("org.mariadb.jdbc.Driver");
		System.out.println("[jdbc]-----드라이버 로딩완료");
	String url = "jdbc:mariadb://localhost:3306/gdj72";
	String dbuser = "root";
	String dbpw = "java1234";
		Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	System.out.println("[jdbc]-----db접속성공");

	//인자 제외한 쿼리문을 지정
	String sql = ("DELETE FROM board WHERE board_no = ? AND board_pw = ?");
	PreparedStatement stmt = conn.prepareStatement(sql); 
	
	//빈 인자를 채워서 최종 쿼리문을 완성하기
	stmt.setInt(1, boardNo);
	stmt.setString(2, boardPw);
	
	// 쿼리문의 콘솔디버깅
	System.out.println("[쿼리문]-------\n"+stmt);
	
	//쿼리의 실행결과를 콘솔에 출력하기 1: 성공 0: 실패
	int row = stmt.executeUpdate();
	if(row == 1) {
		System.out.println("[SQL]---------삭제성공");
		response.sendRedirect(request.getContextPath()+"/boardList.jsp");// 성공하면 이전페이지로
	}else{
		System.out.println("[SQL]---------삭제실패");
		response.sendRedirect(request.getContextPath()+"/deleteBoardForm.jsp?boardNo="+boardNo+"&fail=true");
	}
	
	//db에서 사용된 자원을 반환
	stmt.close();
	conn.close();

%>