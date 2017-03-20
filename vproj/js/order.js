// JavaScript Document
$(document).ready(function(){
		//Creating an array to hold pizza items
		var pCart = [];
		
		//Global variables
		var gTotal = 0;  //holds the grand total
		var sTotal = 0;  //holds the sub total
		var sTax   = 0;  //holds the sales tax
		var orderNumber = 0;  //holds the order number
		var orderID = 0;  //holds the order id 	
		var count = 0; 		//Variable to keep track of the array indices
		
		//Disable the void button on page load
		$('#voidBtn').prop('disabled',true);
		//Disable the payNow button on page load
		$('#payNow').prop('disabled',true);		
		//Disable the tender button on page load
		$('#tSale').prop('disabled',false);	
		
		//When an order has been placed, then you can enable the tender btn
		$('#orderBtn').on('click',function(){
			$('#payNow').prop('disabled',false);
		});
		
		$('#payNow').on('click',function(){
			
			if($("#deliveryNext").is(":disabled") == false){
				$.ajax({
						url: 'cfc/order.cfc?method=UpdateQty&orderID='+orderID+'&args='+JSON.stringify(pCart),
						//datatype: 'text',
						data: {'args':pCart},
						datatype: 'json',
						method: 'post',
						//async : false,
						success: (function(result){
							data = JSON.parse(result);
							/*orderNumber = data.ORDERNUMBER;*/
							orderID = data.ORDERID;
						})
				});		
			}
			//Set the Amount Due 
			$('#amountDue').text('$'+$('#grandTotal').text());			
		});
		
		$('#tAmount').keyup(function(){
				var amountTendered = $(this).val();
				var amountDue = $('#grandTotal').text();
				var moneyOwed = (parseFloat(amountDue)) - amountTendered;
				
				if(moneyOwed <0){
				//Update Change Due
				$('#changeDue').text('$'+Math.abs(moneyOwed.toFixed(2)));
				}
				
				//If amount tendered is greater than the amount due then we can accept payment.
				if(amountTendered > amountDue)
					$('#tSale').prop('disabled',false);			
				
		});
		
		//If the tender is canceled then clear out the amount tendered.
		$('.cancelBtn').on('click',function(){
			$('#tAmount').val('');
		});
		//When the tender btn is click, record the data via ajax
		$('#tSale').on('click',function(){
			
				var amountTendered = $('#tAmount').val();
				var amountDue = $('#grandTotal').text();
				var moneyOwed = (parseFloat(amountDue)) - amountTendered;
						moneyOwed =  Math.abs(moneyOwed.toFixed(2));	
						
		 		$.ajax({
						url: 'cfc/tender.cfc?method=Save',
						//datatype: 'text',
						data: {'orderID':parseInt(orderID),'changeGiven':moneyOwed,'amountTendered':amountTendered},
						datatype: 'json',
						method: 'post',
						//async : false,
						success: (function(result){
							data = JSON.parse(result);
							if(data.STATUS == 'success'){
								$('#orderNumberLbl').empty().html('<span style="color:#628213;font-weight:bold;">Order #'+orderNumber+'</span>');
							}
							//Disable the paynow button since the order has been payed for
							$('#payNow').prop('disabled',true);		
							//Clear the tendered amount
							$('#tAmount').val('');
							//Close the modal
							$('#tenderBox').modal('hide')
						})						
			});
		});
		
		//Enable the void button if a person clicks on an order entry
		$('#lineItemSection').on('click','.lineItem',function(){
			$('#voidBtn').prop('disabled',false);		
			//When a lineItem is clicked, highlight to indicate that the item has been selected
			$(this).addClass('lineItemActive');
			//var active = $('.lineItemActive');							
		});
		
		//Removes selected items by a count of one
		$('#voidBtn').on('click',function(){
			
			//Disable the Pay Now button since an item has been voided.  We need to have the user resubmit the order.
			//$('#payNow').prop('disabled',true);					
			
			$('.lineItemActive').each(function(){
				var itemName = $(this).children('.lineItemName').text();
				//Checking to see if the item is already in the cart
				for (p in pCart){
					//If there is a match then just update the qty
					if(itemName == pCart[p].name){	
					  if (pCart[p].qty == 1){
							pCart[p].qty = 0;	
							$('#item_'+p).empty();
						}						
						else{
 							pCart[p].qty -= 1;				
							//Update the text in the order entry form						
							$('#item_'+p).empty().html(pCart[p].qty +' <span class="lineItemName">'+pCart[p].name+'</span> $'+pCart[p].price);
							pCart[p].itemID = 0;
						}
						//Computing the new pricing
						getPricing(pCart[p].price,pCart[p].qty,'substract');
						gTotal = sTotal + (sTotal * (7.25 / 100));					
						$('#grandTotal').empty().text(gTotal.toFixed(2));																					
					}
				}//End of for in loop							
				
				//Remove highlights from line items
				$('.lineItem').removeClass('lineItemActive');					
				
				return 0;

			});
		});
		
		$('.lineItems').on('click',function(){

				//Retrieve the text of the menu item clicked
				var itemTxt = $(this).text();
				//Retrieve the price of the menu item clicked
				var itemPrice = $(this).next('.lineItemPrice').text();						
				//Retrieve the item id of the menu item clicked
				var itemID = $(this).next().next('.lineItemID').text();

				//Checking to see if the item is already in the cart
				for (p in pCart){
					//If there is a match then just update the qty
					if(itemTxt == pCart[p].name){					
						//Update the qty
						pCart[p].qty = pCart[p].qty + 1;			
						//Update the text in the order entry form						
						$('#item_'+p).empty().html(pCart[p].qty +' <span class="lineItemName">'+pCart[p].name+'</span> $'+pCart[p].price);
				
						//Computing the new pricing
						getPricing(itemPrice,pCart[p].qty,'add');
						gTotal = sTotal + (sTotal * (7.25 / 100));					
						$('#grandTotal').empty().text(gTotal.toFixed(2));						
						return 0;
					}
				}//End of for in loop	
				
				//Create an object for this array index				
				pCart[count] = {};
				pCart[count].name = itemTxt;
				pCart[count].itemID = itemID;
				pCart[count].price = itemPrice;	
				pCart[count].qty =  1;	
										
				//Append the data to the order entry form									
				$('#lineItemSection').append('<p id="item_'+count+'" class="lineItem">'+ pCart[count].qty + ' <span class="lineItemName">'+pCart[count].name+'</span> $'+pCart[count].price+'</p>');																
				
				getPricing(itemPrice,1,'add');
				
				gTotal = sTotal + (sTotal * (7.25 / 100));					
				$('#grandTotal').empty().text(gTotal.toFixed(2));				
					
				//Increment the counter
				count = addItem();							
				
		});

				//A function for getting pricing, used to updtae the subtotal and grand total.
				function getPricing(iPrice,iQty,operation){
					if(gTotal == 0){
						//Add the subTotal to the price of the item selected
						sTotal = parseFloat(iPrice);
						$('#subTotal').empty().text(sTotal.toFixed(2));
						//Add the the item price to the grand total
						gTotal = parseFloat(iPrice);				
					 //$('#grandTotal').empty().text(gTotal.toFixed(2));
					}
					else if(operation == 'add'){
						//Add the subTotal to the price of the item selected
						sTotal += parseFloat(iPrice);
						$('#subTotal').empty().text(sTotal.toFixed(2));
						//Add the the item price to the grand total
						gTotal += parseFloat(iPrice);				
						//$('#grandTotal').empty().text(gTotal.toFixed(2));					
					}			
					else{
						//Add the subTotal to the price of the item selected
						sTotal -= parseFloat(iPrice);
						$('#subTotal').empty().text(sTotal.toFixed(2));
						//Add the the item price to the grand total
						gTotal -= parseFloat(iPrice);				
						//$('#grandTotal').empty().text(gTotal.toFixed(2));						
					}
				}		


		//Closure to increment the cart items
		var addItem = (function () {
    				var counter = 0;
				    return function () {return counter += 1;}
		})();
		
		$('#orderNumberLbl').text('New Order');
		
		$('#orderBtn').on('click',function(){
			var orderNum = $('#orderNumberLbl').text();
			
			if(orderNumber == 0){
		 		$.ajax({
						url: 'cfc/order.cfc?method=Create&args='+JSON.stringify(pCart),
						//datatype: 'text',
						data: {'args':pCart},
						datatype: 'json',
						method: 'post',
						//async : false,
						success: (function(result){
							data = JSON.parse(result);
							orderNumber = data.ORDERNUMBER;
							orderID = data.ORDERID;
						})
				});								
			}
			else{
		 		$.ajax({
						url: 'cfc/order.cfc?method=UpdateQty&orderID='+orderID+'&args='+JSON.stringify(pCart),
						//datatype: 'text',
						data: {'args':pCart},
						datatype: 'json',
						method: 'post',
						//async : false,
						success: (function(result){
							data = JSON.parse(result);
							/*orderNumber = data.ORDERNUMBER;*/
							orderID = data.ORDERID;
						})
				});						
			}			
		});
				
	});