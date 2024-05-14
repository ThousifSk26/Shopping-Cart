package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;

import dal.Contract;
import dao.DaoBridge;
import models.Products;

public class UpdateCart extends HttpServlet {

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		int p_id = Integer.parseInt(request.getParameter("p_id"));
		int quantity = Integer.parseInt(request.getParameter("p_mode"));
		HttpSession session = request.getSession();
		List<Products> cart = (List<Products>) session.getAttribute("cart");

		try {
			Contract cn = DaoBridge.getDalObject();
			List<Products> c = cn.getupdatecart(cart, p_id, quantity);
			session.setAttribute("cart", c);
			Gson gson = new Gson();
			String data = gson.toJson(cart);
			response.setContentType("application/json");
			PrintWriter out = response.getWriter();
			out.print(data);

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

}