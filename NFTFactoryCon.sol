// SPDX-License-Identifier: MIT
pragma solidity 0.8.1;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract MyToken is ERC721URIStorage {
    mapping(address => bool) public isAdmin;
    mapping(address => bool) public isMinter;
    

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
        isAdmin[msg.sender] = true;
        isMinter[msg.sender] = true;
    }
    
    function updateMetadata(uint256 tokenId, string memory _metadata) public {
        require(ownerOf(tokenId) == msg.sender || isAdmin[msg.sender], "You are not the owner or admin of this token");
        _setTokenURI(tokenId, _metadata);
    }
    
    function mint(address to, uint256 tokenId, string memory tokenURI) public {
        require(isMinter[msg.sender] || isAdmin[msg.sender], "You are not authorized to mint tokens");
        _mint(to, tokenId);
        _setTokenURI(tokenId, tokenURI);
    }
    
    modifier onlyAdmin() {
        require(isAdmin[msg.sender], "You are not an admin");
        _;
    }
    
    modifier onlyMinter() {
        require(isMinter[msg.sender] || isAdmin[msg.sender], "You are not authorized to mint tokens");
        _;
    }
    
    function addAdmin(address _admin) public onlyAdmin {
        isAdmin[_admin] = true;
    }
    
    function removeAdmin(address _admin) public onlyAdmin {
        isAdmin[_admin] = false;
    }
    
    function addMinter(address _minter) public onlyAdmin {
        isMinter[_minter] = true;
    }
    
    function removeMinter(address _minter) public onlyAdmin {
        isMinter[_minter] = false;
    }
}