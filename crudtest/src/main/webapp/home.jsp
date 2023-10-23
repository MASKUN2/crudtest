<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html><!-- home.jsp -->
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
	<img  class="rounded-circle"  width="200" height="200" src="https://img1.daumcdn.net/thumb/C500x500/?fname=http://t1.daumcdn.net/brunch/service/user/4jyM/image/ApCGVgNo3Rh-6DT433umzzxSg9o.jpg">
	<br><br>
	<ul class="pagination">
		<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/home.jsp">홈으로</a></li>
		<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/empList.jsp">직원관리</a></li>
		<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/teamList.jsp">팀관리</a></li>
		<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/studentList.jsp">학생관리</a></li>
		<li class="page-item"><a class="page-link" href="<%=request.getContextPath()%>/boardList.jsp">게시판관리</a></li>
	</ul>
	<!-- 메인 내용(이미지: /img/main/jpg) -->
	<h1> 🐰</h1>
<div class="spinner-grow text-muted"></div>
  <div class="spinner-grow text-primary"></div>
  <div class="spinner-grow text-success"></div>
  <div class="spinner-grow text-info"></div>
  <div class="spinner-grow text-warning"></div>
  <div class="spinner-grow text-danger"></div>
  <div class="spinner-grow text-secondary"></div>
  <div class="spinner-grow text-dark"></div>
  <div class="spinner-grow text-light"></div>
</div>
</body>
</html>