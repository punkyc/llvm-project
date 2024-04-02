//===-- RISCVInstrInfoXINCHI.td ----------------------------*- tablegen -*-===//
//
// This file describes the demo extensions defined by @INCHI.
//
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// Instruction class templates
//===----------------------------------------------------------------------===//

class CustomInstVdemoVV<bits<6> funct6, RISCVVFormat opv, dag outs, dag ins,
                   string opcodestr, string argstr>
    : RVInstVV<funct6, opv, outs, ins, opcodestr, argstr> {
  //let Inst{26} = 0;
  let Inst{6-0} = OPC_CUSTOM_0.Value;
  let DecoderNamespace = "XINCHIVdemo";
}


// op vd, vs1, vs2,
let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in {
class CustomInstVdemoVMADD32<bits<6> funct6, RISCVVFormat opv, string opcodestr>
    : CustomInstVdemoVV<funct6, opv, (outs VR:$vd), (ins VR:$rd, VR:$vs1, VR:$vs2),
                      opcodestr, "$vd, $vs1, $vs2"> {
  let vm = 1;
  let Constraints = "$vd = $rd";
}
}

let Predicates = [HasVendorXINCHIVdemo] in {
def INCHIVdemoVmadd32      : CustomInstVdemoVMADD32<0b000001, OPFVV, "inchi.vmadd32">;
}

//===----------------------------------------------------------------------===//
// Define Pseudo Instruction
//===----------------------------------------------------------------------===/

class VPseudoVVINCHINoMask<VReg RetClass,
                            VReg Op1Class,
                            VReg Op2Class,
                            string Constraint = "",
                            int TargetConstraintType = 1> :
      Pseudo<(outs RetClass:$rd),
             (ins RetClass:$rs3, Op1Class:$rs1, Op2Class:$rs2, AVL:$vl, ixlenimm:$sew), []>,
      RISCVVPseudo {
  let mayLoad = 0;
  let mayStore = 0;
  let hasSideEffects = 0;
  let Constraints = Constraint;
  //let Constraints = = !interleave([Constraint, "$rd != $op1"], ",");
  let TargetOverlapConstraintType = TargetConstraintType;
  let HasVLOp = 1;
  let HasSEWOp = 1;
  //let HasVecPolicyOp = 1;
  let BaseInstr = !cast<Instruction>(PseudoToVInst<NAME>.VInst);
}


multiclass VPseudoVVINCHI<LMULInfo m>  {
  //defvar constraint = "@earlyclobber $rd";
  let VLMul = m.value in {
    def "_" # m.MX : VPseudoVVINCHINoMask<m.vrclass, m.vrclass, m.vrclass>;
  }
}

multiclass VPseudoVMADD32{
  // defvar MxList = [V_MF8, V_MF4, V_MF2, V_M1, V_M2, V_M4, V_M8];
  // Used to iterate over all possible LMULs.
  foreach m = MxList in {
    defm "" : VPseudoVVINCHI<m>;
  }
}

defm PseudoINCHIVdemoVmadd32      : VPseudoVMADD32;

//===----------------------------------------------------------------------===//
// Define the intrinsic patterns.
//===----------------------------------------------------------------------===//

