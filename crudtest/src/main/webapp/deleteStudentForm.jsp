<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	// deleteBoardForm.jsp
%>
<!DOCTYPE html> 
<html>
<head>
<meta charset="UTF-8">
<title> 학생 정보 삭제 </title>
<!-- Latest compiled and minified CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Latest compiled JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<div class="container pt-5">
	<h1>학생정보를 삭제하시겠습니까?</h1>
	<form action="<%=request.getContextPath()%>/deleteStudentAction.jsp">
		<table  class="table table-striped">
			<tr>
				<th>
					학생번호
				</th>
				<th>
				<input type="number" name="studentNo" value="<%=request.getParameter("studentNo")%>" readonly>
				</th>
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
			
			case "true" :
	%>
				<h3 style="color: red;"> 실패</h3>
	<%
				break;		
			}
		}
	%>
</div>
</body>
</html>