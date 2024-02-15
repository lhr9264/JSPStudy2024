<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내장 객체 - request</title>
</head>
<body>
<%
/*
Tomcat9 까지는 post방식으로 한글을 전송하는 경우 한글깨짐 현상이 발생한다.
따라서 해당 코드가 필요하다. 하지만 Tomcat10에서는 생략해도 무방하다.
*/
//request.setCharacterEncoding("UTF-8");

/*
getParameter() : input태그의 text, radio 타입처럼 '하나'의 값이
	전송되는 경우에 사용한다. 입력값이 문자, 숫자에 상관없이 String타입으로
	값을 반환한다.
getParameterValues : checkbox, select 태그의 multiple 속성을
	부여하여 '2개이상'의 값이 전송되는 경우에 사용한다. 2개 이상의 값이므로
	String타입의 배열로 값을 반환한다.
*/
String id = request.getParameter("id");
String sex = request.getParameter("sex");
//관심사항은 checkbox이므로 2개 이상 선택이 가능하여 배열로 폼값을 받는다.
String[] favo = request.getParameterValues("favo");
String favoStr = "";
if (favo != null) {
	for (int i = 0; i < favo.length; i++) {
		favoStr += favo[i] + " ";
	}
	//체크박스는 선택(체크)한 항목만 서버로 전송된다.
}
/*
textarea태그는 2줄 이상 입력가능하므로 엔터를 추가하는 경우 \r \n으로
저장된다. 따라서 웹브라우저에 출력할때는 <br>태그로 변경해야한다.
*/
String intro = request.getParameter("intro").replace("\r\n", "<br/>");
%>
<ul>
	<li>아이디 : <%= id %></li>
	<li>성별 : <%= sex %></li>
	<li>관심사항 : <%= favoStr %></li>
	<li>자기소개 : <%= intro %></li>
</ul>
</body>
</html>