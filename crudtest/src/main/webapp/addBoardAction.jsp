<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//addBoardAction.jsp
	String[] alias = {"boardTitle", "boardContent", "boardWriter","boardPw"}; // 조회할 파라메터를 명세하기
	for(int i = 0; i < alias.length; i += 1){ // 조회한 리퀘스트 파라메터값이 널이거나 공란인경우 ?fail=leak 로 이전페이지로 보냄
		if(request.getParameter(alias[i]) == null || request.getParameter(alias[i]) == ""){
			response.sendRedirect(request.getContextPath()+"/addBoardForm.jsp?fail=leak");
			return;
		}
	}
	//DB접속
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("[JDBC]-----드라이버 로딩완료");
	String url = "jdbc:mariadb://localhost:3306/gdj72" ;
	String dbuser = "root";
	String dbpw = "java1234";
	
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	System.out.println("[JDBC]-----db접속성공");

	//빈 인자가 있는 쿼리를 준비
	String sql = "INSERT INTO board(board_title, board_content, board_writer, board_pw, createdate, updatedate) VALUES(?, ?, ?, ?, NOW(), NOW())";
	PreparedStatement stmt = conn.prepareStatement(sql);
	
	//stmt쿼리의 빈 인자를 채워서 최종 쿼리문을 완성하기
	stmt.setString(1, request.getParameter("boardTitle"));
	stmt.setString(2, request.getParameter("boardContent"));
	stmt.setString(3, request.getParameter("boardWriter"));
	stmt.setString(4, request.getParameter("boardPw"));
	
	// 쿼리문의 콘솔디버깅
	System.out.println("[쿼리문]-------\n"+stmt);
	
	// 실행 결과: 인서트 문의 리턴값으로 성공은 1 실패는 0을 받음
	int row = stmt.executeUpdate(); 
	
	//DB자원을 반납
	stmt.close();
	conn.close();
	
	//쿼리성공여부검사
	if(row == 1) {
		System.out.println("입력성공");
		response.sendRedirect(request.getContextPath()+"/boardList.jsp"); // 성공하면 이전페이지로
	}else{
		System.out.println("입력실패");
		response.sendRedirect(request.getContextPath()+"/addBoardForm.jsp?fail=true"); //fail=true 값으로 이전페이지로 리턴시킴
	}	
%>