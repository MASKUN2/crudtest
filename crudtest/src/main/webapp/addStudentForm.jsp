<%@page import="vo.Student"%>
<%@page import="vo.Team"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//addStudentForm.jsp
	
	//Driver 설정
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("[JDBC]-----드라이버 로딩완료");
	String url = "jdbc:mariadb://localhost:3306/gdj72";
	String dbuser = "root";
	String dbpw = "java1234";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	System.out.println("[JDBC]-----db접속성공");

	//빈 인자가 있는 쿼리를 준비
	String sql1 = ("SELECT team_no teamNo, team_name teamName From team");
	PreparedStatement stmt1 = conn.prepareStatement(sql1); 
	
	// 쿼리문의 콘솔디버깅
	System.out.println("[쿼리문]-------\n"+stmt1);
	
	// 쿼리를 실행시켜 결과셋을 가져옴
	ResultSet rs1 = stmt1.executeQuery(); 
	
	// 도메인 타입의 ArrayList 를 생성
	ArrayList<Team> list = new ArrayList<>(); 
	
	//도메인 객체의 비어있는 필드를 입력함
	while(rs1.next()){
		Team t = new Team(); //도메인 객체 인스턴스 생성
		t.teamNo= rs1.getInt("teamNo");
		t.teamName = rs1.getString("teamName");
		list.add(t); // 1개씩 ArrayList list에 추가 
	}
	
	//db에서 사용된 자원을 반환
	rs1.close();
	stmt1.close();
	conn.close();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>학생등록</title>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<div class="container pt-5">
	<h1>학생등록</h1>
	<form action="<%=request.getContextPath()%>/addStudentAction.jsp">
		<table  class="table table-striped">
			<tr>
				<th>학생이름</th>
				<td>
					<input name="studentName" type="text" >
				</td>
			</tr>		
			<tr>
				<th>성별</th>
				<td>
					<select name="studentGender">
						<option value="남">남</option>
						<option value="여">여</option>
					</select>
				</td>
			</tr>		
			<tr>
				<th>생년월일</th>
				<td>
					<input name="studentBirth" type="date" >
				</td>
			</tr>		
			<tr>
				<th>팀 구분</th>
				<td>
					<!-- 팀목록 중 하나를 선택 : db 찾아올 팀목록이 필요하다. -->
					<select name="teamNo">
					<%
						for(Team t : list){
					%>
						<option value="<%=t.teamNo%>"><%=t.teamName%></option>
					<%
						}
					%>
					</select>
				</td>
			</tr>
			<tr>
				<th colspan="2">
					<button type="submit">등록</button>
				</th>
			</tr>
		</table>
	</form>
	<%
		// 액션 페이지에서 ?fail= 값을 받으면 아래의 알림을 출력함
		if(request.getParameter("fail") != null) {
			String faillog = request.getParameter("fail");
			switch(faillog){
			
			case "leak" :
	%>
				<h3 style="color: red;"> 실패: 빈 값이 입력되었습니다.</h3>
	<%
				break;
		
			case "true" :
	%>
				<h3 style="color: red;"> SQL실패</h3>
	<%
				break;		
			}
		}
	%>
</div>
</body>
</html>