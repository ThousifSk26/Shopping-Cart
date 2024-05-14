<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="models.Products" %>
<%@ page import="models.Discount" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
<link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<style>
    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background-color: black; /* Light gray background */
        color: #333; /* Dark text color */
        margin: 0;
        padding: 20px;
    }

    .container {
        max-width: 800px;
        margin: auto;
        background-color: #fff; /* White container background */
        padding: 30px;
        border-radius: 8px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); /* Soft box shadow */
    }

    h2 {
        text-align: center;
        color: black; /* Blue heading color */
        margin-bottom: 30px;
        
    }

    table {
        width: 100%;
        border-collapse: collapse;
        margin-bottom: 30px;
    }

    th, td {
        padding: 12px;
        text-align: center;
        border-bottom: 1px solid #ddd;
    }

    thead {
        background-color: #007bff; /* Dark blue background for table header */
        color: #fff; /* White text color for table header */
    }

    img {
        max-width: 80px;
        height: auto;
        border-radius: 4px;
    }

    select {
        padding: 8px;
        font-size: 16px;
        border-radius: 4px;
        border: 1px solid #ccc;
        width: 100%;
        margin-bottom: 20px;
    }

    #discountdetails, #valuesdata {
        background-color: #f8f9fa; /* Light gray background */
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); /* Soft box shadow */
        margin-bottom: 30px;
    }

    .data-table {
        width: 100%;
        border-collapse: collapse;
    }

    .data-table th, .data-table td {
        padding: 10px;
        border-bottom: 1px solid #ddd;
    }

    .data-table th {
        background-color: black; /* Light gray background for table header */
    }

    .data-table tbody tr:nth-child(even) {
        background-color: #f9f9f9; /* Alternate row background color */
    }

    button {
        padding: 12px 20px;
        font-size: 16px;
        background-color: #007bff; /* Blue button background color */
        color: #fff; /* White button text color */
        border: none;
        border-radius: 4px;
        cursor: pointer;
        transition: background-color 0.3s ease;
    }

    button:hover {
        background-color: #0056b3; /* Darker blue on hover */
    }

    .text-center {
        text-align: center;
    }
</style>

</head>
<body>
    <% 
       ArrayList<Products> cart=(ArrayList<Products>)session.getAttribute("cart");
       request.getRequestDispatcher("/DataCalculation").include(request,response);
       Map<String,Double> hm=(Map<String,Double>)session.getAttribute("priceDetails");
      %>
 
<div class="container">
    <h2>Product Details</h2>

    <table class="table table-striped">
        <thead class="thead-dark">
            <tr>
                <th>Product Details</th>
                <th>Price</th>
                <th>Quantity</th>
                <th>GST</th>
                <th>Shipping Charge</th>
                
            </tr>
        </thead>
        <tbody>
            <% for (Products p : cart) { %>
            <tr>
                <td><img src="<%= p.getImage() %>"></td>
                <td><%= p.getProd_price() %></td>
                <td><%= p.getQuantity() %></td>
                <td><%= p.getGst() %></td>
                <td><%= p.getShipping_charge() %></td>
            </tr>
            <% } %>
        </tbody>
    </table>
    <br><br>
</div>
<div>
   <select id="discountvalues">
       <option value="">Select and discount coupon</option>
       <% request.getRequestDispatcher("/DiscountServlet").include(request,response);
   ArrayList<Discount> d = (ArrayList<Discount>)request.getAttribute("discount"); 
       if(d != null) {
                for (Discount dis: d) { %>
                    <option value="<%= dis.getDcpn_value() %>"><%= dis.getDcpn_title() %></option>
                <% }
            } %>
   </select>

</div>

<div id="discountdetails">
  
</div>
<div id="valuesdata">
</div>


