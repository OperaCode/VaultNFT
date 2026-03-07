// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Vault} from "./Vault.sol";

// THE VAULT FACTORY CONTRACT - should
// be able to create new vaults
// keep track of all the vaults created

contract VaultFactory {
    mapping(address => address[]) public vaults;
    event VaultCreated(address token, address vault);

    function createVault(address token) external returns (address vault) {
        require(
            vaults[token].length == 0,
            "Vault already exists for this token"
        );
        bytes32 salt = keccak256(abi.encode(token));

        vault = address(new Vault{salt: salt}(token));
        vaults[token].push(vault);
        emit VaultCreated(token, vault);
    }
}
