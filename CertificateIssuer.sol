// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract CertificateIssuer {
    address public owner;

    struct Certificate {
        string name;
        string course;
        uint date;
    }

    mapping(address => Certificate) public certificates;

    event CertificateIssued(address indexed student, string course);
    event CertificateRevoked(address indexed student);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    function issueCertificate(address student, string memory name, string memory course) public onlyOwner {
        certificates[student] = Certificate({
            name: name,
            course: course,
            date: block.timestamp
        });
        emit CertificateIssued(student, course);
    }

    function getCertificate(address student) public view returns (string memory, string memory, uint) {
        Certificate memory cert = certificates[student];
        return (cert.name, cert.course, cert.date);
        }

    function revokeCertificate(address student) public onlyOwner {
        delete certificates[student];
        emit CertificateRevoked(student);
    }
}
