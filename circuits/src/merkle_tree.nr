use dep::std;
global LEVELS: Field = 2;

fn calculate_root(
    leaf: Field,
    pathIndices: [Field; LEVELS],
    siblings: [Field; LEVELS],
) -> Field {
    let n = LEVELS;
    let mut current = leaf;
    for i in 0..n {
      let pathIndex = pathIndices[i];
      let (hash_left, hash_right) = if (pathIndex == 1) {
          (siblings[i], current)
        } else {
          (current, siblings[i])
        };

    current = std::hash::poseidon::bn254::hash_2([hash_left, hash_right]);
    }
    current
}