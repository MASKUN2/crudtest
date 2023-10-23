<%@page import="vo.Board"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//boardOne.jsp
	
	//Driver 설정
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("[JDBC]-----드라이버 로딩완료");
	String url = "jdbc:mariadb://localhost:3306/gdj72" ;
	String dbuser = "root";
	String dbpw = "java1234";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	System.out.println("[JDBC]-----db접속성공");

	//업데이트할 프라임 키 가져오기
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	
	//별칭을 제외한 쿼리문을 지정
	String sql = ("SELECT board_no AS boardNo, board_title AS boardTitle, board_content AS boardContent, board_writer AS boardWriter, createdate, updatedate FROM board WHERE board_no = ?");
	PreparedStatement stmt = conn.prepareStatement(sql); 
	
	//빈 인자를 채워서 최종 쿼리문을 완성하기
	stmt.setInt(1, boardNo);
	
	// 쿼리문의 콘솔디버깅
	System.out.println("[쿼리문]-------\n"+stmt);
	
	// 쿼리를 실행시켜 결과셋을 가져옴
	ResultSet rs = stmt.executeQuery(); 
	
	//도메인 객체 인스턴스 생성
	Board b = new Board();
	
	//도메인 객체의 비어있는 필드를 입력함
	while(rs.next()){
		b.boardNo = rs.getInt("boardNo");
		b.boardTitle = rs.getString("boardTitle");
		b.boardContent = rs.getString("boardContent");
		b.boardWriter = rs.getString("boardWriter");
		b.createdate = rs.getString("createdate");
		b.updatedate= rs.getString("updatedate");
	}
	
	//db에서 사용된 자원을 반환
	rs.close();
	stmt.close();
	conn.close();
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
	<h1>게시글 상세보기</h1>
	<form action="">
		<table  class="table table-striped"> 
		<tr>
			
			<td>글번호</td> 
			<td>
				<%=b.boardNo%>
				<input name="boardNo" hidden="true" type="number" value="<%=b.boardNo%>">
			</td>
		</tr>			
		<tr>
			<td>제목</td>
			<td>
				<%=b.boardTitle%>
			</td>
		</tr>
			
		<tr>
			<td height="500" >내용</td>
			<td valign="top">
				<%=b.boardContent%>
			</td>
		</tr>		
		<tr>
			<td>작성자</td>
			<td>
				<%=b.boardWriter%>
			</td>
		</tr>		
		<tr>
			<td>게시일</td>
			<td>
				<%=b.createdate%>
			</td>
		</tr>		
		<tr>
			<td>수정일</td>
			<td>
				<%=b.updatedate%>
			</td>
		</tr>	
		<tr>
			<td colspan="2"><!-- 수정 , 삭제버튼-->
				<button formaction="<%=request.getContextPath()%>/updateBoardForm.jsp" type="submit">수정</button>
				<button formaction="<%=request.getContextPath()%>/deleteBoardForm.jsp" type="submit">삭제</button>
			</td>
		</tr>
		</table>
	</form>
</div>
</body>
</html>