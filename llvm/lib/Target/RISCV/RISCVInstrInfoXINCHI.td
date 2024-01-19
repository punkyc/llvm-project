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
  let Inst{26} = 0;
  let Inst{6-0} = OPC_CUSTOM_2.Value;
  let DecoderNamespace = "XINCHIVdemo";
}


// op vd, vs1, vs2,
let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in {
class CustomInstVdemoVCCI<bits<6> funct6, RISCVVFormat opv, string opcodestr>
    : CustomInstVdemoVV<funct6, opv, (outs VR:$vd), (ins VR:$rd, VR:$vs1, VR:$vs2),
                      opcodestr, "$vd, $vs1, $vs2"> {
  let vm = 1;
}
}

let Predicates = [HasVendorXINCHIVdemo] in {
def INCHIVdemoVcci      : CustomInstVdemoVCCI<0b000100, OPIVV, "inchi.vdemo">;
}


// Associate LMUL with tablegen records of register classes.
def InchiVdemoV_M1  : LMULInfo<0b000,  8,   VR, VR,   VR,   VR,   VR, "M1">;
def InchiVdemoV_M2  : LMULInfo<0b001, 16, VRM2, VRM2, VR,   VR,   VR, "M2">;
def InchiVdemoV_M4  : LMULInfo<0b010, 32, VRM4, VRM4, VRM2, VR,   VR, "M4">;
def InchiVdemoV_M8  : LMULInfo<0b011, 64, VRM8, VRM8, VRM4, VRM2, VR, "M8">;

defvar MXListInchi = [V_MF2, InchiVdemoV_M1, InchiVdemoV_M2, InchiVdemoV_M4, InchiVdemoV_M8];

defset list<VTypeInfoToWide> AllQuadWidenableInt8NoVLMulVectorsINCHI = {
  def : VTypeInfoToWide<VI8MF2,  VI32MF2>;
  def : VTypeInfoToWide<VI8M1,   VI32M1>;
  def : VTypeInfoToWide<VI8M2,   VI32M2>;
  def : VTypeInfoToWide<VI8M4,   VI32M4>;
  def : VTypeInfoToWide<VI8M8,   VI32M8>;
}

class VPseudoVVINCHI<VReg RetClass,
                            VReg Op1Class,
                            VReg Op2Class,
                            string Constraint = "",
                            int TargetConstraintType = 1> :
      Pseudo<(outs RetClass:$rd),
             (ins RetClass:$op1, Op1Class:$rs2, Op2Class:$rs1, AVL:$vl,
                  ixlenimm:$sew), []>,
      RISCVVPseudo {
  let mayLoad = 0;
  let mayStore = 0;
  let hasSideEffects = 0;
  let Constraints = Constraint;
  let TargetOverlapConstraintType = TargetConstraintType;
  let HasVLOp = 1;
  let HasSEWOp = 1;
  let BaseInstr = !cast<Instruction>(PseudoToVInst<NAME>.VInst);
}

multiclass VPseudoW_VVINCHI<LMULInfo m>  {
  //defvar constraint = "@earlyclobber $rd";
  let VLMul = m.value in {
    def "_" # m.MX : VPseudoVVINCHI<m.wvrclass, m.vrclass, m.vrclass>;
  }
}

multiclass VPseudoVCCI{
  foreach m = MXListInchi in {
    defm "" : VPseudoW_VVINCHI<m>;
  }
}

defm PseudoINCHIVdemoVcci      : VPseudoVCCI;

class VPatTernaryNoMaskINCHI<string intrinsic,
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
                    VLOpFrag )),
                   (!cast<Instruction>(inst#"_"#vlmul.MX)
                    (result_type result_reg_class:$rs3),
                    (op1_type op1_reg_class:$rs1),
                    (op2_type op2_kind:$rs2),
                    GPR:$vl, sew)>;

multiclass VPatTernaryINCHI<string intrinsic, string instruction,
                               list<VTypeInfoToWide> vtilist> {
  foreach vtiToWti = vtilist in {
    defvar vti = vtiToWti.Vti;
    defvar wti = vtiToWti.Wti;
    def : VPatTernaryNoMaskINCHI<intrinsic, instruction,
                                 wti.Vector, vti.Vector, vti.Vector,
                                 wti.Log2SEW, vti.LMul, 
                                 wti.RegClass,
                                 vti.RegClass, vti.RegClass>;
  }
}

let Predicates = [HasVendorXINCHIVdemo] in {
defm : VPatTernaryINCHI<"int_riscv_inchivdemo_vcci",  "PseudoINCHIVdemoVcci",
                              AllQuadWidenableInt8NoVLMulVectorsINCHI>;
}