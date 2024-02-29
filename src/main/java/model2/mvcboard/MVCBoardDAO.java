package model2.mvcboard;

import java.util.List;
import java.util.Map;
import java.util.Vector;

import common.DBConnPool;
import model1.board.BoardDTO;

//MVC 게시판은 DBCP(커넥션풀)를 통해 DB에 연결한다.
public class MVCBoardDAO extends DBConnPool {
	
	//기본생성자 호출로 커넥션풀을 사용한다.
	public MVCBoardDAO() {
		super();
	}
	
	//게시물의 갯수 카운트
	public int selectCount(Map<String, Object> map) {
		int totalCount = 0;
		String query = "SELECT COUNT(*) FROM mvcboard";
		if (map.get("searchWord") != null) {
			query += " WHERE " + map.get("searchField") + " "
				   + " LIKE '%" + map.get("searchWord") + "%'";
		} 
		try {
			stmt = con.createStatement();
			rs = stmt.executeQuery(query);
			rs.next();
			totalCount = rs.getInt(1);
		} 
		catch (Exception e) {
			System.out.println("게시물 수를 구하는 중 예외 발생");
			e.printStackTrace();
		}
		return totalCount;
	}
	
	
	
	//목록에 출력할 실제 게시물을 인출(페이징 기능 추가)
	public List<MVCBoardDTO> selectListPage(Map<String, Object> map) {
		
		/*
		모델1에서 사용했던 테이블 board에서 mvcboard로 변경되었으므로
		DTO객체와 컬럼명에 대한 수정을 해야한다.
		*/
		List<MVCBoardDTO> board = new Vector<MVCBoardDTO>();
		String query = " "
					 + "SELECT * FROM ( "
					 + "	SELECT Tb.*, ROWNUM rNum FROM ( "
					 + "		SELECT * FROM mvcboard ";
		if (map.get("searchWord") != null) 
		{
			query += " WHERE " + map.get("searchField")
				   + " LIKE '%" + map.get("searchWord") + "%' "; 
		}
		//정렬을 위한 컬럼명은 num -> idx 로 변경된다.
		query += " 		  ORDER BY idx DESC "
			   + "	  ) Tb "
			   + " ) "
			   + " WHERE rNum BETWEEN ? AND ?";
		
		try {
			psmt = con.prepareStatement(query);
			psmt.setString(1, map.get("start").toString());
			psmt.setString(2, map.get("end").toString());
			rs = psmt.executeQuery();
			
			while(rs.next()) {
				MVCBoardDTO dto = new MVCBoardDTO();
				
				/* 테이블이 mvcboard로 변경되므로 setter에 대한 수정이
				필요하다. */
				dto.setIdx(rs.getString(1));
				dto.setName(rs.getString(2));
				dto.setTitle(rs.getString(3));
				dto.setContent(rs.getString(4));
				//날짜이므로 getDate()사용
				dto.setPostdate(rs.getDate(5));
				dto.setOfile(rs.getString(6));
				dto.setSfile(rs.getString(7));
				//숫자이므로 getInt()사용
				dto.setDowncount(rs.getInt(8));
				dto.setPass(rs.getString(9));
				//숫자이므로 getInt()사용
				dto.setVisitcount(rs.getInt(10));
				
				board.add(dto);
			}
		} catch (Exception e) {
			System.out.println("게시물 조회 중 예외 발생");
			e.printStackTrace();
		}
		return board;
	}	
	//글쓰기 처리
	public int insertWrite(MVCBoardDTO dto) {
		int result = 0;
		try {
			/* 쿼리문의 일련번호는 모델1 게시판에서 생성한 시퀀스를 그대로
			사용한다. 나머지 값들은 컨트롤러(서블릿)에서 받은 후 모델(DAO)로
			전달한다.*/
			String query = "INSERT INTO mvcboard ( "
						+ " idx, name, title, content, ofile, sfile, pass) "
						+ " VALUES ( "
						+ " seq_board_num.NEXTVAL,?,?,?,?,?,?)";
			psmt = con.prepareStatement(query);
			psmt.setString(1, dto.getName());
			psmt.setString(2, dto.getTitle());
			psmt.setString(3, dto.getContent());
			psmt.setString(4, dto.getOfile());
			psmt.setString(5, dto.getSfile());
			psmt.setString(6, dto.getPass());
			result = psmt.executeUpdate();
		} 
		catch (Exception e) {
			System.out.println("게시물 입력 중 예외 발생");
			e.printStackTrace();
		}
		return result;
	}
	
	//내용보기
	public MVCBoardDTO selectView(String idx) {
		//일련번호와 일치하는 게시물 1개 인출
		MVCBoardDTO dto = new MVCBoardDTO();
		String query = "SELECT * FROM mvcboard WHERE idx=?";
		try {
			psmt = con.prepareStatement(query);
			psmt.setString(1, idx);
			rs = psmt.executeQuery();
			
			if (rs.next()) {
				dto.setIdx(rs.getString(1));
				dto.setName(rs.getString(2));
				dto.setTitle(rs.getString(3));
				dto.setContent(rs.getString(4));
				dto.setPostdate(rs.getDate(5));
				dto.setOfile(rs.getString(6));
				dto.setSfile(rs.getString(7));
				dto.setDowncount(rs.getInt(8));
				dto.setPass(rs.getString(9));
				dto.setVisitcount(rs.getInt(10));
			}
		}
		catch (Exception e) {
			System.out.println("게시물 상세보기 중 예외 발생");
			e.printStackTrace();
		}
		return dto;
	}
	
	//조회수 증가
	public void updateVisitCount(String idx) {
		String query = "UPDATE mvcboard SET "
					+ " visitcount=visitcount + 1 "
					+ " WHERE idx=?";
		try {
			psmt = con.prepareStatement(query);
			psmt.setString(1, idx);
			psmt.executeQuery();
		} 
		catch (Exception e) {
			System.out.println("게시물 조회수 증가중 예외 발생");
			e.printStackTrace();
		}			
	}
}