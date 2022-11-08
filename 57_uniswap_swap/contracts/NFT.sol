//SPDX-License-Identifier: MIT

pragma solidity >= 0.8.10;

interface IERC165 {
    function supportsInterface(bytes4 interfaceID) external view returns (bool);
}

interface IERC721 is IERC165 {

    function balanceOf(address owner) external view returns (uint balance);
    function ownerOf(uint tokenId) external view returns (address owner);
    function safeTransferFrom(address from, address to, uint tokenId) external;
    //why are there 2 "safeTransferFrom"
    function safeTransferFrom(address from, address to, uint tokenId, bytes calldata data) external;
    function transferFrom(address from, address to, uint tokenId) external;
    function approve(address to, uint tokenId) external;

    function getApproved(uint tokenId) external view returns (address operator);
    function setApprovalForAll(address operator, bool _approved) external;
    function isApprovedForAll(address owner, address operator) external view returns (bool);

}

interface IERC721Receiver {
    function onERC721Received(address operator, address from, uint tokenId, bytes calldata data) external returns (bytes4);
}

contract NFT is IERC721 {
    event Transfer(address indexed from, address indexed to, uint indexed id);
    event Approval(address indexed owner, address indexed spender, uint indexed id);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    //to see which nft belongs to whom
    mapping(uint => address) internal _ownerOf;

    //amount of nft that each address owns
    mapping(address => uint) internal _balanceOf;

    //the owner of the nft can approve another address to take control of nft
    //the address here is spender.
    mapping(uint => address) internal _approvals;

    //in case owner has many nfts, then he can approve another account to use them all.
    //first address is owner, second address is spender.
    mapping(address => mapping(address => bool)) public isApprovedForAll;

    function supportsInterface(bytes4 interfaceId) external pure returns (bool) {
        return
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC165).interfaceId;
    }

    //returns the number of nft owned by the "owner"
    function balanceOf(address owner) external view returns(uint balance) {
        require(owner != address(0), "zero address");
        return _balanceOf[owner]
    }

    function ownerOf(uint tokenId) external view returns(address owner) {
        owner = _ownerOf(tokenId);
        require(owner != address(0), "zero address");
    }

    //setting the permission for the platform(operator) to take control of all our nfts
    //or revoking that permission. This permisson is stored in the mapping: isApprovedForAll
    function setApprovalForAll(address _operator, bool _approved) external {
        isApprovedForAll[msg.sender][_operator] = _approved;
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    //give permission to the to address to take control of the tokenId nft
    //the caller must be either owner or a approved person
    function approve(address to, uint _tokenId) external {
        address owner = _ownerOf[_tokenId];
        require(msg.sender == owner || isApprovedForAll[owner][msg.sender] == true, "not authorized");
        //now we can set "to" address as authorized to spend tokenId
        _approvals[_tokenId] = to;
        emit Approval(owner, to, _tokenId);
    }

    //will return the address of the approved for each tokenId
    function getApproved(uint _tokenId) external view returns(address operator) {
        require(_ownerOf[_tokenId] != address(0), "owner should exist");
        return _approvals[_tokenId];
    }

    function _isApprovedOrOwner(address owner, address spender, uint _tokenId) internal view returns(bool) {
        return (spender == owner || isApprovedForAll[owner][spender] == true || spender == _approvals[_tokenId]);
    }

    function transferFrom(address from, address to, uint tokenId) public {
        require(from  == _ownerOf[tokenId], "from != owner");
        require(to != address(0), "to = zero address");
        require(_isApprovedOrOwner(from, msg.sender, tokenId), "not authorized");
        _balanceOf[from] --;
        _balanceOf[to] ++;
        _ownerOf[tokenId] = to;

        delete _approvals[tokenId];
        emit Transfer(from, to, tokenId);
    }
    function safeTransferFrom(address from, address to, uint tokenId) external {
        //this function is same as above but if "to" is a contract, then it calls "onERC721Received":
        transferFrom(from, to, tokenId);
        require(
            to.code.length == 0 || 
            IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, "") == IERC721Receiver.onERC721Received.selector, "unsafe recipient")
        )

    }

    function onERC721Received(address operator, address from, uint tokenId, bytes calldata data) external returns(bytes4) {

    }

    function safeTransferFrom(address from, address to, uint tokenId, bytes calldata data) external {
        //this function is same as above but if "to" is a contract, then it calls "onERC721Received":

    }
}