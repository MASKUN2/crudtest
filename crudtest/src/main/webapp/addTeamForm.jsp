<%@page import="org.apache.catalina.valves.rewrite.InternalRewriteMap.LowerCase"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
		// addTeamForm.jsp
	final String[] TABLE_NAME = {"TEAM","팀"}; // 조회할 db 테이블, 한글명
	String[] noInsert = {(TABLE_NAME[0].toLowerCase()+"_no"),"createdate","updatedate"}; // 클라이언트가 입력할 수 없는 컬럼을 미리 지정
	
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("드라이버 로딩성공");
	String url = "jdbc:mariadb://localhost:3306/gdj72" ;
	String dbuser = "root";
	String dbpw = "java1234";
	
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	System.out.println("db접속성공");

	//테이블의 컬럼 정보만 얻기 위한 작업
	String sql = ("SELECT * FROM "+TABLE_NAME[0]+" where 1 = 2");
	PreparedStatement stmt = conn.prepareStatement(sql);
	ResultSet rs = stmt.executeQuery();
	
	int numberOfColumns = rs.getMetaData().getColumnCount(); // 애트리뷰트의 수 받아오기
	String[] columnNames = new String[numberOfColumns]; // 속성 수만큼의 컬럼 라벨 문자열 배열 생성
	String[] columnType = new String[numberOfColumns]; // 속성 수만큼의 타입 문자열 배열 생성
	
	for(int i = 1; i <= numberOfColumns; i += 1){ // 애트리뷰트의 수로 인덱스 조회하며 컬럼 라벨/ 타입을 가져옴
		columnNames[i-1] = rs.getMetaData().getColumnLabel(i);
		columnType[i-1] = rs.getMetaData().getColumnTypeName(i);
	}	
%>
<!DOCTYPE html> 
<html>
<head>
<meta charset="UTF-8">
<title>ADD <%=TABLE_NAME[0] %> </title>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<div class="container pt-5">
	<h1><%=TABLE_NAME[1]%> 추가</h1>
	<form action="<%=request.getContextPath()%>/addTeamAction.jsp">
		<table  class="table table-striped">
		<%// 팀추가 폼의 input row를 출력하기 시작함 
			for(int i = 0; i < columnNames.length; i += 1){ // 컬럼의 수만큼 반복
				Boolean noInsertCheck = false; // 유효성 검사의 불리언 값 초기화 
				String inputTagType = "text"; // 클라이언트 입력값의 초기값 인풋테그의 텍스트 해당
				
				for(String c : noInsert){ // 클라이언트 입력 컬럼을 String[] noInsert 배열 내부와 대조 일치하면 True.
					if(columnNames[i].equals(c)){
						noInsertCheck = true;
						break; // 1번이라도 확인되면 for블록 중지
					}
				}				
				if(noInsertCheck == true){ //유효성 검사 True인경우 출력하지 않고 다음 인풋컬럼으로 넘어감
					continue;
				}
				if(columnType[i] == "DATE"){ // 만약 컬럼의 데이터 타입이 DATE인 경우 인풋타입을 DATE로 변경함 
					inputTagType = "DATE";
				}else if(columnType[i] == "INTEGER"){
					inputTagType = "NUMBER"; // 숫자인 경우도 확인
				}
		%>
			<tr>
				<th><%= columnNames[i]%></th> <!-- 인풋 컬럼의 이름 출력 -->
				<td>
					<input type="<%=inputTagType %>" name="<%=columnNames[i]%>"><!-- 인풋태그에 컬럼의 속성과 컬럼이름을 대입함 -->
				</td>	
			</tr>
		<%
			}// 인풋태그 출력 끝 
		%>
			<tr>
				<td colspan="2"><button type="submit">추가</button>
				</td>
			</tr>
		</table>
	</form>
	<%
		//팀추가 액션 페이지에서 ?fail= 값을 받으면 아래의 알림을 출력함
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
				<h3 style="color: red;"> 실패: SQL인서트가 실패했습니다.</h3>
	<%
				break;		
			}
		}
	%>
</div>
</body>
</html>