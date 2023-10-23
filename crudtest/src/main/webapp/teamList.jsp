<%@page import="java.lang.reflect.Field"%>
<%@page import="vo.Team"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//teamList.jsp

	//페이징 
	int currentPage = 1; // 초기화
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage")); 
	}
	int totalRow = 0;
	int rowPerPage = 10;
	int lastPage = 0;
	
	//Driver 설정
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("-----드라이버 로딩완료");
	String url = "jdbc:mariadb://localhost:3306/gdj72" ;
	String dbuser = "root";
	String dbpw = "java1234";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	System.out.println("-----db접속성공");
	
	//총 튜플 수 구하기
	String sqlPageChk = ("SELECT COUNT(*) count FROM team");
	PreparedStatement stmtPageChk = conn.prepareStatement(sqlPageChk); 
	
	// 쿼리문의 콘솔디버깅
	System.out.println("[쿼리문]-------\n"+stmtPageChk);
	
	// 쿼리를 실행시켜 결과셋을 가져옴
	ResultSet rsPageChk = stmtPageChk.executeQuery(); 
	
	//튜플 카운터로 총 튜플 수를 구함
	if(rsPageChk.next()){
		totalRow = rsPageChk.getInt("count");
	}
	// 마지막 페이지 구하기
	if(totalRow % rowPerPage != 0){
		lastPage = totalRow / rowPerPage + 1;
	}else{
		lastPage = totalRow / rowPerPage;
	}
	int beginRow = (currentPage - 1) * rowPerPage;	

	//조회할 컬럼의 Alias 별칭을 나열시킴
	String[] alias = {"teamNo", "teamName", "teamCount", "teamBegin", "teamEnd", "createdate", "updatedate"};
	//별칭을 제외한 쿼리문을 지정
	String sql = ("SELECT team_no AS ?, team_name AS ?, team_count AS ?, team_begin AS ?, team_end AS ?, createdate AS ?, updatedate AS ? FROM team");
	PreparedStatement stmt = conn.prepareStatement(sql); // PreparedStatement 안에 쿼리 저장
	
	//stmt쿼리의 빈 인자를 String[] alias로 채워서 최종 쿼리문을 완성하기
	for(int i = 0; i < alias.length; i += 1){
		stmt.setString(i+1, alias[i]);
	}
	System.out.println(stmt);// 쿼리문의 콘솔디버깅
	
	ResultSet rs = stmt.executeQuery(); // 쿼리를 실행시켜 Rs를 가져옴
	
	ArrayList<Team> list = new ArrayList<>(); // Team 타입의 ArrayList 를 생성
	
	//Team t 객체의 비어있는 필드를 (String[] alias의 값을 활용하여) rs.get* 메소드로 가져와 입력함
	while(rs.next()){
		Team t = new Team();
		for( int i = 0; i < alias.length; i +=1){ //Team t의 필드의 값과 타입을 접근하여 알아내고 자동으로 맞는 필드에 입력하는 알고리즘 
			String type = t.getClass().getDeclaredField(alias[i]).getType().toString();
			System.out.println("[data]-----"+rs.getObject(alias[i]));
			System.out.println("[TeamFieldtype]-----"+type);
			
			switch(type){
				case "int" :
					t.getClass().getDeclaredField(alias[i]).setInt(t, rs.getInt(alias[i]));
					break;
			
				case "class java.lang.String" :
					t.getClass().getDeclaredField(alias[i]).set(t, rs.getObject(alias[i]).toString());
					break;
			}
		}
		list.add(t); // 1개씩 ArrayList list에 추가 
	}
	
	//db에서 사용된 자원을 반환
	rsPageChk.close();
	stmtPageChk.close();
	rs.close();
	stmt.close();
	conn.close();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>team List</title> 
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<div class="container pt-5">
	<img  class="rounded-circle"  width="200" height="200" src="https://img1.daumcdn.net/thumb/C500x500/?fname=http://t1.daumcdn.net/brunch/service/user/4jyM/image/ApCGVgNo3Rh-6DT433umzzxSg9o.jpg">
	<br><br>
	<ul class="pagination">
		<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/home.jsp">홈으로</a></li>
		<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/empList.jsp">직원관리</a></li>
		<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/teamList.jsp">팀관리</a></li>
		<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/studentList.jsp">학생관리</a></li>
		<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/boardList.jsp">게시판관리</a></li>
	</ul>
	<h1>팀 리스트</h1>
	<div>
		<a  class="btn btn-primary" href="<%=request.getContextPath()%>/addTeamForm.jsp"> 팀 추가</a><!-- 추가하는 페이지로 이동 -->
		<br>
		<br>
	</div>
	<!-- 페이지 네비게이션 -->
	<div>
	<ul class="pagination">
		<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/teamList.jsp?currentPage=<%=1%>">[처음으로]</a></li>
	<%
		if(currentPage  > 10){
	%>
		<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/teamList.jsp?currentPage=<%=currentPage - 10%>">이전<</a></li>
	<%
		}
		//여러줄 페이지 색인
		for(int i = currentPage - 5; i < currentPage + 5; i += 1){
			if(i < 1){
				continue;
			}
	%>
		<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/teamList.jsp?currentPage=<%=i%>"><%=i%></a></li>
	<%
			if(i == lastPage){
				break;
			}
		}
		if(currentPage < lastPage - 10){
	%>
		<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/teamList.jsp?currentPage=<%=currentPage + 10%>">>다음</a></li>
	<%
		}
	%>
		<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/teamList.jsp?currentPage=<%=lastPage%>">[마지막 페이지]</a></li>
	</ul>
	</div>
	<%
		// 액션 페이지에서 ?fail= 값을 받으면 아래의 알림을 출력함
		if(request.getParameter("fail") != null) {
			String faillog = request.getParameter("fail");
			switch(faillog){
			
			case "fail" :
	%>
				<h3 style="color: red;"> SQL실패</h3>
	<%
				break;
		
			case "forekey" :
	%>
				<h3 style="color: red;"> 왜래키 제약조건으로 삭제가 불가합니다. (소속된 학생이 존재)</h3>
	<%
				break;
	
			case "leak" :
	%>
				<h3 style="color: red;"> 실패: 빈 값이 입력되었습니다.</h3>
	<%
				break;
			}
		}
	%>
	<br>	
	<table class="table table-striped">
		<thead>
			<tr>
			<%
				for(int i = 0; i < alias.length; i += 1){ // String[] alias를 하나씩 가져와서 테이블 헤드로 이용
			%>		
				<th><%=alias[i] %></th>
			<%	
				}		
			%>
				<th>수정</th>
				<th>삭제</th>
			</tr>
		</thead>
		<tbody>
			<%
				
				for(Team t : list){		// 조회된 데이터를 출력 컬럼에 맞춰 출력함
			%>		
			<tr>
			<%
					//alias[]의 별칭과 일치하는 Team 객체의 필드안의 값을 순차적으로 가져오는 알고리즘
					for(int i = 0; i < alias.length; i += 1){
						Field field = t.getClass().getDeclaredField(alias[i]);
						Object value = field.get(t);
						System.out.print(value);
			%>
				<td>
						<%=value%>
				</td>
			<%			
					}
			%>
				<td><a href="<%=request.getContextPath()%>/updateTeamForm.jsp?teamNo=<%=t.teamNo%>">수정</a>
				<td><a href="<%=request.getContextPath()%>/deleteTeamAction.jsp?teamNo=<%=t.teamNo%>">삭제</a>
			</tr>			
			<%	
				}
			%>
		</tbody>
	</table>
</div>
</body>
</html>