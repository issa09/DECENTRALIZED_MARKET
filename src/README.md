# Market.sol
Ce smart contract a pour objectif d'offrir une plateforme d'échange. Il possède deux tableaux: les offres d'achats et ceux de ventes (appelés Limit Orders).

## Les trades de la blockchain
Un trade est composé de :

1. Une date d'ajout du trade dans la blockchain 
2. Le nombre de Tokens désirés à l'achat ou la vente 
3. Le prix unitaire du token 
4. L'adresse de l'investisseur proposant le trade


## Les fonctionnalités du smart contract
Les fonctionnalités sont :

1. Ajout d'un ordre limite soit en Sell Side (proposition de vente de tokens) soit en Buy Side (proposition de vente de tokens). 
2. Détection de matchs entre les ordres entrants et ceux déjà inscrits 
3. Transfert de propriété en cas d'exact match entre deux trades


## Fonctionnalités à venir
1.	L'ensemble des Ordres de Marchés
2.	Une optimisation en UX et complexité des fonctions déjà existantes


## Contribution
Pour contribuer a ce smart contract, nous avons besoin: 

1. D'un smart contract de test unitaire et de faire le debug 
2. De l'ajout des fonctionnalités et test U associés qui sont dans la liste "à venir" 
3. D'enrichissement de la documentation fonctionnelle et technique

