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
