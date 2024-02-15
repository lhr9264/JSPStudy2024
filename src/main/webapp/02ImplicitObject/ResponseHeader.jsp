<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Collection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% 
//날짜형식을 지정한다
SimpleDateFormat s = new SimpleDateFormat("yyyy-MM-dd");
/*
getTime() : 날짜를 1970년 1월 1일부터 지금까지의 시간을 초단위로 변경하여
	반환한다. 이를 타임스템프 라고 한다.
*/
long add_date = s.parse(request.getParameter("add_date")).getTime();
/*
문자열로 전송되는 값을 실제 날짜로 변경하귀 위해 포맷을 지정한 후 타임스템프로
변경한다. 초단위로 변경된 시간은 long 타입의 변수에 저장한다.
*/
System.out.println("add_date="+add_date);

//전송된 폼값을 정수로 변환한다. 
int add_int = Integer.parseInt(request.getParameter("add_int"));

//문자열은 그대로 사용하면 된다.
String add_str = request.getParameter("add_str");

/*
addDateHeader()
	: 응답헤더에 날짜형식을 추가하는 경우 long타입의 타임스템프로
	변환 후 추가한다.
addIntHeader() : 숫자형식의 응답헤더를 추가한다.
addHeader() : 문자형식의 응답헤더를 추가한다.
*/

//날짜형식의 헤더값 추가
response.addDateHeader("myBirthday", add_date);
//정수형식 추가. 동일한 헤더명으로 2개의 값이 추가된다.
response.addIntHeader("myNumber", add_int);//8282
response.addIntHeader("myNumber", 1004);//1004
//최초 '홍길동'이 추가된 후 '안중근'으로 변경된다.
response.addHeader("myName", add_str);//홍길동
response.setHeader("myName", "안중근");//수정
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내장 객체 - response</title>
</head>
<body>
	<h2>응답 헤더 정보 출력하기</h2>
	<%
	//getHeaderNames()를 통해 응답헤더명 전체를 얻어온다.
	Collection<String> headerNames = response.getHeaderNames();
	//확장 for문으로 얻어온 갯수만큼 반복한다.
	for (String hName : headerNames) {
		//헤더명을 통해 헤더값을 얻어온 후 출력한다.
		String hValue = response.getHeader(hName);
	%>
		<li><%= hName %> : <%= hValue %></li>
	<%
	}
	%>
	
	<h2>myNumber만 출력하기</h2>
	<%
	Collection<String> myNumber = response.getHeaders("myNumber");
	for (String myNUm : myNumber) {
	%>
		<li>myNumber : <%= myNumber %></li>
	<%
	}
	%>
</body>
</html>