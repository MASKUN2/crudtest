<%@page import="vo.Emp"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.Connection"%>
<%@ page import = "java.sql.DriverManager"%>
<%@ page import = "java.sql.PreparedStatement" %>
<%@ page import = "java.sql.ResultSet" %>

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
<!-- 메뉴 네비게이션 ul list -->

<%
	//페이징 
	int currentPage = 1; // 초기화
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage")); 
	}
	int totalRow = 0;
	int rowPerPage = 10;
	int lastPage = 0;

	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("드라이버 로딩성공");
	String url = "jdbc:mariadb://localhost:3306/gdj72" ;
	String dbuser = "root";
	String dbpw = "java1234";
	
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	System.out.println("db접속성공");
	
	//총 튜플 수 구하기
	String sqlPageChk = ("SELECT COUNT(*) count FROM emp");
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

	String sql = "SELECT emp_no AS empNo, emp_name AS empName, createdate, updatedate FROM emp ORDER BY updatedate DESC LIMIT ?, ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	
	stmt.setInt(1, beginRow);
	stmt.setInt(2, rowPerPage);
	
	ResultSet rs = stmt.executeQuery();
	//여기까지가 모델레이어.
	//DB EMP테이블 행집합(Rs) -> Emp 타입의 집합으로 변경
	ArrayList<Emp> list = new ArrayList<Emp>();
	
	while(rs.next()){
		Emp e = new Emp();
		e.empNo = rs.getInt("empNo");
		e.empName = rs.getString("empName");
		e.createdate = rs.getString("createdate");
		e.updatedate = rs.getString("updatedate");
		list.add(e);
	}
	
	//db에서 사용된 자원을 반환
	rsPageChk.close();
	stmtPageChk.close();
	rs.close();
	stmt.close();
	conn.close();
	
%>
	<img  class="rounded-circle"  width="200" height="200" src="https://img1.daumcdn.net/thumb/C500x500/?fname=http://t1.daumcdn.net/brunch/service/user/4jyM/image/ApCGVgNo3Rh-6DT433umzzxSg9o.jpg">
	<br><br>
	<ul class="pagination">
		<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/home.jsp">홈으로</a></li>
		<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/empList.jsp">직원관리</a></li>
		<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/teamList.jsp">팀관리</a></li>
		<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/studentList.jsp">학생관리</a></li>
		<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/boardList.jsp">게시판관리</a></li>
	</ul>
	<h1>직원 리스트</h1>
	<div>
		<a class="btn btn-primary"  href="<%=request.getContextPath()%>/addEmpForm.jsp">직원추가</a>
		<br>
		<br>
	</div>
		<!-- 페이지 네비게이션 -->
	<div>
	<ul class="pagination">
		<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/empList.jsp?currentPage=<%=1%>">[처음으로]</a></li>
	<%
		if(currentPage  > 10){
	%>
		<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/empList.jsp?currentPage=<%=currentPage - 10%>">이전<</a></li>
	<%
		}
		//여러줄 페이지 색인
		for(int i = currentPage - 5; i < currentPage + 5; i += 1){
			if(i < 1){
				continue;
			}
	%>
		<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/empList.jsp?currentPage=<%=i%>"><%=i%></a></li>
	<%
			if(i == lastPage){
				break;
			}
		}
		if(currentPage < lastPage - 10){
	%>
		<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/empList.jsp?currentPage=<%=currentPage + 10%>">>다음</a></li>
	<%
		}
	%>
		<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/empList.jsp?currentPage=<%=lastPage%>">[마지막 페이지]</a></li>
	</ul>
	</div>
	<table class="table table-striped">
		<thead>
		<tr>
			<th>emp_no</th>
			<th>emp_name</th>
			<th>createdate</th>
			<th>updatedate</th>
			<th>수정</th>
			<th>삭제</th>
		</tr>
		</thead>
		<tbody>
		<%
			for(Emp e : list){		
		%>		
		<tr>
			<td><%=e.empNo %></td>
			<td><%=e.empName%></td>
			<td><%=e.createdate%></td>
			<td><%=e.updatedate%></td>
			<td>
				<a href="<%=request.getContextPath()%>/updateEmpForm.jsp?empNo=<%=e.empNo%>">수정</a>
			</td>
			<td>
				<a href="<%=request.getContextPath()%>/deleteEmpAction.jsp?empNo=<%=e.empNo%>">삭제</a>
			</td>
		</tr>			
		<%
			}
		%>
		</tbody>
	
	</table>
</div>
</body>
</html>