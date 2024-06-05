// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TransactionLedger {
    // Define a struct to represent a transaction
    struct Transaction {
        string companyInfo;
        string companyCategory;
        string item;
        uint64 quantity;
        string unitItem;
        string location;
    }

    // Array to store all transactions
    Transaction[] private transactions;

    // Mapping to store the total quantity of each transaction type
    mapping(string => uint) private transactionTypeTotals;

    // Event to emit when new transactions are added
    event TransactionsAdded(address indexed from, uint transactionCount);

    // Function to add multiple transactions in a batch
    function addTransactions(
       
        string[] memory _companyInfo,
        string[] memory _companyCategory,
        string[] memory _item,
        uint64[] memory _quantity,
        string[] memory _unitItem,
        string[] memory _location

    ) public {
        // Ensure that all input arrays have the same length
        require(_companyInfo.length == _companyCategory.length && 
                _item.length == _quantity.length && 
                _unitItem.length == _location.length, 
                "Input arrays must have the same length");

        // Loop through the input arrays and create new transactions
        for (uint i = 0; i < _companyInfo.length; i++) {
            transactions.push(Transaction({
                //from: msg.sender,
                companyInfo:_companyInfo[i],
                companyCategory:_companyCategory[i],
                item:_item[i],
                quantity:_quantity[i],
                unitItem:_unitItem[i],
                location:_location[i]
            }));

            // Update the total quantity of the transaction type
            transactionTypeTotals[_companyCategory[i]] += _quantity[i];
        }

        // Emit the event
        emit TransactionsAdded(msg.sender, _companyInfo.length);
    }

    // Function to get the total quantity of a specific transaction type
    function getTotalQuantityByType(string memory _transactionType) public view returns (uint) {
        return transactionTypeTotals[_transactionType];
    }

    // Function to get the details of a transaction by index
    function getTransaction(uint _index) public view returns (string memory companyInfo, string memory companyCategory, string memory item, uint64 quantity, string memory unitItem, string memory location) {
        // Ensure the index is within bounds
        require(_index < transactions.length, "Transaction index out of bounds");

        // Fetch the transaction
        Transaction memory transaction = transactions[_index];

        // Return the transaction details
        return (transaction.companyInfo, transaction.companyCategory, transaction.item, transaction.quantity, transaction.unitItem, transaction.location);
    }

    // Function to get the total number of transactions
    function getTransactionCount() public view returns (uint) {
        return transactions.length;
    }
}
