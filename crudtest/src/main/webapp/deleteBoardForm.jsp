<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	// deleteBoardForm.jsp
%>
<!DOCTYPE html> 
<html>
<head>
<meta charset="UTF-8">
<title> 글 삭제 </title>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<div class="container pt-5">
	<h1>글 삭제 : 비밀번호 입력</h1>
	<form action="<%=request.getContextPath()%>/deleteBoardAction.jsp">
		<table  class="table table-striped">
			<tr>
				<th>
					글 번호
				</th>
				<th>
				<input type="number" name="boardNo" value="<%=request.getParameter("boardNo")%>" readonly>
				</th>
			</tr>	
			<tr>
				<th>비밀번호</th> <!-- 인풋 컬럼의 이름 출력 -->
				<td>
					<input type="password" name="boardPw" >
				</td>	
			</tr>
			<tr>
				<th colspan="2"><button type="submit">삭제요청</button>
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
				<h3 style="color: red;"> 실패: 비밀번호가 틀렸습니다.</h3>
	<%
				break;		
			}
		}
	%>
</div>
</body>
</html>