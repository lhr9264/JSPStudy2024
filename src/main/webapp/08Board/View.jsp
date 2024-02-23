<%@page import="model1.board.BoardDTO"%>
<%@page import="model1.board.BoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
//목록에서 전달한 게시물의 일련번호를 받는다.
String num = request.getParameter("num");
//DAO 인스턴스 생성
BoardDAO dao = new BoardDAO(application);
//조회수 증가
dao.updateVisitCount(num);
//게시물 인출
BoardDTO dto = dao.selectView(num);
//DB 연결 해제
dao.close();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원제 게시판</title>
<script>
//게시물 삭제를 위한 JS함수 정의
function deletePost() {
	//이 함수는 대화창에서 '확인'을 누르면 true가 반환된다.
	var confirmed = confirm("정말로 삭제하겠습니까?");
	if (confirmed) {
		//<form>태그의 DOM을 얻어온다.
		var form = document.writeFrm;
		//전송방식과 경로를 지정
		form.method = "post";
		form.action = "DeleteProcess.jsp";
		//JS의 함수를 통해 폼값을 submit(전송)한다.
		form.submit();
	}
}
function deletePost() {
    var confirmed = confirm("정말로 삭제하겠습니까?"); 
    if (confirmed) {
        var form = document.writeFrm;      
        form.method = "post"; 
        form.action = "DeleteProcess.jsp"; 
        form.submit();         
    }
}
</script>
</head>
<body>
<jsp:include page="../Common/Link.jsp" />
<h2>회원제 게시판 - 상세 보기(View)</h2>

<!-- 게시물 삭제를 위해 hidden타입의 입력상자를 추가한다.
삭제 버튼 클릭시 일련번호를 서버로 전송한다. -->
<form name="writeFrm">
<input type="hidden" name="num" value="<%= num %>" />  
    <table border="1" width="90%">
        <tr>
            <td>번호</td>
            <td><%= dto.getNum() %></td>
            <td>작성자</td>
            <td><%= dto.getName() %></td>
        </tr>
        <tr>
            <td>작성일</td>
            <td><%= dto.getPostdate() %></td>
            <td>조회수</td>
            <td><%= dto.getVisitcount() %></td>
        </tr>
        <tr>
            <td>제목</td>
            <td colspan="3"><%= dto.getTitle() %></td>
        </tr>
        <tr>
            <td>내용</td>
            <!-- 줄바꿈을 위해 Enter를 입력하면 저장시 \r\n으로 입력된다.
            웹브라우저에서는 <br>태그가 있어야 줄바꿈이 되므로 아래와 같이
            변경해준다. -->
            <td colspan="3" height="100">
	         	<%= dto.getContent().replace("\r\n", "<br/>") %>
	         </td> 
        </tr>
        <tr>
            <td colspan="4" align="center">
            <%
            /*
            로그인이 된 상태에서 세션영역에 저장된 아이디가 해당 게시물을 작성한
            아이디와 일치하면 수정, 삭제 버튼을 보이게 처리한다.
            즉, 작성자 본인에게만 수정, 삭제버튼이 보이게된다.
            */
            if (session.getAttribute("UserId") != null
            	&& session.getAttribute("UserId").toString().equals(dto.getId())) {
            %>
                <button type="button" 
                		onclick="location.href='Edit.jsp?num=<%= dto.getNum() %>';">
                    수정하기</button>
                <button type="button" onclick="deletePost();">삭제하기</button> 
            <%
            }
            %>
                <button type="button" onclick="location.href='List.jsp';">
                    목록 보기
                </button>
            </td>
        </tr>
    </table>
</form>
</body>
</html>
