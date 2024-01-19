//===- IntrinsicsRISCVXINCHI.td - INCHI intrinsics --------*- tablegen -*-===//
//
//===----------------------------------------------------------------------===//
//
// This file defines all of the INCHI custom intrinsics for RISC-V.
//
//===----------------------------------------------------------------------===//

let TargetPrefix = "riscv" in {

  class RISCVINCHICustomVCCI
      : DefaultAttrsIntrinsic< [llvm_anyvector_ty],
                   [LLVMMatchType<0>, llvm_anyvector_ty, llvm_anyvector_ty,
                    llvm_anyint_ty, 
                    // LLVMMatchType<3>
                    ],
                   [IntrNoMem] >, RISCVVIntrinsic {
    let VLOperand = 3;
  }


  def int_riscv_inchivdemo_vcci    : RISCVINCHICustomVCCI;
}
