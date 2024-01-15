# RUN: llvm-mc -triple=riscv64 -show-encoding --mattr=+xinchivdemo %s \
# RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INST
# RUN: not llvm-mc -triple=riscv64 -show-encoding %s 2>&1 \
# RUN:        | FileCheck %s --check-prefix=CHECK-ERROR
# RUN: llvm-mc -triple=riscv64 -filetype=obj --mattr=+xinchivdemo %s \
# RUN:        | llvm-objdump -d --mattr=+xinchivdemo - \
# RUN:        | FileCheck %s --check-prefix=CHECK-INST
# RUN: llvm-mc -triple=riscv64 -filetype=obj --mattr=+xinchivdemo %s \
# RUN:        | llvm-objdump -d - | FileCheck %s --check-prefix=CHECK-UNKNOWN

inchi.vdemo v8, v20, v4
# CHECK-INST: inchi.vdemo v8, v20, v4
# CHECK-ENCODING: [0x5b,0x04,0x4a,0x12]
# CHECK-ERROR: instruction requires the following: 'xinchivdemo' (INCHI Vector Extensions for Dot){{$}}
# CHECK-UNKNOWN: 5b 04 4a 12 <unknown>

inchi.vdemo v8, v20, v4, v0.t
# CHECK-INST: inchi.vdemo v8, v20, v4
# CHECK-ENCODING: [0x5b,0x04,0x4a,0x12]
# CHECK-ERROR: instruction requires the following: 'xinchivdemo' (INCHI Vector Extensions for Dot){{$}}
# CHECK-UNKNOWN: 5b 04 4a 12 <unknown>