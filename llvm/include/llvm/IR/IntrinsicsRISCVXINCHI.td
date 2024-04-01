//===- IntrinsicsRISCVXINCHI.td - INCHI intrinsics --------*- tablegen -*-===//
//
//===----------------------------------------------------------------------===//
//
// This file defines all of the INCHI custom intrinsics for RISC-V.
//
//===----------------------------------------------------------------------===//

let TargetPrefix = "riscv" in {
  // UnMasked Vector Multiply-Add operations, its first operand can not be undef.
  // Input: (vector_in, vector_in, vector_in, vl)
  class RISCVINCHICustomVdemo
      : DefaultAttrsIntrinsic< [llvm_anyvector_ty],
                   [LLVMMatchType<0>, llvm_anyvector_ty, llvm_anyvector_ty, 
                    llvm_anyint_ty],
                   [IntrNoMem] >, RISCVVIntrinsic {
    let VLOperand = 3;
  }


  def int_riscv_inchi_vmadd32    : RISCVINCHICustomVdemo;
}


let TargetPrefix = "riscv" in {

class INCHIScalarIntrinsicCP32
    : DefaultAttrsIntrinsic<[llvm_i64_ty],
                            [llvm_i64_ty, llvm_i64_ty],
                            [IntrNoMem, IntrSpeculatable]>;

def int_riscv_inchi_cp32   : INCHIScalarIntrinsicCP32,
                          ClangBuiltin<"__builtin_riscv_inchi_cp32">;
}

let TargetPrefix = "riscv" in {

class INCHIScalarIntrinsicMADD32
    : DefaultAttrsIntrinsic<[llvm_i64_ty],
                            [llvm_i64_ty, llvm_i64_ty, llvm_i64_ty],
                            [IntrNoMem, IntrSpeculatable]>;

def int_riscv_inchi_madd32   : INCHIScalarIntrinsicMADD32,
                          ClangBuiltin<"__builtin_riscv_inchi_madd32">;
}
