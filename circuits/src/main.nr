use dep::std;
use dep::ecrecover;
mod merkle_tree;

global LEVELS: Field = 2;

fn main(
  pub_key: [u8; 64],
  signature: [u8; 64],
  hashed_message: pub [u8; 32],
  nullifier: pub [u8; 32],
  pathIndices: [Field; LEVELS],
  siblings: [Field; LEVELS],
  root: pub Field
) {
  let key = ecrecover::secp256k1::PubKey::from_unified(pub_key);
  let address = key.ecrecover(signature, hashed_message);
  
  let signature_hash = std::hash::blake2s(signature);
  assert(nullifier == signature_hash);

  let leaf = std::hash::poseidon::bn254::hash_1([address]);
  let calculate_root = merkle_tree::calculate_root(leaf, pathIndices, siblings);
  assert(calculate_root == root);
  // std::println(f"calculate_root: {calculate_root}");
}

#[test]
fn test_main(){
  let pub_key = [131,  24,  83,  91,  84,  16,  93,  74,  122,  174,  96,  192,  143,  196,  95,  150,  135,  24,  27,  79,  223,  198,  37,  189,  26,  117,  63,  167,  57,  127,  237,  117,  53,  71,  241,  28,  168,  105,  102,  70,  242,  243,  172,  176,  142,  49,  1,  106,  250,  194,  62,  99,  12,  93,  17,  245,  159,  97,  254,  245,  123,  13,  42,  165];
  let signature = [1,  83,  82,  167,  184,  77,  226,  104,  5,  27,  151,  91,  202,  127,  17,  183,  75,  31,  190,  253,  159,  116,  155,  13,  24,  178,  40,  165,  129,  90,  103,  204,  42,  164,  230,  62,  73,  181,  169,  61,  251,  221,  128,  221,  14,  19,  179,  25,  107,  132,  10,  188,  149,  0,  197,  52,  151,  239,  244,  103,  215,  224,  56,  242];
  let hashed_message = [3,  57, 199, 96, 145, 58, 183, 241, 206, 140, 36, 34, 165, 163, 17, 210, 97, 254, 154, 79, 91, 223, 149, 18, 3, 210, 111, 56, 246, 219, 19, 104];
  let nullifier = [142,  197,  227,  35,  35,  142,  255,  176,  38,  63,  247,  168,  33,  178,  55,  202,  46,  76,  167,  202,  130,  208,  59,  14,  151,  19,  144,  228,  58,  37,  10,  101];
  
  /*
                root
                /    \
              H12      H34
            /  \      /  \
           H1   H2   H3  H4
         H(add)  2   3    4
  */

  let pathIndices = [0, 0];
  let siblings = [0x131d73cf6b30079aca0dff6a561cd0ee50b540879abe379a25a06b24bde2bebd, 0x23144c1e7794f62515c2ccbaee3076d2e40b673fcba5da8a6457387e054068e0];
  let root = 0x6d842cb82ce254235eb91ecf11197364812be4b329f4efa69fad7962ce1044;

  main(pub_key, signature, hashed_message, nullifier, pathIndices, siblings, root);
}