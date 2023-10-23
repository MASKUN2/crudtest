<%@page import="vo.Student"%>
<%@page import="vo.Team"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//updateStudentAction.jsp
	
	String[] alias = {"teamNo", "studentName", "studentGender","studentBirth"}; // 조회할 파라메터를 명세하기
	for(int i = 0; i < alias.length; i += 1){ // 조회한 리퀘스트 파라메터값이 널이거나 공란인경우 ?fail=leak 로 이전페이지로 보냄
		if(request.getParameter(alias[i]) == null || request.getParameter(alias[i]) == ""){
			response.sendRedirect(request.getContextPath()+"/updateStudentForm.jsp?fail=leak&studentNo="+request.getParameter("studentNo"));
			return;
		}
	}
	
	int studentNo = Integer.parseInt(request.getParameter("studentNo"));
	int TeamNo = Integer.parseInt(request.getParameter("teamNo"));
	String studentName = request.getParameter("studentName");
	String studentGender = request.getParameter("studentGender");
	String studentBirth = request.getParameter("studentBirth");
	
	
	//Driver 설정
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("[JDBC]-----드라이버 로딩완료");
	String url = "jdbc:mariadb://localhost:3306/gdj72";
	String dbuser = "root";
	String dbpw = "java1234";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	System.out.println("[JDBC]-----db접속성공");

	//빈 인자 쿼리를 지정
	String sql = ("UPDATE student SET student_name = ?, student_gender = ?, student_birth = ?, team_no = ?, updatedate = now() WHERE student_no = ?");
	PreparedStatement stmt = conn.prepareStatement(sql); 
	stmt.setString(1, studentName);
	stmt.setString(2, studentGender);
	stmt.setString(3, studentBirth);
	stmt.setInt(4, TeamNo);
	stmt.setInt(5, studentNo);
	
	// 쿼리문의 콘솔디버깅
	System.out.println("[쿼리문]-------\n"+stmt);
	
	// 실행하고 인서트 문의 리턴값으로 성공은 1 실패는 0을 받음
	int row = stmt.executeUpdate(); 

	//db에서 사용된 자원을 반환
	stmt.close();
	conn.close();
	
	//쿼리성공여부검사
	if(row == 1) {
		System.out.println("성공");
		response.sendRedirect(request.getContextPath()+"/studentOne.jsp?studentNo="+studentNo); // 성공하면 이전페이지로
	}else{
		System.out.println("실패");
		response.sendRedirect(request.getContextPath()+"/updateStudentForm.jsp?studentNo="+studentNo+"&fail=true"); //이전 폼으로 이동시킴
	}	
%>
