use dep::std;
use dep::ecrecover;

global CANDIDATES: Field = 2;

fn main(
  pub_key: [u8; 64],
  signature: [u8; 64],
  hashed_message: pub [u8; 32],
  nullifier: pub [u8; 32],
) {
  let (pub_key_x, pub_key_y) = split_uncompressed_pub_key(pub_key);
  
  let address: Field = ecrecover::ecrecover(pub_key_x, pub_key_y, signature, hashed_message);
  
  let signature_hash = std::hash::blake2s(signature);
  assert(nullifier == signature_hash);
}

unconstrained
fn split_uncompressed_pub_key(
    pub_key: [u8; 64]
) -> ([u8; 32], [u8; 32]) {
    let mut pub_key_x: [u8; 32] = [0; 32];
    let mut pub_key_y: [u8; 32] = [0; 32];

    for i in 0..32 {
        pub_key_x[i] = pub_key[i];
        pub_key_y[i] = pub_key[i + 32];
    };

    (pub_key_x, pub_key_y)
}
