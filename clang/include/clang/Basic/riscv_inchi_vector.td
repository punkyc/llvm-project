//==--- riscv_inchi_vector.td  ---------===//

//===----------------------------------------------------------------------===//
// Instruction definitions
//===----------------------------------------------------------------------===//


multiclass RVVINCHIBuiltinSet<list<list<string>> suffixes_prototypes> {
  let OverloadedName = NAME,
      Name = NAME,
      HasMasked = false,
      Log2LMUL = [-1, 0, 1, 2] in
    defm NAME : RVVOutOp1Op2BuiltinSet<NAME, "i", suffixes_prototypes>;
}

let RequiredFeatures = ["Xinchivdemo"] in {
    defm inchivdemo_vcci    : RVVINCHIBuiltinSet<[["", "v", "vv(FixedSEW:8)Uv(FixedSEW:8)Uv"]]>;
}

