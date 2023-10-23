<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	// addBoardForm.jsp
	
	// 입력할 컬럼의 Alias 별칭
	String[] alias = {"boardTitle", "boardContent", "boardWriter"};
%>
<!DOCTYPE html> 
<html>
<head>
<meta charset="UTF-8">
<title> 글쓰기 </title>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<div class="container pt-5">
	<h1>글쓰기</h1>
	<form action="<%=request.getContextPath()%>/addBoardAction.jsp">
		<table class="table table-striped">
			<tr>
				<th>제목</th> <!-- 인풋 컬럼의 이름 출력 -->
				<td>
					<textarea name="boardTitle" cols="50" rows="1"></textarea>
				</td>	
			</tr>
			<tr>
				<th>작성자</th> <!-- 인풋 컬럼의 이름 출력 -->
				<td>
					<textarea name="boardWriter" cols="25" rows="1"></textarea>
				</td>	
			</tr>
			<tr>
				<th>비밀번호</th> <!-- 인풋 컬럼의 이름 출력 -->
				<td>
					<input type="password" name="boardPw" >
				</td>	
			</tr>
			<tr>
				<th>내용</th> <!-- 인풋 컬럼의 이름 출력 -->
				<td>
					<textarea name="boardContent" cols="50" rows="30"></textarea>
				</td>	
			</tr>
			<tr>
				<th colspan="2"><button type="submit">추가</button>
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
				<h3 style="color: red;"> 입력에 실패했습니다.</h3>
	<%
				break;		
			}
		}
	%>
	</div>
</body>
</html>