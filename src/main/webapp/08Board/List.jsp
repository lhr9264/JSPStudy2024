<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="model1.board.BoardDTO"%>
<%@page import="model1.board.BoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
/// DAO객체 생성을 통해 DB에 연결한다.
BoardDAO dao = new BoardDAO(application);

/* 검색어가 있는 경우 유저가 선택한 
   필드명과 검색어를 저장하기 위해 Map을 생성한다. */
Map<String, Object> param = new HashMap<String, Object>();

/* 검색폼에서 입력한 검색어와 필드명을 파라미터로 받아온다.
   <form>태그의 전송방식이 get이고 action속성은 없는 상태이므로
   현재 페이지로 폼값이 전송된다.*/
String searchField = request.getParameter("searchField");
String searchWord = request.getParameter("searchWord");

/* 검색어를 입력한 경우에만 Mapdp 추가한다. 이 값은 DAO로 전달되어
   where절을 동적으로 추가하는 기능을 수행하게 된다.*/
if (searchWord != null) {
	param.put("searchField", searchField);
	param.put("searchWord", searchWord);
}

// 게시물의 개수를 카운트한다.
int totalCount = dao.selectCount(param);

/* web.xml에 설정한 컨텍스트 초기화 파라미터를 읽어온다.
   초기화 파라미터는 String으로 저장되므로 산술연산을 위해 int형으로 변환해야 한다. */
int pageSize = Integer.parseInt(application.getInitParameter("POSTS_PER_PAGE"));
int blockPage = Integer.parseInt(application.getInitParameter("PAGES_PER_BLOCK"));

/* 
전체 페이지수를 계산
전체게시물 개수 / 페이지당 출력할 게시물 개수 => 결과 값의 올림처리
개시물 개수가 108개라면 10으로 나누었을 때 10.8이 되므로 올림처리하여 11을 만들어준다.
즉, 11페이지가 된다.
만약 totalCount를 double형으로 변환하지 않으면 정수의 결과가 나오게 되므로 10페이지가 될 것이다.
따라서 결과를 얻기위해 형변환 후 계산한다.
*/
int totalPage = (int)Math.ceil((double)totalCount / pageSize);

/* 목록에 처음 진입했을 때는 페이지관련 파라미터가 없는 상태이므로 1페이지로 지정한다.
   파라미터가 있다면 request내장객체를 통해 읽은 후 페이지 번호로 지정한다. */
int pageNum = 1;
String pageTemp = request.getParameter("pageNum");
if (pageTemp != null && !pageTemp.equals(""))
	pageNum = Integer.parseInt(pageTemp);
/* 현재 페이지에 출력할 게시물의 구간을 계산한다.
   쿼리문에 적용할 start와 end를 페이지 번호와 페이지 사이즈를 통해 계산한 후 Map에 저장한다.
   차후 DAO로 전달한다. */
int start = (pageNum - 1) * pageSize + 1;
int end = pageNum * pageSize;
param.put("start", start);
param.put("end", end);

// 목록에 출력할 레코드를 인출한다.
List<BoardDTO> boardLists = dao.selectListPage(param);

// DB자원해제(연결을 해제한다.)
dao.close();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원제 게시판</title>
</head>
<body>
    <jsp:include page="../Common/Link.jsp" />  
	<!-- 검색폼 -->
    <h2>목록 보기(List)</h2>
    <form method="get">  
    <table border="1" width="90%">
    <tr>
        <td align="center">
            <select name="searchField"> 
                <option value="title">제목</option> 
                <option value="content">내용</option>
            </select>
            <input type="text" name="searchWord" />
            <input type="submit" value="검색하기" />
        </td>
    </tr>   
    </table>
    </form>
    <table border="1" width="90%">
        <tr>
            <th width="10%">번호</th>
            <th width="50%">제목</th>
            <th width="15%">작성자</th>
            <th width="10%">조회수</th>
            <th width="15%">작성일</th>
        </tr>
<%
//컬렉션에 추가된 내용이 있다면 아래와 같이 출력한다.
if (boardLists.isEmpty()) {
%>
        <tr>
            <td colspan="5" align="center">
                등록된 게시물이 없습니다^^*
            </td>
        </tr>
<%
}
else {
	/*
	출력할 게시물이 있는 경우에는 확장 for문을 List에 저장된 레코드의
	갯수만큼 반복한다.
	*/
	//게시물의 가상번호
	int virtualNum = 0;
	for (BoardDTO dto : boardLists)
	{
		/*
		현재 출력할 게시물의 갯수에 따라 번호가 달라지게 되므로 아래와 같이
		가상번호를 부여한다. 전체 게시물의 갯수에서 1씩 차감한다.
		*/
		virtualNum = totalCount--;
%>
        <tr align="center">
            <td><%= virtualNum %></td>  
            <td align="left"> 
                <a href="View.jsp?num=<%= dto.getNum() %>"><%= dto.getTitle() %></a>
            </td>
            <td align="center"><%= dto.getId() %></td>           
            <td align="center"><%= dto.getVisitcount() %></td>   
            <td align="center"><%= dto.getPostdate() %></td>    
        </tr>
<%
	}
}
%>
    </table>
   
    <table border="1" width="90%">
        <tr align="right">
            <td><button type="button" onclick="location.href='Write.jsp';">글쓰기
                </button></td>
        </tr>
    </table>
</body>

</html>