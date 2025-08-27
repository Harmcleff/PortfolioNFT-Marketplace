import * as dotenv from "dotenv";
import "@nomicfoundation/hardhat-verify";
dotenv.config();

import type { HardhatUserConfig } from "hardhat/config";

import hardhatToolboxMochaEthersPlugin from "@nomicfoundation/hardhat-toolbox-mocha-ethers";
import { configVariable } from "hardhat/config";

const config: HardhatUserConfig = {
  plugins: [hardhatToolboxMochaEthersPlugin],
  solidity: {
    profiles: {
      default: {
        version: "0.8.28",
      },
      production: {
        version: "0.8.28",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
    },
  },
  networks: {
    hardhatMainnet: {
      type: "edr-simulated",
      chainType: "l1",
    },
    hardhatOp: {
      type: "edr-simulated",
      chainType: "op",
    },
    sepolia: {
      type: "http",
      chainType: "l1",
      url: process.env.SEPOLIA_URL || "https://sepolia.infura.io/v3/49324959605747cebb85d21c4408e2d3",
      accounts: [process.env.SEPOLIA_PRIVATE_KEY || "7557346c0ae5b0da4a5fcb4977eaea565e5609f2437dd3ccd614f23697967e2a"],
    },
  },
 verify: {
    etherscan: {
      // Your API key for Etherscan
      // Obtain one at https://etherscan.io/
      apiKey: process.env.ETHERSCAN_API_KEY || "SJCMEZBUQEK5FE44TUQJDYG4FZHDGSF264",
    },
  },
};

export default config;
