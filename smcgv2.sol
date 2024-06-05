// SPDX-License-Identifier: MIT
//yg lama x support array
pragma solidity ^0.8.0;

contract ApplicationLedger {
    //struct untuk application dari ETL
    struct Application {
        string companyInfo;
        string companyCategory;
        string item;
        uint64 quantity;
        string unitItem;
        string location;
    }

    // simpan application dalam array
    Application[] private applications;

    // store quantity
    mapping(string => uint) private applicationTypeTotals;

    // Event to emit when new applications are added
    event ApplicationsAdded(address indexed from, uint applicationCount);

    // Function to add multiple applications in a batch
    function addApplications(
       
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

        // Loop through the input arrays and create new applications
        for (uint i = 0; i < _companyInfo.length; i++) {
            applications.push(Application({
                //from: msg.sender,
                companyInfo:_companyInfo[i],
                companyCategory:_companyCategory[i],
                item:_item[i],
                quantity:_quantity[i],
                unitItem:_unitItem[i],
                location:_location[i]
            }));

            // Update the total quantity of the application type
            applicationTypeTotals[_companyCategory[i]] += _quantity[i];
        }

        // Emit the event
        emit ApplicationsAdded(msg.sender, _companyInfo.length);
    }

    // Function to get the total quantity of a specific application type
    function getTotalQuantityByType(string memory _applicationType) public view returns (uint) {
        return applicationTypeTotals[_applicationType];
    }

    // Function to get the details of a application by index
    function getApplication(uint _index) public view returns (string memory companyInfo, string memory companyCategory, string memory item, uint64 quantity, string memory unitItem, string memory location) {
        // Ensure the index is within bounds
        require(_index < applications.length, "Application index out of bounds");

        // Fetch the application
        Application memory application = applications[_index];

        // Return the application details
        return (application.companyInfo, application.companyCategory, application.item, application.quantity, application.unitItem, application.location);
    }

    // Function to get the total number of applications
    function getApplicationCount() public view returns (uint) {
        return applications.length;
    }
}
