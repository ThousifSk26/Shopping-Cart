<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
   <link rel="stylesheet" type="text/css" href="home.css">
<style>
        body {
            font-family: Arial, sans-serif;
            background-color:black;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: space-between;
            min-height: 100vh;
        }

        .cartdiv {
            width: 100%;
            text-align: center;
            margin-bottom: 20px;
        }

        h1 {
            margin: 20px 0;
            color: white;
        }

        #itemlist {
            width: 100%;
            max-width: 1000px;
            padding: 20px;
            display: flex;
            flex-wrap: wrap;
            justify-content: space-around;
        }

        .product {
            width: 45%; /* Two products per row with spacing */
            margin-bottom: 20px;
            padding: 15px;
            display: flex;
            flex-direction: column;
            align-items: center;
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0px 2px 6px rgba(0, 0, 0, 0.1);
            box-sizing: border-box; /* Include padding in width calculation */
        }

        .imagediv {
            width: 100%;
            display: flex;
            justify-content: center;
            margin-bottom: 10px;
        }

        .imagediv img {
            height: 150px;
            width: 150px;
            object-fit: cover;
            border-radius: 8px;
        }

        .product-details {
            text-align: center;
        }

        .product-name {
            font-size: 16px;
            font-weight: bold;
            margin-bottom: 10px;
            margin-top:60px;
        }

        .price {
            font-size: 16px;
            color: #007bff;
            margin-bottom: 10px;
            margin-left:30px;
        }

        .quantity {
            display: flex;
            align-items: center;
            margin-top: 10px;
        }

        .quantity input {
            width: 40px;
            text-align: center;
            border: 1px solid #ccc;
            border-radius: 4px;
            margin: 0 10px;
            padding: 5px;
        }

        .quantity button {
            background-color: #007bff;
            color: #fff;
            border: none;
            border-radius: 50%;
            width: 30px;
            height: 30px;
            font-size: 16px;
            cursor: pointer;
        }

        .cart-button {
            padding: 10px 20px;
            font-size: 16px;
            background-color:  #0056b3;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-color:black;
        }

        .cart-button:hover,
        .quantity button:hover {
            background-color: #0056b3;
        }

        @media (max-width: 768px) {
            .product {
                width: 90%; /* Single product per row on small screens */
            }
        }
    </style>
</head>

<body>
   <div class="cartdiv">
      <h1>Shopping Cart</h1>
   </div>
   <div id="itemlist" ></div>
   <div class="cartdiv">
       <button class="cart-button" id="checkout" >Checkout</button>
   </div>
   <script>
   $(document).ready(function() {
	   var pincode=window.prompt("Enter the pincode");
	   checkingservice(); 
	   function checkingservice(){
		   $.ajax({
			   url:"checkingservice",
			   type:"GET",
			   data: {
			        'pin_code': pincode // Pass the pincode as a parameter to the server
			    },
			   success:function(data){
				   if(data==null){
					   window.alert("product are delivered to that service");
					   cartdisplaying();
					   $("#checkout").prop("disabled", false);
				   }else{
					  window.alert("Some products are not able to transported to that service they are:"+data);
					  cartdisplaying();
					  $("#checkout").prop("disabled", true).css({
						    "opacity": "0.6",
						    "cursor": "not-allowed"
						});
				   }
				   
			   },
			   error:function(xhr,status,error){
				   console.error("Error cann't invoke the data",error);
				   alert("Error feteching data ")
			   }
		   })
	   }
	   
	   function cartdisplaying(){
		   $.ajax({
		 		  url:"CartAdding",
		 		  type:"GET",
		 		  dataType:"json",
		 		  success:function(data){
		 			  console.log(data);
		 			  addingdatalist(data);
		 		  },
		 		  error: function(xhr, status, error) {
		               console.error("Error fetching data:", error);
		               alert("Error fetching data. Please try again.");
		           }
		 	  });
			   
	   }
	  
	   function itemcomponent(product){
		   var productDiv=$('<div>').addClass('product');
		   
		   //adding image
		   var imagediv=$('<div>').addClass('imagediv');
		   var image=$('<img>').attr('src', product.image);
		   imagediv.append(image);
		   
		   var title=$('<p>').text('Product name: ' + product.prod_title);
		   imagediv.append(title);
		   
		   var qpdiv=$('<div>').addClass('qpdiv');
		   var pdiv=$('<div>').addClass('pdiv');
		   var price=$('<p>').addClass('price').text("RS."+product.prod_price);
		   pdiv.append(price);
		   qpdiv.append(pdiv);
		   
		   var quantityDiv = $('<div>').addClass('quantity');
		   var minusButton = $('<button>').text('-');
		   var quantityInput = $('<input>').attr('type', 'text').val(product.quantity);
		   var plusButton = $('<button>').text('+');
		   var removebutton=$('<button>').css({"background-color":"red"});
		   var span = $('<span>').html("&#128465;");
		  
	//	   span.css({
		//	    "font-size": "32px",   // Increase font size to 24 pixels
	//		    "background-color": "red"  // Add red background color
		//	});
		   //removebutton.append(span);
		   quantityDiv.append(minusButton, quantityInput, plusButton);
		   qpdiv.append(quantityDiv);
		  
		   	
		   minusButton.click(function(){
			   var currentval=parseInt(quantityInput.val());
			   quantityInput.val(currentval-1);
			   updatingsession(product.product_id,currentval-1);
			   if(parseInt(quantityInput.val())==0){
				   updatingsession(product.product_id,0);
				   productDiv.remove();
				   checkingservice();
			   }
		   })
		   plusButton.click(function(){
			   var currentval=parseInt(quantityInput.val());
			   quantityInput.val(currentval+1);
			   updatingsession(product.product_id,currentval+1);
		   }) 
		   removebutton.click(function(){
			   updatingsession(product.product_id,0);
			   productDiv.remove();
			   checkingservice();
		   })
		   productDiv.append(imagediv);
		   productDiv.append(qpdiv);
		   return productDiv
		   
		   
	   }
	   
	   function addingdatalist(data){
		   var listdiv=$("#itemlist");
		   listdiv.empty();
		   
		   data.forEach(function(product){
			   var productcomponent=itemcomponent(product);
			   listdiv.append(productcomponent);
		   })
	   }
	   
	   function updatingsession(pid,pmode){
		   $.ajax({
			   url:'UpdateCart',
			   type:'POST',
			   data:{'p_id':pid,'p_mode':pmode},
			   success:function(data){
				   console.log(data);
			   },
			   error:function(xhr,status,error){
				   console.log("error");
			   }
		   });
	   }
	   $("#checkout").click(function(){
		   
		   window.location.href="checkout.jsp";
	   })
      })
   
   </script>
</body>
</html>