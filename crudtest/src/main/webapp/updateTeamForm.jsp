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
	//updateTeamForm.jsp
	
	//Driver 설정
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("-----드라이버 로딩완료");
	String url = "jdbc:mariadb://localhost:3306/gdj72" ;
	String dbuser = "root";
	String dbpw = "java1234";
	Connection conn = DriverManager.getConnection(url, dbuser, dbpw);
	System.out.println("-----db접속성공");

	//조회할 컬럼의 Alias 별칭을 나열시킴
	String[] alias = {"teamNo", "teamName", "teamCount", "teamBegin", "teamEnd", "createdate", "updatedate"};
	//업데이트할 프라임 키 가져오기
	int teamNo = Integer.parseInt(request.getParameter(alias[0]));
	
	//별칭을 제외한 쿼리문을 지정
	String sql = ("SELECT team_no AS ?, team_name AS ?, team_count AS ?, team_begin AS ?, team_end AS ?, createdate AS ?, updatedate AS ? FROM team where team_no = ?");
	PreparedStatement stmt = conn.prepareStatement(sql); // PreparedStatement 안에 쿼리 저장
	
	//stmt쿼리의 빈 인자를 String[] alias로 채워서 최종 쿼리문을 완성하기
	for(int i = 0; i < alias.length; i += 1){
		stmt.setString(i+1, alias[i]);
	}
	stmt.setInt(8, teamNo);
	
	System.out.println(stmt);// 쿼리문의 콘솔디버깅
	
	ResultSet rs = stmt.executeQuery(); // 쿼리를 실행시켜 Rs를 가져옴
	
	
	//Team t 객체의 비어있는 필드를 (String[] alias의 값을 활용하여) rs.get* 메소드로 가져와 입력함
	Team t = new Team();
	if(rs.next()){
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
	<form action="<%=request.getContextPath()%>/updateTeamAction.jsp?<%=t.teamNo%>">
		<table  class="table table-striped">
			<%
				for(int i = 0; i < alias.length; i += 1){
					Field field = t.getClass().getDeclaredField(alias[i]);
					Object value = field.get(t);
					System.out.print(value);
					String readonly = "";
					String inputType = "text";
					
					if( alias[i].equals("teamNo") || alias[i].equals("createdate")|| alias[i].equals("updatedate")){
						readonly = "readonly";
					}
					if( alias[i].equals("teamBegin")|| alias[i].equals("teamEnd")){
						inputType = "date";
					}
					if( alias[i].equals("teamCount")){
						inputType = "number";
					}
			%>
			<tr>
				<td>
					<%=alias[i]%>
				</td>
				<td>
					<input name="<%=alias[i]%>" type="<%=inputType%>" value="<%=value%>" <%=readonly%> >
				</td>
			</tr>
			<%
				}
			%>
			<tr>
				<td colspan="2"><button type="submit">수정</button>
				</td>
			</tr>
		</table>
	</form>
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
				<h3 style="color: red;"> 왜래키 제약조건이 존재합니다.</h3>
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
</div>
</body>
</html>