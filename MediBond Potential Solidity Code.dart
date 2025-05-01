// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MedicineRegistry {
    address public admin;

    constructor() {
        admin = msg.sender;
    }

    struct Medicine {
        string manufacturerName;
        string medicineName;
        string ingredients;
        string routeOfAdministration;
        string approvalStatus;
        string batchNumber;
        string expirationDate;
        string productionDate;
        string uniqueToken; // QR code or unique identifier
    }

    mapping(string => Medicine) private medicines; // maps uniqueToken to a Medicine record
    mapping(string => bool) private exists;

    event MedicineAdded(string uniqueToken, string medicineName);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action.");
        _;
    }

    function addMedicine(
        string memory _manufacturerName,
        string memory _medicineName,
        string memory _ingredients,
        string memory _routeOfAdministration,
        string memory _approvalStatus,
        string memory _batchNumber,
        string memory _expirationDate,
        string memory _productionDate,
        string memory _uniqueToken
    ) public onlyAdmin {
        require(!exists[_uniqueToken], "Medicine with this token already exists.");

        Medicine memory newMed = Medicine({
            manufacturerName: _manufacturerName,
            medicineName: _medicineName,
            ingredients: _ingredients,
            routeOfAdministration: _routeOfAdministration,
            approvalStatus: _approvalStatus,
            batchNumber: _batchNumber,
            expirationDate: _expirationDate,
            productionDate: _productionDate,
            uniqueToken: _uniqueToken
        });

        medicines[_uniqueToken] = newMed;
        exists[_uniqueToken] = true;

        emit MedicineAdded(_uniqueToken, _medicineName);
    }

    function getMedicine(string memory _uniqueToken) public view returns (
        string memory manufacturerName,
        string memory medicineName,
        string memory ingredients,
        string memory routeOfAdministration,
        string memory approvalStatus,
        string memory batchNumber,
        string memory expirationDate,
        string memory productionDate
    ) {
        require(exists[_uniqueToken], "Medicine not found.");

        Medicine memory m = medicines[_uniqueToken];
        return (
            m.manufacturerName,
            m.medicineName,
            m.ingredients,
            m.routeOfAdministration,
            m.approvalStatus,
            m.batchNumber,
            m.expirationDate,
            m.productionDate
        );
    }
}
