// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Token is ERC20, ERC20Burnable, Ownable {
    mapping(address => bool) public whitelistedWallets;

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _totalSupply
    ) ERC20(_name, _symbol) {
        _mint(msg.sender, _totalSupply);
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function addToWhitelist(address wallet) external onlyOwner {
        whitelistedWallets[wallet] = true;
    }

    function removeFromWhitelist(address wallet) external onlyOwner {
        whitelistedWallets[wallet] = false;
    }

    function isWhitelisted(address wallet) external view returns (bool) {
        return whitelistedWallets[wallet];
    }

    function transfer(
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        if (!whitelistedWallets[msg.sender]) {
            require(
                amount <= (totalSupply() * 5) / 1000,
                "Transfer amount must be less than 0.5% of total supply"
            );
        }
        return super.transfer(recipient, amount);
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        if (!whitelistedWallets[sender]) {
            require(
                amount <= (totalSupply() * 5) / 1000,
                "Transfer amount must be less than 0.5% of total supply"
            );
        }
        return super.transferFrom(sender, recipient, amount);
    }
}
