// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Vault} from "./Vault.sol";
import {VaultNFT} from "./VaultNFT.sol";

// THE VAULT FACTORY CONTRACT - should
// be able to create new vaults
// keep track of all the vaults created

contract VaultFactory {
    VaultNFT public nft;
    mapping(address => address[]) public vaults;
    event VaultCreated(address token, address vault);

constructor() {
        nft = new VaultNFT();
    }


    function createVault(address token) external returns (address vault) {
        require(
            vaults[token].length == 0,
            "Vault already exists for this token"
        );
        bytes32 salt = keccak256(abi.encode(token));

        vault = address(new Vault{salt: salt}(token));
        vaults[token].push(vault);
        nft.mint(msg.sender);
        emit VaultCreated(token, vault);
    }
}
