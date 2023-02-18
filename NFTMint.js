const Web3 = require('web3');
const contractAbi = require('./MyToken.json');
const contractAddress = '0xe17ae7bd9a7f3ad8974a368db52fd1e760e42da0'; // contract address
const privateKey = ''; // Replace with the private key of the account you want to use to mint NFTs

const web3 = new Web3('https://goerli.infura.io/v3/127c1fd228a744b29be27c1b598f2cf8'); // INFURA rpc url 
const contract = new web3.eth.Contract(contractAbi, contractAddress);
const account = web3.eth.accounts.privateKeyToAccount(privateKey);

async function mintNFT(tokenId, tokenURI) {
  try {
    const nonce = await web3.eth.getTransactionCount(account.address);
    const gasPrice = await web3.eth.getGasPrice();
    const gasLimit = 500000;
    const tx = {
      to: contractAddress,
      from: account.address,
      nonce: nonce,
      gasPrice: gasPrice,
      gasLimit: gasLimit,
      data: contract.methods.mint(account.address, tokenId, tokenURI).encodeABI()
    };
    const signedTx = await account.signTransaction(tx);
    const txReceipt = await web3.eth.sendSignedTransaction(signedTx.rawTransaction);
    console.log(`NFT minted with transaction hash: ${txReceipt.transactionHash}`);
  } catch (error) {
    console.error(error);
  }
}

mintNFT(1, 'tokenURI');
