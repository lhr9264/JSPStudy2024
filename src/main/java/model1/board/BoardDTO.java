package model1.board;
// board 테이블의 컬럼과 동일하게 멤버변수 선언
public class BoardDTO {
	
	private String num;
	private String title;
	private String content;
	private String id;
	private String visitcount;
	private java.sql.Date postdate;
	/*
	 * 회원의 이름을 출력하고 싶다면 'member'테이블과 'join'을 해야하므로
	 * 이를 위해 멤버변수를 초기화 한다.
	 */
	private String name;
	
	public java.sql.Date getPostdate() {
		return postdate;
	}
	public void setPostdate(java.sql.Date postdate) {
		this.postdate = postdate;
	}
	// 특별한 이유가 없다면 생성자는 선언하지 않는다.
	// getter/setter 선언
	public String getNum() {
		return num;
	}
	public void setNum(String num) {
		this.num = num;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getVisitcount() {
		return visitcount;
	}
	public void setVisitcount(String visicount) {
		this.visitcount = visicount;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	
	
}
