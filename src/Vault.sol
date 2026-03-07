// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// ERC20 toekn interface to use the trasnferFrom function to transfer tokens from the user to the vault
interface IERC20 {
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

// The VAULT CONTRACT - should store
// token address,
// total supply of tokens in the vault,
// and a mapping of user balances

contract Vault {
    address public token;
    uint256 public totalSupply;
    mapping(address => uint256) public balances;

    constructor(address _token) {
        token = _token;
    }

    // deposit function to allow users to deposit tokens into the vault, it should update the total supply and the user's balance
    function deposit(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");
        IERC20(token).transferFrom(msg.sender, address(this), amount);
        balances[msg.sender] += amount;
        totalSupply += amount;
    }
}
