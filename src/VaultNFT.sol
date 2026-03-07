// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract VaultNFT is ERC721 {
    uint256 public tokenId;

    constructor() ERC721("VaultNFT", "VNFT") {}

    function mint(address to) external returns (uint256) {
        tokenId++;
        _mint(to, tokenId);
        return tokenId;
    }

    function generateSVG(
        address token,
        uint256 deposits
    ) public pure returns (string memory) {
        return
            string(
                abi.encodePacked(
                    "<svg xmlns='http://www.w3.org/2000/svg' width='500' height='500'>",
                    "<rect width='100%' height='100%' fill='black'/>",
                    "<text x='50%' y='40%' fill='white' text-anchor='middle'>",
                    "Vault NFT",
                    "</text>",
                    "</svg>"
                )
            );
    }
}
