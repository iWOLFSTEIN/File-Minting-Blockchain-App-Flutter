# file_minting_app

- To use this app you need to use your own Metamask wallet's private key, alchemy's rpc url (known as http url) and web socket url (select rinkeyby in alchemy and copy these urls)
-   
-   
- The contract is on rinkeby testnet and its address is
- 0x5C27924B70F2Ae1252a5524feb1C81e2AC607C60
- 
- 
- First create a file with name 'private_keys.dart' in lib/Constants/ folder and place contract address, private key, rpc url adn web socket url as shown:
- String contractAddress = "0x5C27924B70F2Ae1252a5524feb1C81e2AC607C60";
- final privateKey = "your private key here";
- var url = "alchemy rpc url";
- var socketUrl = "alchemy web socket url";
- 
- 
- Try to use same variable name of as shown above to avoid syntax errors
- 
- 
- Also check out the smart contract repo used in this app
- https://github.com/iWOLFSTEIN/File-Minting-Smart-Contract
- 
- 
- Give your feedback and suggestion to improve this app


