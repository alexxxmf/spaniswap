import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";

import { ERC20Mintable, SpaniswapV2Pair } from "../typechain-types";

const ZERO_ADDRESS = "0x0000000000000000000000000000000000000000";

describe("SpaniswapV2Pair", function () {
  let owner: SignerWithAddress;
  let address1: SignerWithAddress;
  let token1: ERC20Mintable;
  let token2: ERC20Mintable;
  let tokenLp: SpaniswapV2Pair;

  before(async () => {
    [owner, address1] = await ethers.getSigners();

    const Token = await ethers.getContractFactory("ERC20Mintable");

    token1 = await Token.deploy("Token#1", "TK1");
    token2 = await Token.deploy("Token#2", "TK2");

    await token1.mint(3 * 10 ** 6, owner.address);
    await token2.mint(1 * 10 ** 6, owner.address);

    const SpaniswapV2Pair = await ethers.getContractFactory("SpaniswapV2Pair");

    tokenLp = await SpaniswapV2Pair.deploy(token1.address, token2.address);
  });
  describe("Mint", function () {
    it("should mint LP tokens", async () => {
      // Arrange
      await token1.mint(9 * 10 ** 6, tokenLp.address);
      await token2.mint(5 * 10 ** 6, tokenLp.address);
      const minLiquidityBN = await tokenLp.MINIMUM_LIQUIDITY();
      const minLiquidity = minLiquidityBN.toNumber();

      // Act
      await tokenLp.mint();

      // Asert
      expect(await tokenLp.balanceOf(owner.address)).to.equal(6707203);
      expect(await tokenLp.balanceOf(ZERO_ADDRESS)).to.equal(minLiquidity);
    });
  });
});
