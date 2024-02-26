<%@page import="model1.board.BoardDAO"%>
<%@page import="model1.board.BoardDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="./IsLoggedIn.jsp" %>
<%
// 파라미터 받는다.
String num = request.getParameter("num");
String title = request.getParameter("title");
String content = request.getParameter("content");

// DTO에 저장한다.
BoardDTO dto = new BoardDTO();
dto.setNum(num);
dto.setTitle(title);
dto.setContent(content);

// DAO에서 쿼리문 실행
BoardDAO dao = new BoardDAO(application);
int affected = dao.updateEdit(dto);

// 자원을 해제한다.
dao.close();

// 수정된 게시물이 1이면 성공이므로 내용보기 페이지로 이동
if (affected == 1) {
	response.sendRedirect("View.jsp?num=" + dto.getNum());
} else {
	JSFunction.alertBack("수정하기에 실패하였습니다.", out);
}
%>