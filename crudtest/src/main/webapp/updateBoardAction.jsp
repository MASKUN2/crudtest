<%@page import="vo.Board"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//updateBoardAction.jsp
	String[] alias = {"boardTitle", "boardContent", "boardWriter","boardPw"}; // 조회할 파라메터를 명세하기
	for(int i = 0; i < alias.length; i += 1){ // 조회한 리퀘스트 파라메터값이 널이거나 공란인경우 ?fail=leak 로 이전페이지로 보냄
		if(request.getParameter(alias[i]) == null || request.getParameter(alias[i]) == ""){
			response.sendRedirect(request.getContextPath()+"/updateBoardForm.jsp?fail=leak&boardNo="+request.getParameter("boardNo"));
			return;
		}
	}	
	//Driver 설정
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("[JDBC]-----드라이버 로딩완료");
	String url = "jdbc:mariadb://localhost:3306/gdj72" ;
	String dbuser = "root";
	String dbpw = "java1234";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	System.out.println("[JDBC]-----db접속성공");
	
	//별칭을 제외한 쿼리문을 지정
	String sql = ("update board set board_title = ?, board_content = ?, board_writer = ?, updatedate = NOW() WHERE board_no = ? AND board_pw = ?");
	PreparedStatement stmt = conn.prepareStatement(sql); // PreparedStatement 안에 쿼리 저장
	
	//빈 인자를 채워서 최종 쿼리문을 완성하기
	stmt.setString(1, request.getParameter("boardTitle"));
	stmt.setString(2, request.getParameter("boardContent"));
	stmt.setString(3, request.getParameter("boardWriter"));
	stmt.setString(4, request.getParameter("boardNo"));
	stmt.setString(5, request.getParameter("boardPw"));
	
	// 쿼리문의 콘솔디버깅
	System.out.println("[쿼리문]-------\n"+stmt);
	
	// 실행하고 인서트 문의 리턴값으로 성공은 1 실패는 0을 받음
	int row = stmt.executeUpdate(); 
	
	//쿼리성공여부검사
	if(row == 1) {
		System.out.println("성공");
		response.sendRedirect(request.getContextPath()+"/boardOne.jsp?boardNo="+request.getParameter("boardNo")); // 성공하면 이전페이지로
	}else{
		System.out.println("실패");
		response.sendRedirect(request.getContextPath()+"/updateBoardForm.jsp?boardNo="+request.getParameter("boardNo")+"&fail=true"); //이전 폼으로 이동시킴
	}	
	//db에서 사용된 자원을 반환
	stmt.close();
	conn.close();
%>