<br><br>
 <script>
    $(document).ready(function() {
	    $("#discountvalues").change(function() {
	        var discount_value = $("#discountvalues").val();
	        $.ajax({
	            url: 'ApplyingDiscountServlet',
	            type: 'POST',
	            data: { "discount": discount_value },
	            success: function(data) {
	            	console.log(data[1]);
	                
	                calshipping(data);
	            },
	            error: function(xhr, status, error) {
	                console.error(status, error);
	            }
	        });
	    });
	    function datadisplaying(data,ship){
	    	$("#discountdetails").empty();
	    	var $table = $('<table>').addClass('data-table');
	    	  var $thead = $('<thead>');
	    	  var $tbody = $('<tbody>');

	    	  // Create table header
	    	  var $headerRow = $('<tr>');
	    	  $headerRow.append($('<th>').text('Sno'));
	    	  $headerRow.append($('<th>').text('Price'));
	    	  $headerRow.append($('<th>').text('GST'));
	    	  $headerRow.append($('<th>').text('Shipping Charge'));
	    	  $headerRow.append($('<th>').text('Shipping GST'));
	    	  $thead.append($headerRow);
	    	  var count=1;
	    	  // Create table body rows
	    	  $.each(data, function(key, values) {
	    		    var $row = $('<tr>');
	    		    $row.append($('<td>').text(count));
	    		    count=count+1;
	    		    $.each(values, function(index, value) {
	    		    	 var roundedValue = parseFloat(value).toFixed(2);
	    		         $row.append($('<td>').text(roundedValue));
	    		    });
	    		    //i need to add the json ship which contain the two values how i can do this;
	    		    if (ship[key]) { // Ensure the ship data exists for the current key
                       $.each(ship[key], function(index, value) {
                        var roundedValue = parseFloat(value).toFixed(2);
                        $row.append($('<td>').text(roundedValue));
                     });
                   }
	     		    $tbody.append($row);
	          });
	    	 

	    		  $table.append($thead).append($tbody);
	    		  // Append the table to the body
	    		  $('#discountdetails').append($table);	 
	    }
	    function  pricegstdisplay(data,ship){
	    	
	    	$("#valuesdata").empty();
	    	var $dataContainer = $('#valuesdata');
	    	  var $table = $('<table>').addClass('data-table').attr('id', 'myDataTable');;
	    	  var $tbody = $('<tbody>');
	    	  
	    	  // Loop through the data object and create table rows
	    	  var total=0;
	    	  $.each(data, function(key, value) {
	    	    var $row = $('<tr>');
	    	    $row.append($('<td>').text(key));
	    	    $row.append($('<td>').text(value.toFixed(2)));
	    	    total=total+Number(value.toFixed(2));
	    	    // Round off to 2 decimal places
	    	    $tbody.append($row);
	    	  });
	    	  $.each(ship, function(key, value) {
		    	    var $row = $('<tr>');
		    	    $row.append($('<td>').text(key));
		    	    $row.append($('<td>').text(value.toFixed(2)));
		    	    total=total+Number(value.toFixed(2));
		    	    // Round off to 2 decimal places
		    	    $tbody.append($row);
		     });
	    	 var $row=$('<tr>');
	    	 $row.append($('<td>').text("Total Amount to be paid"));
	    	 $row.append($('<td>').text(total));
	    	 $tbody.append($row);
	    	  
	    	  

	    	  // Append table body to the table
	    	  $table.append($tbody);

	    	  // Append table to the data container
	    	  $dataContainer.append($table);
	    }
	    function calshipping(data){
	    	$.ajax({
	    		url:'ShippingServlet',
	    		type:'POST',
	    		dataType:"json",
	    		success:function(ship){
	    			console.log(ship);
	    			console.log(ship[1]["ShippingGst"])
	    			datadisplaying(data[0],ship[0]);
	                pricegstdisplay(data[1],ship[1]);
	    			
	    		},
	    		error: function(xhr, status, error) {
	                console.error(status, error);
	            }
	    	});
	    }
	    
	});
     
 </script>
      
</body>
</html>