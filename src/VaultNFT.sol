// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

interface IERC20Metadata {
    function symbol() external view returns (string memory);
}

contract VaultNFT is ERC721 {
    using Strings for uint256;

    uint256 public tokenId;

    constructor() ERC721("VaultNFT", "VNFT") {}

    struct VaultInfo {
        address token;
        uint256 deposits;
        address vault;
    }

    mapping(uint256 => VaultInfo) public vaultInfo;

    function mint(
        address to,
        address token,
        uint256 deposits,
        address vault
    ) external returns (uint256) {
        tokenId++;

        vaultInfo[tokenId] = VaultInfo(token, deposits, vault);

        _safeMint(to, tokenId);

        return tokenId;
    }

    function generateSvg(
        uint256 _tokenId,
        string memory tokenSymbol,
        uint256 depositAmount,
        address vaultAddress
    ) public pure returns (string memory) {
        return string(
            abi.encodePacked(
                "<svg xmlns='http://www.w3.org/2000/svg' width='500' height='500'>",
                "<rect width='100%' height='100%' fill='#0f172a'/>",
                "<rect x='40' y='40' width='420' height='420' rx='16' fill='#111827' stroke='#334155' stroke-width='2'/>",
                "<text x='250' y='90' fill='white' font-size='26' text-anchor='middle' font-family='monospace'>VAULT RECEIPT</text>",
                "<line x1='80' y1='110' x2='420' y2='110' stroke='#475569' stroke-width='1'/>",

                "<text x='80' y='160' fill='#94a3b8' font-size='14'>Vault ID:</text>",
                "<text x='250' y='160' fill='white' font-size='14' text-anchor='middle'>",
                _tokenId.toString(),
                "</text>",

                "<text x='80' y='210' fill='#94a3b8' font-size='14'>Token:</text>",
                "<text x='250' y='210' fill='white' font-size='14' text-anchor='middle'>",
                tokenSymbol,
                "</text>",

                "<text x='80' y='260' fill='#94a3b8' font-size='14'>Deposits:</text>",
                "<text x='250' y='260' fill='white' font-size='14' text-anchor='middle'>",
                depositAmount.toString(),
                "</text>",

                "<text x='80' y='310' fill='#94a3b8' font-size='14'>Vault:</text>",
                "<text x='250' y='310' fill='white' font-size='12' text-anchor='middle'>",
                Strings.toHexString(uint160(vaultAddress), 20),
                "</text>",

                "<line x1='80' y1='350' x2='420' y2='350' stroke='#475569' stroke-width='1'/>",
                "<text x='250' y='390' fill='#64748b' font-size='12' text-anchor='middle'>Vault Protocol</text>",
                "</svg>"
            )
        );
    }

    function tokenURI(uint256 _tokenId) public view override returns (string memory) {

        _requireOwned(_tokenId);

        VaultInfo memory info = vaultInfo[_tokenId];

        string memory tokenSymbol = IERC20Metadata(info.token).symbol();

        string memory svg = generateSvg(
            _tokenId,
            tokenSymbol,
            info.deposits,
            info.vault
        );

        string memory image = string(
            abi.encodePacked(
                "data:image/svg+xml;base64,",
                Base64.encode(bytes(svg))
            )
        );

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name":"Vault Receipt #',
                        _tokenId.toString(),
                        '",',
                        '"description":"On-chain vault deposit receipt",',
                        '"image":"',
                        image,
                        '"}'
                    )
                )
            )
        );

        return string(
            abi.encodePacked("data:application/json;base64,", json)
        );
    }
}