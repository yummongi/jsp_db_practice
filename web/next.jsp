<%@ page import="java.sql.*" %>
<%@ page import="dto.SearchDto" %>
<%@ page import="java.util.ArrayList" %><%--
  Created by IntelliJ IDEA.
  User: User
  Date: 2022-08-05
  Time: 오후 2:39
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String search = request.getParameter("search");

  final String driver = "org.mariadb.jdbc.Driver";
  final String DB_IP = "localhost";
  final String DB_PORT = "3306";
  final String DB_NAME = "dbdb";
  final String DB_URL =
          "jdbc:mariadb://" + DB_IP + ":" + DB_PORT + "/" + DB_NAME;
  System.out.println(DB_URL);
  Connection conn = null;
  PreparedStatement pstmt = null;
  ResultSet rs = null;

  try {
    Class.forName(driver);
    conn = DriverManager.getConnection(DB_URL, "root", "1234");
    if (conn != null) {
      System.out.println("DB 접속 성공");
    }

  } catch (ClassNotFoundException e) {
    System.out.println("드라이버 로드 실패");
    e.printStackTrace();
  } catch (SQLException e) {
    System.out.println("DB 접속 실패");
    e.printStackTrace();
  }


  ArrayList<SearchDto> list = new ArrayList<>();

  try {
    String sql = "INSERT INTO `tb_search` (`search`) VALUES ('?') ON DUPLICATE KEY UPDATE cnt = cnt + 1";

    pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, search);
    rs = pstmt.executeQuery();

    sql = "SELECT * FROM `tb_search`";

    pstmt = conn.prepareStatement(sql);
    rs = pstmt.executeQuery();
    while(rs.next()){
      SearchDto dto = new SearchDto();
      dto.setSearch(rs.getString("search"));
      dto.setCnt( rs.getInt("cnt"));
      list.add(dto);
    }



  } catch (SQLException e) {
    System.out.println("error: " + e);
  } finally {
    try {
      if (rs != null) {
        rs.close();
      }
      if (pstmt != null) {
        pstmt.close();
      }

      if (conn != null && !conn.isClosed()) {
        conn.close();
      }
    } catch (SQLException e) {
      e.printStackTrace();
    }
  }

%>

<html>
<head>
    <title>Title</title>
</head>
<body>
form.jsp에서 전달된 데이터 <%=search%> <br>

<% for (SearchDto d : list){ %>
  검색어: <%=d.getSearch()%>>(<%=d.getCnt()%>)<br>
<%} %>

</body>
</html>
