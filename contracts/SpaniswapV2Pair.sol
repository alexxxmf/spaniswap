// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Import this file to use console.log
import "hardhat/console.sol";
import "contracts/ERC20.sol";
import "contracts/Math.sol";

error InsufficientLiquidityMinted();
error InsufficientLiquidityBurned();
error TransferFailed();

contract SpaniswapV2Pair is ERC20, SafeMath{
  // placeholder, yet to be decided
  uint256 public MINIMUM_LIQUIDITY = 1000;
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
    uint256 balance0 = ERC20(token0).balanceOf(address(this));
    uint256 balance1 = ERC20(token1).balanceOf(address(this));

    (uint256 _reserve0, uint256 _reserve1) = getReserves();
    // How much was received in the last liquidity addition by user
    uint256 amount0 = balance0 - _reserve0;
    uint256 amount1 = balance1 - _reserve1;

    uint256 liquidity;

    if (totalSupply == 0) {
      liquidity = Math.sqrt(amount0 * amount1) - MINIMUM_LIQUIDITY;
      // This is a way to keep forever the minimal liquidity in 
      // an unretrievable position so we garantee am0 * am1 will never
      // have a 0 on either side destroying K result. is a way to permanently lock that minimum
      // 0 address https://stackoverflow.com/questions/50580769/what-is-0x0-address-in-solidity-ethereum
      _mint(address(0), MINIMUM_LIQUIDITY);
    } else {
      liquidity = Math.min(
        (amount0 * totalSupply) / _reserve0,
        (amount1 * totalSupply) / _reserve1
      );
    }

    // regarding revert vs require
    // https://medium.com/blockchannel/the-use-of-revert-assert-and-require-in-solidity-and-the-new-revert-opcode-in-the-evm-1a3a7990e06e
    if (liquidity <= 0) revert InsufficientLiquidityMinted();

    _mint()

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

  function _updateReserves(uint256 _reserve0, uint256 _reserve1) private{
    reserve0 = _reserve0;
    reserve1 = _reserve1;
  }

}
