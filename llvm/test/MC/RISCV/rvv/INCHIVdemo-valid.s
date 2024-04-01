# RUN: llvm-mc -triple=riscv64 -show-encoding --mattr=+xinchivdemo %s \
# RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
# RUN: not llvm-mc -triple=riscv64 -show-encoding %s 2>&1 \
# RUN:        | FileCheck %s --check-prefix=CHECK-ERROR
# RUN: llvm-mc -triple=riscv64 -filetype=obj --mattr=+xinchivdemo %s \
# RUN:        | llvm-objdump -d --mattr=+xinchivdemo - \
# RUN:        | FileCheck %s --check-prefix=CHECK-INST
# RUN: llvm-mc -triple=riscv64 -filetype=obj --mattr=+xinchivdemo %s \
# RUN:        | llvm-objdump -d - | FileCheck %s --check-prefix=CHECK-UNKNOWN

inchi.vmadd32 v8, v20, v4
# CHECK-INST: inchi.vmadd32 v8, v20, v4
# CHECK-ENCODING: [0x0b,0x14,0x4a,0x06]
# CHECK-ERROR: instruction requires the following: 'xinchivdemo' (INCHI Vector Extensions for Dot){{$}}
# CHECK-UNKNOWN: 0b 14 4a 06 <unknown>


inchi.vmadd32 v8, v2, v4
# CHECK-INST: inchi.vmadd32 v8, v2, v4
# CHECK-ENCODING: [0x0b,0x14,0x41,0x06]
# CHECK-ERROR: instruction requires the following: 'xinchivdemo' (INCHI Vector Extensions for Dot){{$}}
# CHECK-UNKNOWN: 0b 14 41 06 <unknown>

inchi.cp32 a0, a1, a2
# CHECK-INST: inchi.cp32 a0, a1, a2
# CHECK-ENCODING: [0x0b,0xa5,0xc5,0x06]
# CHECK-ERROR: instruction requires the following: 'xinchivdemo' (INCHI Vector Extensions for Dot){{$}}
# CHECK-UNKNOWN: 0b a5 c5 06 <unknown>

inchi.madd32 a0, a1, a2
# CHECK-INST: inchi.madd32 a0, a1, a2
# CHECK-ENCODING: [0x0b,0x85,0xc5,0x06]
# CHECK-ERROR: instruction requires the following: 'xinchivdemo' (INCHI Vector Extensions for Dot){{$}}
# CHECK-UNKNOWN: 0b 85 c5 06 <unknown>