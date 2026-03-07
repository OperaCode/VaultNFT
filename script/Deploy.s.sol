// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// 
import {VaultNFT} from "../src/VaultNFT.sol";
import {Vault} from "../src/Vault.sol";



contract VaultFactory {

    mapping(address => address) public vaults;

    VaultNFT public nft;

    event VaultCreated(address token, address vault);

    constructor(address _nft) {
        nft = VaultNFT(_nft);
    }

    function createVault(address token) external returns(address vault) {

        require(vaults[token] == address(0), "Vault exists");

        bytes32 salt = keccak256(abi.encode(token));

        vault = address(new Vault{salt: salt}(token));

        vaults[token] = vault;

        nft.mint(msg.sender);

        emit VaultCreated(token, vault);
    }
}