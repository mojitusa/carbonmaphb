<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%
String str = (String)request.getAttribute("resultStr");
%>
<title>Hello</title>
</head>
<body>
HELLO~ <br>
result : " <%=str %> " 
	<div id ="counter">0</div>
	<button id ="increase">+</button>
	<button id ="decrease">-</button>
	<script>
		// 에러를 발생시키는 코드 : 선택자는 'counter-x'가 아니라 'counter'를 지정해야 한다.
		const $counter = document.getElementById('counter-x');
		const $increase = document.getElementById('increase');
		const $decrease = document.getElementById('decrease');
		
		let num = 0;
		const render = function() {$counter.innerHTML = num;};
		
		$increase.onclick = function() {
			num++;
			console.log('increase 버튼 클릭', num);
			render();
		}
		
		$decrease.onclick = function() {
			num--;
			console.log('decrease 버튼 클릭', num);
			render();
		};
	</script>
</body>
</html>