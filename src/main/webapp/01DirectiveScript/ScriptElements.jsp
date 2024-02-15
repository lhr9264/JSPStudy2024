<!-- page지시어 : JSP문서에는 반드시 선언되어야 하는 부분이다. -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- 
선언부(Declaration) : 스크립트렛이나 표현식에서 사용할 메서드를 선언할때
	사용한다. 선언부에서 선언된 메서드는 해당 JSP가 서블릿으로 변환될때
	멤버메서드 형태로 선언된다.
 -->
<%!
//선언부는 !로 시작한다. 2개의 정수의 합을 반환하는 메서드를 정의.
public int add(int num1, int num2) {
	return num1 + num2;
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>스크립트 요소</title>
</head>
<body>
<!-- 
스크립트렛(Scriptlet)
	: 주로 JSP코드를 작성하고 실행할때 사용한다. 스크립트렛은 body, head
	어디서든 사용할 수 있다. 또한 <script>, <style>태그 내부에서도
	사용할 수 있다.
표현식(Expression)
	: 변수를 웹브라우저상에 출력할 때 사용한다.
	JS의 document.write()와 동일하다. 표현식을 사용할때는 문장의 끝에
	세미콜론을 붙이지 않는다.	
 -->
<%
int result = add(10,20);
%>
덧셈 결과 1 : <%= result %> <br />
덧셈 결과 2 : <%= add(30, 40) %>
</body>
</html>