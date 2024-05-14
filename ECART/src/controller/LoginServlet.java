package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dal.Contract;
import dao.DaoBridge;

public class LoginServlet extends HttpServlet {
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		try {
			Contract cn = DaoBridge.getDalObject();

			String user_name = request.getParameter("username");
			String pswd = request.getParameter("password");
			boolean flag = cn.loginverification(user_name, pswd);
			HttpSession session = request.getSession();
			if (flag == true) {
				session.setAttribute("username", user_name);
				response.sendRedirect("home.jsp");
			} else {
				response.sendRedirect("error.jsp");
			}

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

}
