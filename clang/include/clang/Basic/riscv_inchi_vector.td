//==--- riscv_inchi_vector.td  ---------===//

//===----------------------------------------------------------------------===//
// Instruction definitions
//===----------------------------------------------------------------------===//


multiclass RVVINCHIBuiltinSet<list<list<string>> suffixes_prototypes> {
  let OverloadedName = NAME,
      Name = NAME,
      HasMasked = false,
      Log2LMUL = [-3,-2, -1, 0, 1, 2, 3] in
    defm NAME : RVVOutOp1Op2BuiltinSet<NAME, "csil", suffixes_prototypes>;
}

let RequiredFeatures = ["Xinchivdemo"] in {
    defm inchi_vmadd32    : RVVINCHIBuiltinSet<[["vv", "v", "vvvv"]]>;
}

