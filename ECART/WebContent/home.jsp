<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.ArrayList" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
<link rel="stylesheet" type="text/css" href="home.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
 <style>
    body {
        font-family: Arial, sans-serif;
        background-color: grey;
        margin: 0;
        padding: 0;
    }

    .headerdiv {
        background-color: black;
        color: #fff;
        text-align: center;
        padding: 20px;
    }

    .hdivoptions {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-top: 10px;
    }
select, .login-button, .cart-button {
    padding: 8px;
    font-size: 14px;
    border-radius: 5px;
    width: 100%; /* Adjusted width for better spacing */
    margin-right: 10px; /* Margin between buttons */
}

select:last-child, .login-button:last-child, .cart-button:last-child {
    margin-right: 0; /* Remove margin from the last button to prevent extra space */
}


    .main-content {
        max-width: 1200px;
        margin: 20px auto;
        padding: 20px;
        background-color: #fff;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
    }

    h1 {
        text-align: center;
        color: #007bff;
    }

    #productcard {
        display: flex;
        flex-wrap: wrap;
        justify-content: space-around;
    }

    .product {
        border: 1px solid #ddd;
        border-radius: 5px;
        margin: 10px;
        padding: 10px;
        width: 250px;
        background-color: #fff;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
    }

    .product-image {
        width: 100%;
        height: 150px;
        overflow: hidden;
        margin-bottom: 10px;
    }

    .product-image img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    .product p {
        margin: 5px 0;
        font-size: 14px;
    }

    .product button {
        display: block;
        width: 100%;
        padding: 8px 0;
        background-color: #007bff;
        color: #fff;
        border: none;
        border-radius: 5px;
        font-size: 16px;
        cursor: pointer;
        transition: background-color 0.3s ease;
    }

    .product button:hover {
        background-color: #0056b3;
    }

    .cart-button {
        position: fixed;
        bottom: 20px;
        right: 20px;
        background-color: #007bff;
        color: #fff;
        border: none;
        border-radius: 50%;
        width: 50px;
        height: 50px;
        font-size: 24px;
        display: flex;
        justify-content: center;
        align-items: center;
        cursor: pointer;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
    }

    .cart-button:hover {
        background-color: #0056b3;
    }

    /* Responsive styles */
    @media (max-width: 768px) {
        .product {
            width: 100%;
        }

        .cart-button {
            width: 40px;
            height: 40px;
            font-size: 20px;
            bottom: 10px;
            right: 10px;
        }
    }
</style>
</head>
<body>
  <div class="headerdiv">
     <p>Shopping Cart</p>
     <div class="hdivoptions">
         <select id="CategoryList">
            <option value="All" selected>All Categories</option>
            <% 
            // Retrieve product categories from the request scope
            request.getRequestDispatcher("/ProductCategory").include(request,response);
            ArrayList<String> productCategories = (ArrayList<String>)request.getAttribute("prodcat");
            if(productCategories != null) {
                for (String category : productCategories) { %>
                    <option value="<%= category %>"><%= category %></option>
                <% }
            } %>
         </select>
         <select id="pricelist">
            <option value="All" selected>Price</option>option>
            <option value="0" >Below 500</option>
            <option value="500" >500-1000</option>
            <option value="1000" >1000-10000</option>
            <option value="10000" >Above 10000</option>
         </select>
         <button class="login-button" id="OpenLogin" >Login</button>
         <button class="cart-button" id="OpenCart"><i class="fas fa-shopping-cart"></i></button>
     </div>
  </div>
  
  <div id="productcard"> 
      
      
  </div>
  <div class="pagination">
  <button id="prev">Previous</button>
  <input id="pagevalue" value="1"/>
  <button id="next">Next</button>
</div>
  <script>
     $(document).ready(function(){
    	 var pagenumber=0
    	 loaddata("All","All");
    	 var datalength;
    	 function loaddata(selectedcategory,selectedprice){  
    		 
    		 $.ajax({
   			  url:"ProductServlet",
   			  type:"POST",
   			  data:{category:selectedcategory,price:selectedprice,page:pagenumber},
   			  success:function(data){
   				  console.log(data);
   				  datalength=data.length;
   				  displayingproducts(data);
   			  },
   			  error:function(xhr, status, error) {
     	            console.error(status, error);
     	        }
   		  })
    	 }
    	 $("#next").click(function(){
    		 if(datalength<6){
    			 alert("no more elements");
    		 }else{
    			 pagenumber=pagenumber+1;
        		 newdata();
        		 $("#pagevalue").val(pagenumber+1);
    		 }
    		 
    	 })
    	 $("#prev").click(function(){
    		 if(pagenumber!=0){
    			 pagenumber=pagenumber-1;
    			 newdata();
    			 $("#pagevalue").val(pagenumber-1);
    		 }else{
    			 alert("Your are at page 1");s
    		 }
    		 
    		 
    	 })
    	 $("#CategoryList, #pricelist").change(function(){
   		    
   		    newdata();
   		});
    	 function newdata(){
    		 var selectedCategory = $("#CategoryList").val();
    		 var selectedPrice = $("#pricelist").val();
    		 loaddata(selectedCategory, selectedPrice);
    	 }
    	 function creatingcomponents(product){
   		  var productDiv = $('<div>').addClass('product');

   		// Create a div for the image
   		var imageDiv = $('<div>').addClass('product-image');

   		// Create the image element
   		var image = $('<img>').attr('src', product.image);

   		// Append the image to the image div
   		imageDiv.append(image);

   		// Create a paragraph for the product title
   		var ptitle = $('<p>').text('Product name: ' + product.prod_title);

   		// Create a paragraph for the price
   		var price = $('<p>').text('Price: $' + product.prod_price);

   		// Create the button
   		var button = $('<button>').text('Add to Cart');

   		// Add click event listener to the button
   		button.click(function(){
   			addingcart(product);
   		})

   		// Append the elements to the productDiv
   		productDiv.append(imageDiv);
   		productDiv.append(ptitle);
   		productDiv.append(price);
   		productDiv.append(button);
   	    return productDiv;
   	  }
   	  function displayingproducts(data){
   		  var $p_data = $('#productcard');
   		  $p_data.empty(); // Clear previous content

   		  data.forEach(function(product) {
   		      var productComponent = creatingcomponents(product);
   		      $p_data.append(productComponent);
   		  });
   		  
   	  }
   	  function addingcart(product){
   		  
   		  $.ajax({
   			  url:'CartAdding',
   			  type:'POST',
   			  data:{prod:product},
   			  success:function(data){
   				  alert(data);
   			  },
   			  error:function(xhr, status, error) {
       	            console.error(status, error);
       	        }
   		  })
   	  }
   	  $("#OpenCart").click(function(){
		  window.location.href = 'cart.jsp';
	  })
	   $("#OpenLogin").click(function(){
		  window.location.href = 'Login.jsp';
	  })
     })
  
  </script>
  
 
</body>
</html>