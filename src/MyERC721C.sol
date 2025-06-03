// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/interfaces/IERC2981.sol";

/**
 * @title MyERC721C
 * @dev Simple ERC721 with royalties for ApeChain
 * We'll add Creator Token features manually to avoid version conflicts
 */
contract MyERC721C is ERC721, Ownable, IERC2981 {
    
    uint256 private _nextTokenId = 1;
    
    // Collection parameters
    uint256 public maxSupply;
    uint256 public mintPrice;
    bool public mintingEnabled;
    string private _baseTokenURI;
    
    // Royalty info
    address public royaltyRecipient;
    uint96 public royaltyPercentage; // Basis points (100 = 1%)
    
    // Mapping from token ID to token URI
    mapping(uint256 => string) private _tokenURIs;
    
    constructor(
        string memory name,
        string memory symbol,
        uint256 _maxSupply,
        uint256 _mintPrice,
        address _royaltyRecipient,
        uint96 _royaltyPercentage
    ) ERC721(name, symbol) Ownable(msg.sender) {
        maxSupply = _maxSupply;
        mintPrice = _mintPrice;
        royaltyRecipient = _royaltyRecipient;
        royaltyPercentage = _royaltyPercentage;
        mintingEnabled = false;
    }
    
    /**
     * @dev Public mint function
     */
    function mint(address to, string memory uri) external payable {
        require(mintingEnabled, "Minting is not enabled");
        require(msg.value >= mintPrice, "Insufficient payment");
        require(_nextTokenId <= maxSupply, "Max supply reached");
        
        uint256 tokenId = _nextTokenId;
        _nextTokenId++;
        
        _safeMint(to, tokenId);
        if (bytes(uri).length > 0) {
            _tokenURIs[tokenId] = uri;
        }
    }
    
    /**
     * @dev Owner mint function for airdrops/reserves
     */
    function ownerMint(address to, string memory uri) external onlyOwner {
        require(_nextTokenId <= maxSupply, "Max supply reached");
        
        uint256 tokenId = _nextTokenId;
        _nextTokenId++;
        
        _safeMint(to, tokenId);
        if (bytes(uri).length > 0) {
            _tokenURIs[tokenId] = uri;
        }
    }
    
    /**
     * @dev Batch mint function
     */
    function batchMint(address[] memory recipients, string[] memory uris) external onlyOwner {
        require(recipients.length == uris.length, "Arrays length mismatch");
        require(_nextTokenId + recipients.length - 1 <= maxSupply, "Would exceed max supply");
        
        for (uint256 i = 0; i < recipients.length; i++) {
            uint256 tokenId = _nextTokenId;
            _nextTokenId++;
            
            _safeMint(recipients[i], tokenId);
            if (bytes(uris[i]).length > 0) {
                _tokenURIs[tokenId] = uris[i];
            }
        }
    }
    
    /**
     * @dev Set base URI for metadata
     */
    function setBaseURI(string memory baseURI) external onlyOwner {
        _baseTokenURI = baseURI;
    }
    
    /**
     * @dev Toggle minting state
     */
    function toggleMinting() external onlyOwner {
        mintingEnabled = !mintingEnabled;
    }
    
    /**
     * @dev Update mint price
     */
    function setMintPrice(uint256 _mintPrice) external onlyOwner {
        mintPrice = _mintPrice;
    }
    
    /**
     * @dev Update royalty info
     */
    function setRoyaltyInfo(address _recipient, uint96 _percentage) external onlyOwner {
        require(_percentage <= 1000, "Royalty too high"); // Max 10%
        royaltyRecipient = _recipient;
        royaltyPercentage = _percentage;
    }
    
    /**
     * @dev Withdraw contract balance
     */
    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");
        
        (bool success, ) = payable(owner()).call{value: balance}("");
        require(success, "Withdrawal failed");
    }
    
    /**
     * @dev Get total number of tokens minted
     */
    function totalSupply() external view returns (uint256) {
        return _nextTokenId - 1;
    }
    
    /**
     * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
     */
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_ownerOf(tokenId) != address(0), "URI query for nonexistent token");

        string memory _tokenURI = _tokenURIs[tokenId];
        string memory base = _baseURI();

        // If there is no base URI, return the token URI.
        if (bytes(base).length == 0) {
            return _tokenURI;
        }
        // If both are set, concatenate the baseURI and tokenURI
        if (bytes(_tokenURI).length > 0) {
            return string(abi.encodePacked(base, _tokenURI));
        }

        return super.tokenURI(tokenId);
    }
    
    /**
     * @dev Internal function to set the base URI for all token IDs
     */
    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }
    
    /**
     * @dev EIP-2981 royalty standard implementation
     */
    function royaltyInfo(uint256 tokenId, uint256 salePrice) external view override returns (address, uint256) {
        require(_ownerOf(tokenId) != address(0), "Token does not exist");
        uint256 royaltyAmount = (salePrice * royaltyPercentage) / 10000;
        return (royaltyRecipient, royaltyAmount);
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, IERC165) returns (bool) {
        return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
    }
}