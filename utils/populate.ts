import { NoirNode } from "./NoirNode";
import { convertToHex, writeToToml } from "./common";
import { fileURLToPath } from "url";
import { resolve, dirname } from "path";
import config from "../data/private_keys.json" assert { type: "json" };

import { ethers } from "ethers";
// @ts-ignore -- no types
import blake2 from "blake2";

export async function main() {
  const noir = new NoirNode();
  await noir.init();

  //   get private keys from config
  let walletPrivKeys = config.priv_keys;
  const getWallet = (privKey: string) => new ethers.Wallet(privKey);

  //  get wallets from private keys
  let wallets = walletPrivKeys.map(getWallet);
  let user = wallets[0];

  const pubKey = Array.from(
    ethers.utils.arrayify(user.publicKey).slice(1).values()
  );

  let message = "this is a message";

  // sign the message
  let signature = Array.from(
    ethers.utils
      .arrayify(await user.signMessage(message))
      .slice(0, 64)
      .values()
  );

  let hashedMessage = ethers.utils.hashMessage(message);
  let hashed_message = Array.from(
    ethers.utils.arrayify(hashedMessage).values()
  );

  const nullifierBuff = blake2
    .createHash("blake2s")
    .update(ethers.utils.arrayify(signature).slice(0, 64))
    .digest();

  let nullifier = Array.from(nullifierBuff).map((elem) => Number(elem));

  let data = {
    pub_key: pubKey,
    signature: signature,
    hashed_message: hashed_message,
    nullifier,
  };

  const dir = dirname(fileURLToPath(import.meta.url));
  let path = resolve(dir + "/../circuits/Prover.toml");

  writeToToml(data, path);
}

main();
