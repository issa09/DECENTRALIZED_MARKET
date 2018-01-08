pragma solidity ^0.4.0;

contract Market {

	uint private bestAsk;
	uint private bestSell;

    struct Trade {
        uint date;
        uint tokens;
        uint unitPrice;
        address proposer;        
    }

    // Un slot représente l'ensemble des offres a un prix donné
    
    struct Slot { 
    	uint slotPrice;
    	Trade[] orderBook;
    }

    mapping (uint => Slot) private orderBook_Sell;
    mapping (uint => Slot) private orderBook_Buy;

    mapping (address => uint) private cash_balance;
    mapping (address => uint) private token_balance;

    // Constructor
    function Market() public{
    	owner = msg.sender;
        cash_balance[msg.sender] = 0;
        token_balance[msg.sender] = 1000000; // We got it all    	
    }

    // **************************************
    //		 	FONCTIONS VENTES
    // **************************************

    // Ajoute simplement un ordre dans la BDD
    function add_LO_Sell_Tokens(uint _token, uint _unitPrice) public {
        Trade memory newTrade = Trade({date:block.timestamp,
                                        tokens: _token,
                                        unitPrice: _unitPrice,
                                        proposer: msg.sender
                                        }
                                       );

        orderBook_Sell[_unitPrice].orderBook.push(newTrade);

        if(_unitPrice<bestSell){
        	bestSell=_unitPrice
        }
        return;
    }

    function del_LO_Sell_Tokens(uint _token, uint _unitPrice) public {
    	Trade memory currentTrade;
 		for(uint i=0; i<orderBook_Sell[_unitPrice].orderBook.length; i++){

 			currentTrade=orderBook_Sell[_unitPrice].orderBook[i];

 			if(currentTrade.tokens==_token && currentTrade.proposer==msg.sender){
 				delete orderBook_Sell[_unitPrice].orderBook[i];
 				findNextBestSellPrice();
 				return;
 			}
 		}
 		throw;
    }  

    function findNextBestSellPrice() private{
    	for(uint i=bestSell+1; i< orderBook_Sell.length; i++){
    		if(orderBook_Sell[i].orderBook.length>0){
    			bestSell=orderBook_Sell[i].slotPrice; 
    			return;
    		}
    	}
    }

    function doSell(uint _tokens, uint _unitPrice, address _dest) private {
        cash_balance[msg.sender] += _unitPrice*_tokens;	
    	cash_balance[_dest] -= _unitPrice*_tokens;   
    	token_balance[msg.sender] += _tokens;	
    	token_balance[_dest] -= _tokens;
    }

    // **************************************
    //		 	FONCTIONS ACHAT
    // **************************************

	function add_LO_Buy_Tokens(uint _token, uint _unitPrice) public {
        Trade memory newTrade = Trade({date:block.timestamp,
                                        tokens: _token,
                                        unitPrice: _unitPrice,
                                        proposer: msg.sender
                                        }
                                       );

        orderBook_Buy[_unitPrice].orderBook.push(newTrade);
        if(_unitPrice>bestBuy){
        	bestBuy=_unitPrice
        }
        return;
    }    

    function del_LO_Buy_Tokens(uint _token, uint _unitPrice) public {
    	Trade memory currentTrade;
 		for(uint i=0; i<orderBook_Sell[_unitPrice].orderBook.length; i++){

 			currentTrade=orderBook_Sell[_unitPrice].orderBook[i];
 			
 			if(currentTrade.tokens==_token && currentTrade.proposer==msg.sender){
 				delete orderBook_Sell[_unitPrice].orderBook[i];
 				findNextBestBuyPrice();
 				return;
 			}
 		}
 		throw;
    }

    function findNextBestBuyPrice() private{ // TO DO
    	for(uint i=bestBuy-1; i>(bestBuy - 1 - orderBook_Sell.length); i--){
    		if(orderBook_Sell[i].orderBook.length>0){
    			bestSell=orderBook_Sell[i].slotPrice; // On prend la première valeur disponible
    			return;
    		}
    	}
    }

	function doBuy(uint _tokens, uint _unitPrice, address _dest) private {
	    cash_balance[msg.sender] -= _unitPrice*_tokens;	
		cash_balance[_dest] += _unitPrice*_tokens;   
		token_balance[msg.sender] -= _tokens;	
		token_balance[_dest] += _tokens;
	}

    // ***************************
    //		 FONCTIONS Trade
    // ***************************


    function grattageVente(uint tokensAsked, uint limitPrice) private {
    	uint tokensFounds=0;
    	uint toTransfert = 0;

    	// 1) Pour chaque slot de prix entre le min (best) et le prix limite client
    	for (uint k=bestSell; k < limitPrice+1 ; k++){ 
    		if (orderBook_Sell[k].orderBook.length==0) {continue;}	// Si le slot n'existe pas, on passe au suivant

    		// 2) Pour chaque trade dans le slot	
    		for(uint m = 0 ; m < orderBook_Sell[k].orderBook.length ; m++){ 
    			if (tokensFounds==tokensAsked) {return;}

    			// 3) Transferer le minimum entre le nb tokens du trade ou le volume de tokens restants

    			// 3.a) Selection du nombre de tokens a transferer
    			toTransfert = min(orderBook_Sell[k].orderBook[m].tokens, tokensAsked - tokensFounds);
    			tokensFounds += toTransfert;

    			// 3.b) Transferer les tokens
    			doSell( toTransfert, 
	    				orderBook_Sell[k].orderBook[m].unitPrice, 
	    				orderBook_Sell[k].orderBook[m].proposer 
	    				);

    			// 4) Detruire le trade si on l'a vidé, sinon soustraire le nombre de tokens
    			if (toTransfert == orderBook_Sell[k].orderBook[m].tokens){
    				delete orderBook_Sell[k].orderBook[m];
    				m-=1; // ATTENTION : Problème d'index => puisque on delete, il faut faire bouger l'index "m"
    			} else {
    				orderBook_Sell[k].orderBook[m].tokens -= toTransfert;
    			}
    		}
    		
    	}
    }


	function grattageAchat(uint tokensAsked, uint limitPrice) private {
    	uint tokensFounds=0;
    	uint toTransfert = 0;

    	// 1) Pour chaque slot de prix entre le min (best) et le prix limite client
    	for (uint k=bestBuy; k > limitPrice ; k--){ 
    		if (orderBook_Buy[k].orderBook.length==0) {continue;}	// Si le slot n'existe pas, on passe au suivant

    		// 2) Pour chaque trade dans le slot	
    		for(uint m = 0 ; m < orderBook_Buy[k].orderBook.length ; m++){ 
    			if (tokensFounds==tokensAsked) {return;}

    			// 3) Transferer le minimum entre le nb tokens du trade ou le volume de tokens restants

    			// 3.a) Selection du nombre de tokens a transferer
    			toTransfert = min(orderBook_Buy[k].orderBook[m].tokens, tokensAsked - tokensFounds);
    			tokensFounds += toTransfert;

    			// 3.b) Transferer les tokens
    			doBuy( toTransfert, 
	    				orderBook_Buy[k].orderBook[m].unitPrice, 
	    				orderBook_Buy[k].orderBook[m].proposer 
	    				);

    			// 4) Detruire le trade si on l'a vidé, sinon soustraire le nombre de tokens
    			if (toTransfert == orderBook_Buy[k].orderBook[m].tokens){
    				delete orderBook_Buy[k].orderBook[m];
    				m-=1; // ATTENTION : Problème d'index => puisque on delete, il faut faire bouger l'index "m"
    			} else {
    				orderBook_Buy[k].orderBook[m].tokens -= toTransfert;
    			}
    		}
    		
    	}
    }

    // ***************************
    //		 FONCTIONS Support
    // ***************************
    function min(uint a, uint b) internal constant returns (uint) {
    	return a < b ? a : b;
	}

	function max(uint a, uint b) internal constant returns (uint) {
	    return a >= b ? a : b;
	}
}