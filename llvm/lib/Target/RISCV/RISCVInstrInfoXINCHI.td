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
    : CustomInstVdemoVV<funct6, opv, (outs VR:$vd), (ins VR:$vs1, VR:$vs2),
                      opcodestr, "$vd, $vs1, $vs2"> {
  let vm = 1;
}
}

let Predicates = [HasVendorXINCHIVdemo] in {
def INCHIVdemoVcci      : CustomInstVdemoVCCI<0b000100, OPIVV, "inchi.vdemo">;
}


// defm PseudoTHVdotVMAQA      : VPseudoVMAQA_VV_VX;


//let Predicates = [HasVendorXINCHIVdemo] in {
//defm : VPatTernaryVMAQA_VV_VX<"int_riscv_th_vmaqa",  "PseudoTHVdotVMAQA",
//                              AllQuadWidenableInt8NoVLMulVectors>;
//}