package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

import dal.Contract;
import dao.DaoBridge;
import models.Products;

public class ProductServlet extends HttpServlet {
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		try {
			Contract cn = DaoBridge.getDalObject();

			String selcat = request.getParameter("category");
			String selprice = request.getParameter("price");
			int page = Integer.parseInt(request.getParameter("page"));
			ArrayList<Products> al = cn.getProducts(selcat, selprice, page);
			Gson gson = new Gson();
			String json = gson.toJson(al);
			response.setContentType("application/json");
			PrintWriter out = response.getWriter();
			out.print(json);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