class VPatBinaryNoMaskINCHI<string intrinsic,
                            string inst,
                            ValueType result_type,
                            ValueType op1_type,
                            ValueType op2_type,
                            int sew,
                            LMULInfo vlmul,
                            VReg result_reg_class,
                            RegisterClass op1_reg_class,
                            DAGOperand op2_kind> :
  Pat<(result_type (!cast<Intrinsic>(intrinsic)
                    (result_type result_reg_class:$rs3),
                    (op1_type op1_reg_class:$rs1),
                    (op2_type op2_kind:$rs2),
                    VLOpFrag)),
                   (!cast<Instruction>(inst#"_"#vlmul.MX)
                    (result_type result_reg_class:$rs3),
                    (op1_type op1_reg_class:$rs1),
                    (op2_type op2_kind:$rs2),
                    GPR:$vl, sew)>;

multiclass VPatTernaryINCHI<string intrinsic, string instruction,
                               list<VTypeInfo> vtilist> {
  foreach vti = vtilist in {
    def : VPatBinaryNoMaskINCHI<intrinsic, instruction,
                                 vti.Vector, vti.Vector, vti.Vector,
                                 vti.Log2SEW, vti.LMul, 
                                 vti.RegClass, vti.RegClass, vti.RegClass>;
  }
}

let Predicates = [HasVendorXINCHIVdemo] in {
defm : VPatTernaryINCHI<"int_riscv_inchi_vmadd32",  "PseudoINCHIVdemoVmadd32",
                              AllIntegerVectors>;
}

//===----------------------------------------------------------------------===//
// inchi.cp32 & inchi.madd32
//===----------------------------------------------------------------------===//

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
class INCHIInstBase_rr<bits<7> funct7, bits<3> funct3, string opcodestr,
             bit Commutable = 0>
    : RVInstR<funct7, funct3, OPC_CUSTOM_0, (outs GPR:$rd), (ins GPR:$rs1, GPR:$rs2),
              opcodestr, "$rd, $rs1, $rs2"> {
  let isCommutable = Commutable;
  let DecoderNamespace = "XINCHIVdemo";
}

class INCHIInstBase_rrr<bits<7> funct7, bits<3> funct3, string opcodestr>
    : RVInstR<funct7, funct3, OPC_CUSTOM_0,
              (outs GPR:$rd_wb), (ins GPR:$rd, GPR:$rs1, GPR:$rs2),
              opcodestr, "$rd, $rs1, $rs2"> {
  let DecoderNamespace = "XINCHIVdemo";
}

let Predicates = [HasVendorXINCHIVdemo] in {
  def INCHI_CP32  : INCHIInstBase_rr<0b0000011, 0b010, "inchi.cp32">;
}


let Predicates = [HasVendorXINCHIVdemo], hasSideEffects = 0, mayLoad = 0,
    mayStore = 0, Constraints = "$rd = $rd_wb" in {
      def INCHI_MADD32 : INCHIInstBase_rrr<0b0000011, 0b000, "inchi.madd32">;
}

//===----------------------------------------------------------------------===//
//
//class PatGprGpr<SDPatternOperator OpNode, RVInst Inst, ValueType vt1 = XLenVT,
//                ValueType vt2 = XLenVT>
//    : Pat<(vt1 (OpNode (vt1 GPR:$rs1), (vt2 GPR:$rs2))), (Inst GPR:$rs1, GPR:$rs2)>;
//===----------------------------------------------------------------------===//
let Predicates = [HasVendorXINCHIVdemo] in {
def : PatGprGpr<int_riscv_inchi_cp32, INCHI_CP32>;
}

class PatGprGprGpr<SDPatternOperator OpNode, RVInst Inst, ValueType vt1 = XLenVT,
                ValueType vt2 = XLenVT, ValueType vt3 = XLenVT>
    : Pat<(vt1 (OpNode (vt1 GPR:$rs1), (vt2 GPR:$rs2), (vt3 GPR:$rs3))), (Inst GPR:$rs1, GPR:$rs2, GPR:$rs3)>;

let Predicates = [HasVendorXINCHIVdemo] in {
def : PatGprGprGpr<int_riscv_inchi_madd32, INCHI_MADD32>;
}

//===----------------------------------------------------------------------===//
// inchi.vmadd32.cm & inchi.vmadd32.cm.ddr & inchi.vmadd32.cr
//===----------------------------------------------------------------------===//
let hasSideEffects = 0, mayLoad = 1, mayStore = 0 in
class INCHIInstBase_cm<bits<2> funct2, bits<3> funct3, string opcodestr>
    : RVInstR4<funct2, funct3, OPC_CUSTOM_0,
              (outs GPR:$rd), (ins GPR:$rs1, GPR:$rs2, GPR:$rs3),
              opcodestr, "$rd, $rs1, $rs2, $rs3"> {
  let DecoderNamespace = "XINCHIVdemo";
}

let Predicates = [HasVendorXINCHIVdemo] in {
  def INCHI_VMADD32_CR  : INCHIInstBase_cm<0b11, 0b111, "inchi.vmadd32.cr">;
  def INCHI_VMADD32_CM  : INCHIInstBase_cm<0b11, 0b101, "inchi.vmadd32.cm">;
  def INCHI_VMADD32_CM_DDR  : INCHIInstBase_cm<0b11, 0b110, "inchi.vmadd32.cm.ddr">;

  def INCHI_VMOV_CMX  : INCHIInstBase_rr<0b0000011, 0b011, "inchi.vmov.cmx">;
  def INCHI_VMOV_CMY  : INCHIInstBase_rr<0b0000011, 0b100, "inchi.vmov.cmy">;
  def INCHI_VMOV_CRX  : INCHIInstBase_rr<0b0000001, 0b111, "inchi.vmov.crx">;

}