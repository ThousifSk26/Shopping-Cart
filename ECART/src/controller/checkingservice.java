package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;

import dal.Contract;
import dao.DaoBridge;
import models.Products;

public class checkingservice extends HttpServlet {

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		System.out.println("hi");
		int pincode = Integer.parseInt(request.getParameter("pin_code"));
		HttpSession session = request.getSession();
		ArrayList<Products> cart = (ArrayList<Products>) session.getAttribute("cart");
		PrintWriter out = response.getWriter();
		response.setContentType("application/json");

		try {
			Contract cn = DaoBridge.getDalObject();
			ArrayList<String> name = cn.getNonserviceable(cart, pincode);
			ArrayList<String> product_names = new ArrayList<>();
			Gson gson = new Gson();
			String json = gson.toJson(name);
			out.print(json);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}