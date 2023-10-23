<%@page import="java.util.HashMap"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<% // StudentOne.jsp
	/*
		SELECT
			s.student_no 	studentNo,
			s.student_name 	studentName
			s.student_birth studentBirth,
			s.createdate 	sCreatedate,
			s.updatedate 	sUpdatedate,
			s.team_no 		teamNo,
			t.team_name 	teamName,
			t.team_count 	teamCount,
			t.team_begin 	teamBegin
			t.team_end 		teamEnd,
			t.createdate 	tCreatedate,
			t.updatedate 	tUpdatedate
		FROM student s INNER JOIN team t
		ON s.team_no = t.team_no
		WHERE s.student_no = ?
	
	*/ 
	
	int studentNo = Integer.parseInt(request.getParameter("studentNo")) ;
	
//Driver 설정
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("[JDBC]-----드라이버 로딩완료");
	String url = "jdbc:mariadb://localhost:3306/gdj72" ;
	String dbuser = "root";
	String dbpw = "java1234";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	System.out.println("[JDBC]-----db접속성공");
	
	//빈 인자가 있는 쿼리를 준비
	String sql = ("SELECT s.student_no studentNo,s.student_name studentName, student_gender studentGender,s.student_birth studentBirth,s.createdate sCreatedate,s.updatedate sUpdatedate,s.team_no teamNo,t.team_name teamName,t.team_count teamCount,t.team_begin teamBegin,t.team_end teamEnd,t.createdate tCreatedate,t.updatedate tUpdatedate FROM student s INNER JOIN team t ON s.team_no = t.team_no WHERE s.student_no = ?");
	PreparedStatement stmt = conn.prepareStatement(sql); 
	
	//stmt쿼리의 빈 인자를 채워서 최종 쿼리문을 완성하기
	stmt.setInt(1,studentNo);
	
	// 쿼리문의 콘솔디버깅
	System.out.println("[쿼리문]-------\n"+stmt);
	
	// 쿼리를 실행시켜 결과셋을 가져옴
	ResultSet rs = stmt.executeQuery(); 
	
	//
	HashMap<String, Object> map = null;
	if(rs.next()){
		map = new HashMap<String, Object>();
		map.put("studentNo", rs.getInt("studentNo"));
		map.put("studentName", rs.getString("studentName"));
		map.put("studentGender", rs.getString("studentGender"));
		map.put("studentBirth", rs.getString("studentBirth"));
		map.put("sCreatedate", rs.getString("sCreatedate"));
		map.put("sUpdatedate", rs.getString("sUpdatedate"));
		map.put("teamNo", rs.getInt("teamNo"));
		map.put("teamName", rs.getString("teamName"));
		map.put("teamCount", rs.getInt("teamCount"));
		map.put("teamBegin", rs.getString("teamBegin"));
		map.put("teamEnd", rs.getString("teamEnd"));
		map.put("tCreatedate", rs.getString("tCreatedate"));
		map.put("tUpdatedate", rs.getString("tUpdatedate"));
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<div class="container pt-5">
	<h1> 학생 상세보기 </h1>
	<table  class="table table-striped">
		<tr>
			<th>
				학생번호
			</th>
			<td>
				<%=(int)map.get("studentNo") %>
			</td>
		</tr>
		<tr>
			<th>
				학생이름
			</th>
			<td>
				<%=(String)map.get("studentName") %>
			</td>
		</tr>
		<tr>
			<th>
				성별
			</th>
			<td>
				<%=(String)map.get("studentGender") %>
			</td>
		</tr>
		<tr>
			<th>
				생년월일
			</th>
			<td>
				<%=(String)map.get("studentBirth") %>
			</td>
		</tr>
		<tr>
			<th>
				학생등록일
			</th>
			<td>
				<%=(String)map.get("sCreatedate") %>
			</td>
		</tr>
		<tr>
			<th>
				학생수정일
			</th>
			<td>
				<%=(String)map.get("sUpdatedate") %>
			</td>
		</tr>
		<tr>
			<th>
				팀번호
			</th>
			<td>
				<%=(int)map.get("teamNo") %>
			</td>
		</tr>
		<tr>
			<th>
				팀이름
			</th>
			<td>
				<%=(String)map.get("teamName") %>
			</td>
		</tr>
		<tr>
			<th>
				팀원수				
			</th>
			<td>
				<%=(int)map.get("teamCount") %>
			</td>
		</tr>
		<tr>
			<th>
				팀시작일
			</th>
			<td>
				<%=(String)map.get("teamBegin") %>
			</td>
		</tr>
		<tr>
			<th>
				팀종료일
			</th>
			<td>
				<%=(String)map.get("teamEnd") %>
			</td>
		</tr>
		<tr>
			<th>
				팀등록일
			</th>
			<td>
				<%=(String)map.get("tCreatedate") %>
			</td>
		</tr>
		<tr>
			<th>
				팀수정일
			</th>
			<td>
				<%=(String)map.get("tUpdatedate") %>
			</td>
		</tr>
		<tr>
			<td colspan="2"><!-- 수정 , 삭제버튼-->
			<form>
				<input hidden="true" name="studentNo" type="number" value="<%=(int)map.get("studentNo")%>">
				<button formaction="<%=request.getContextPath()%>/updateStudentForm.jsp" type="submit">수정</button>
				<button formaction="<%=request.getContextPath()%>/deleteStudentForm.jsp" type="submit">삭제</button>
			</form>
			</td>
		</tr>
	</table>
</div>
</body>
</html>