import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("NFTModule", (m) => {
  const NFT = m.contract("PortfolioNFT");



  return { NFT };
});


