import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("marketplaceModule", (m) => {
  const Marketplace = m.contract("Marketplace");

  return { Marketplace };
});


