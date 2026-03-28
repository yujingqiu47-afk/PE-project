package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import util.DBUtil;

@WebServlet("/RegisterServlet")

public class RegisterServlet extends HttpServlet{
	
	private static final long serialVersionUID = 1L;
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {

	        String username = request.getParameter("username");
	        String password = request.getParameter("password");
	        String email = request.getParameter("email");

	        try (Connection conn = DBUtil.getConnection()) {
	            PreparedStatement ps = conn.prepareStatement("INSERT INTO users (username, password, email) VALUES (?, ?, ?)");
	            ps.setString(1, username);
	            ps.setString(2, password);
	            ps.setString(3, email);

	            int rows = ps.executeUpdate();

	            if (rows > 0) {
	                request.setAttribute("message", "Registration successful!");
	                request.getRequestDispatcher("login.jsp").forward(request, response);
	            }
	        } catch (SQLException e) {
	        	e.printStackTrace(); 
	            request.setAttribute("error", "Database error: " + e.getMessage());
	            request.getRequestDispatcher("register.jsp").forward(request, response);
	        }
	    }
}
