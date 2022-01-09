require("@nomiclabs/hardhat-waffle")
require('dotenv').config()

const alchemyApiUrl = process.env.ALCHEMY_API_URL
const rinkebyAccountKey = process.env.RINKEBY_ACCOUNT_KEY

module.exports = {
  solidity: "0.8.4",
  networks: {
    rinkeby: {
      url: alchemyApiUrl,
      accounts: [rinkebyAccountKey],
    }
  }
};
