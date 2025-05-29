const hre = require("hardhat");

async function main() {
  const RoyaltyFlow = await hre.ethers.getContractFactory("RoyaltyFlow");
  const royaltyFlow = await RoyaltyFlow.deploy();

  await royaltyFlow.deployed();
  console.log("RoyaltyFlow contract deployed to:", royaltyFlow.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
