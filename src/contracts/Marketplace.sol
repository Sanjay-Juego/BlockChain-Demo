pragma solidity ^0.5.0;

contract Marketplace {
    string public name;
    uint256 public productCount = 0;
    mapping(uint256 => Product) public products;

    struct Product {
        uint256 id;
        string name;
        uint256 price;
        address payable owner;
        bool purchased;
    }
    event ProductCreated(
        uint256 id,
        string name,
        uint256 price,
        address payable owner,
        bool purchased
    );

    event ProductPruchased(
        uint256 id,
        string name,
        uint256 price,
        address payable owner,
        bool purchased
    );

    constructor() public {
        name = " MY Name Marketplace";
    }

    function createProduct(string memory _name, uint256 _price) public {
        //Require name
        require(bytes(_name).length > 0);

        //Require a valid price
        require(_price > 0);
        // Make sure parameter are correct
        //Create product
        //Inc product count
        productCount++;
        products[productCount] = Product(
            productCount,
            _name,
            _price,
            msg.sender,
            false
        );
        //Trigger an event
        emit ProductCreated(productCount, _name, _price, msg.sender, false);
    }

    function purchaseProduct(uint256 _id) public payable {
        //Require a product to be selected
        //Fetch the product
        Product memory _product = products[_id];
        // fetch the owner
        address payable _seller = _product.owner;
        // make sure the product is valid
        require(_product.id > 0 && _product.id <= productCount);

        // Check enough funds
        require(msg.value >= _product.price); 

        // Check if the product is already purchased
        require(!_product.purchased);

        // Check if the seller is the same as the buyer
        require(msg.sender != _seller);
        // purchase it (Tranfer ownership)
        _product.owner = msg.sender;
        //Mark as purchased
        _product.purchased = true;
        //update the product
        products[_id] = _product;
        //Pay seller by sending ether
        address(_seller).transfer(msg.value);
        //Trigger the event
         emit ProductPruchased(productCount, _product.name, _product.price, msg.sender, true);


    }
}
