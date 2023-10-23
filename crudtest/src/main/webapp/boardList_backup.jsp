<%@page import="vo.Board"%>
<%@page import="java.lang.reflect.Field"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//BoardList.jsp
	
	//Driver 설정
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("-----드라이버 로딩완료");
	String url = "jdbc:mariadb://localhost:3306/gdj72" ;
	String dbuser = "root";
	String dbpw = "java1234";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	System.out.println("-----db접속성공");

	//조회할 컬럼의 Alias 별칭을 나열시킴
	String[] alias = {"boardNo", "boardTitle", "boardWriter", "createdate"};
	//별칭을 제외한 쿼리문을 지정
	int beginRow = 0;
	int rowPerPage = 10;
	String sql = ("SELECT board_no AS ?, board_title AS ?, board_writer AS ?, createdate AS ? FROM board ORDER BY updatedate DESC LIMIT ?, ?");
	PreparedStatement stmt = conn.prepareStatement(sql); 
	
	//stmt쿼리의 빈 인자를 String[] alias로 채워서 최종 쿼리문을 완성하기
	for(int i = 0; i < alias.length; i += 1){
		stmt.setString(i+1, alias[i]);
	}
	//페이징에 필요한 인자를 채우기 
	stmt.setInt(alias.length+1,beginRow);
	stmt.setInt(alias.length+2,rowPerPage);
	
	System.out.println(stmt);// 쿼리문의 콘솔디버깅
	
	ResultSet rs = stmt.executeQuery(); // 쿼리를 실행시켜 Rs를 가져옴
	
	ArrayList<Board> list = new ArrayList<>(); // Team 타입의 ArrayList 를 생성
	
	//도메인 객체의 비어있는 필드를 (String[] alias의 값을 활용하여) rs.get* 메소드로 가져와 입력함
	while(rs.next()){
		Board b = new Board();
		for( int i = 0; i < alias.length; i +=1){ //객체 필드의 값과 타입을 접근하여 알아내고 자동으로 맞는 필드에 입력하는 알고리즘 
			String type = b.getClass().getDeclaredField(alias[i]).getType().toString();
			//System.out.println("[data]-----"+rs.getObject(alias[i])); 디버깅용 코드이지만 수가 너무 많아 주석처리
			//System.out.println("[TeamFieldtype]-----"+type); 디버깅용 코드이지만 수가 너무 많아 주석처리
			
			switch(type){
				case "int" :
					b.getClass().getDeclaredField(alias[i]).setInt(b, rs.getInt(alias[i]));
					break;
			
				case "class java.lang.String" :
					b.getClass().getDeclaredField(alias[i]).set(b, rs.getObject(alias[i]).toString());
					break;
			}
		}
		list.add(b); // 1개씩 ArrayList list에 추가 
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
<title>List</title> 
</head>
<body>
	<ul><!-- 메인메뉴 -->
		<li><a href="<%=request.getContextPath()%>/home.jsp">홈으로</a></li>
		<li><a href="<%=request.getContextPath()%>/empList.jsp">직원관리</a></li>
		<li><a href="<%=request.getContextPath()%>/teamList">팀관리</a></li>
		<li><a href="<%=request.getContextPath()%>/studentList">학생관리</a></li>
		<li><a href="<%=request.getContextPath()%>/boardList">게시판관리</a></li>
	</ul>
	<h1>게시판 관리</h1>
	<img width="200" height="200" src="https://img1.daumcdn.net/thumb/C500x500/?fname=http://t1.daumcdn.net/brunch/service/user/4jyM/image/ApCGVgNo3Rh-6DT433umzzxSg9o.jpg">
	<div>
		<a href="<%=request.getContextPath()%>/addBoardForm.jsp"> 글쓰기</a>
	</div>
	<br>	
	<table border="1">
		<thead>
			<tr>
			<%
				for(int i = 0; i < alias.length; i += 1){ // String[] alias를 하나씩 가져와서 테이블 헤드로 이용
			%>		
				<th><%=alias[i] %></th>
			<%	
				}		
			%>
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
					<a href="<%=request.getContextPath()%>/boardOne.jsp?boardNo=<%=b.boardNo%>"><%=b.boardTitle %></a>
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
</body>
</html>