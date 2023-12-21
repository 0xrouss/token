// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract McRib10x is ERC20, ERC20Burnable, Ownable {
    constructor() ERC20("McRib10x", "MR10X") Ownable(msg.sender) {
        _mint(msg.sender, 42069069420 * 10 ** decimals());
    }

    function transfer(
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        if (msg.sender != owner()) {
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
        if (msg.sender != owner()) {
            require(
                amount <= (totalSupply() * 5) / 1000,
                "Transfer amount must be less than 0.5% of total supply"
            );
        }
        return super.transferFrom(sender, recipient, amount);
    }

    function airdrop(
        address[] memory recipients,
        uint256[] memory amounts
    ) external onlyOwner {
        require(
            recipients.length == amounts.length,
            "Mismatched array lengths"
        );

        for (uint256 i = 0; i < recipients.length; i++) {
            transfer(recipients[i], amounts[i]);
        }
    }
}
