package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
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

public class ShippingServlet extends HttpServlet {

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession();
		List<Products> cart = (List<Products>) session.getAttribute("cart");
		try {
			Contract cn = DaoBridge.getDalObject();
			ArrayList<Object> hm = cn.calshippinggst(cart);
			session.setAttribute("shippingdetails", hm);
			Gson gson = new Gson();
			String json = gson.toJson(hm);
			response.setContentType("application/json");
			response.setCharacterEncoding("UTF-8");
			// Write JSON to response output stream
			PrintWriter out = response.getWriter();
			out.print(json);
			out.flush();

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
