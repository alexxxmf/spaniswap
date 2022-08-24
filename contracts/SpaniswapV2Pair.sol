// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Import this file to use console.log
import "hardhat/console.sol";
import "contracts/ERC20.sol";

contract SpaniswapV2Pair is ERC20{
  // This is to store reserves for both sides of the pair
  uint256 private reserve0;
  uint256 private reserve1;

  // one contract per pair so we need to store both token's contract addresses on init
  address public token0;
  address public token1;

  constructor(address _token0, address _token1) 
    ERC20("Spaniswap LP token", "SPANV2", 18)
  {
    token0 = _token0;
    token1 = _token1;
  }

  function mint() public {
    
  }

  function getReserves()
    public
    view
    returns (
      uint256,
      uint256
    )
  {
    return (reserve0, reserve1);
  }

}
