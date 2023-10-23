<%@page import="vo.Board"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//BoardList.jsp
	
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
	System.out.println("[JDBC]-----드라이버 로딩완료");
	String url = "jdbc:mariadb://localhost:3306/gdj72" ;
	String dbuser = "root";
	String dbpw = "java1234";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	System.out.println("[JDBC]-----db접속성공");
	
	//총 튜플 수 구하기
	String sqlPageChk = ("SELECT COUNT(*) count FROM board");
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

	//빈 인자가 있는 쿼리를 준비
	String sql = ("SELECT board_no AS boardNo, board_title AS boardTitle, board_writer AS boardWriter, createdate FROM board ORDER BY updatedate DESC LIMIT ?, ?");
	PreparedStatement stmt = conn.prepareStatement(sql); 
	
	//stmt쿼리의 빈 인자를 채워서 최종 쿼리문을 완성하기
	stmt.setInt(1, beginRow);
	stmt.setInt(2, rowPerPage);
	
	// 쿼리문의 콘솔디버깅
	System.out.println("[쿼리문]-------\n"+stmt);
	
	// 쿼리를 실행시켜 결과셋을 가져옴
	ResultSet rs = stmt.executeQuery(); 
	
	// 도메인 타입의 ArrayList 를 생성
	ArrayList<Board> list = new ArrayList<>(); 
	
	//도메인 객체의 비어있는 필드를 입력함
	while(rs.next()){
		Board b = new Board(); //도메인 객체 인스턴스 생성
		b.boardNo = rs.getInt("boardNo");
		b.boardTitle = rs.getString("boardTitle");
		b.boardWriter = rs.getString("boardWriter");
		b.createdate = rs.getString("createdate");
		list.add(b); // 1개씩 ArrayList list에 추가 
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
<title>List</title> 
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
	<h1>게시판 관리</h1>
	<div>
		<a  class="btn btn-primary" href="<%=request.getContextPath()%>/addBoardForm.jsp"> 글쓰기</a>
		<br>
		<br>
	</div>
		<!-- 페이지 네비게이션 -->
	<div>
	<ul class="pagination">
		<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/boardList.jsp?currentPage=<%=1%>">[처음으로]</a></li>
	<%
		if(currentPage  > 10){
	%>
		<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/boardList.jsp?currentPage=<%=currentPage - 10%>">이전<</a></li>
	<%
		}
		//여러줄 페이지 색인
		for(int i = currentPage - 5; i < currentPage + 5; i += 1){
			if(i < 1){
				continue;
			}
	%>
		<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/boardList.jsp?currentPage=<%=i%>"><%=i%></a></li>
	<%
			if(i == lastPage){
				break;
			}
		}
		if(currentPage < lastPage - 10){
	%>
		<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/boardList.jsp?currentPage=<%=currentPage + 10%>">>다음</a></li>
	<%
		}
	%>
		<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/boardList.jsp?currentPage=<%=lastPage%>">[마지막 페이지]</a></li>
	</ul>
	</div>
	<br>	
	<table class="table table-striped">
		<thead>
			<tr>
				<th>게시글 번호</th>
				<th>제목</th>
				<th>작성자</th>
				<th>게시일</th>
			</tr>
		</thead>
		<tbody>
			<%
				// 조회된 데이터를 출력 컬럼에 맞춰 출력함
				for(Board b : list){		
			%>		
			<tr>
				<td>
					<%=b.boardNo%>
				</td>
				<td><!-- 제목을 누르면 게시글 상세보기페이지로 이동 -->
					<a href="<%=request.getContextPath()%>/boardOne.jsp?boardNo=<%=b.boardNo%>">
					<%=b.boardTitle %></a>
				</td>
				<td>
					<%=b.boardWriter%>
				</td>
				<td>
					<%=b.createdate%>
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