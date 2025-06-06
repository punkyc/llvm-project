// REQUIRES: avr-registered-target
// RUN: %clang_cc1 -x c -triple avr -target-cpu at90s8515 -emit-llvm -o - %s \
// RUN:     | FileCheck --check-prefixes=CHECK,AVR25 %s
// RUN: %clang_cc1 -x c -triple avr -target-cpu atmega328 -emit-llvm -o - %s \
// RUN:     | FileCheck --check-prefixes=CHECK,AVR51 %s
// RUN: %clang_cc1 -x c -triple avr -target-cpu atmega2560 -emit-llvm -o - %s \
// RUN:     | FileCheck --check-prefixes=CHECK,AVR6 %s

int data;

void a() {
  // CHECK: call addrspace(0) void asm sideeffect "add r5, $0", "a"(i16 %0)
  asm("add r5, %0" :: "a"(data));
}

void b() {
  // CHECK: call addrspace(0) void asm sideeffect "add r5, $0", "b"(i16 %0)
  asm("add r5, %0" :: "b"(data));
}

void d() {
  // CHECK: call addrspace(0) void asm sideeffect "add r5, $0", "d"(i16 %0)
  asm("add r5, %0" :: "d"(data));
}

void l() {
  // CHECK: call addrspace(0) void asm sideeffect "add r5, $0", "l"(i16 %0)
  asm("add r5, %0" :: "l"(data));
}

void e() {
  // CHECK: call addrspace(0) void asm sideeffect "add r5, $0", "e"(i16 %0)
  asm("add r5, %0" :: "e"(data));
}

void q() {
  // CHECK: call addrspace(0) void asm sideeffect "add r5, $0", "q"(i16 %0)
  asm("add r5, %0" :: "q"(data));
}

void r() {
  // CHECK: call addrspace(0) void asm sideeffect "add r5, $0", "r"(i16 %0)
  asm("add r5, %0" :: "r"(data));
}

void w() {
  // CHECK: call addrspace(0) void asm sideeffect "add r5, $0", "w"(i16 %0)
  asm("add r5, %0" :: "w"(data));
}

void t() {
  // CHECK: call addrspace(0) void asm sideeffect "add r5, $0", "t"(i16 %0)
  asm("add r5, %0" :: "t"(data));
}

void x() {
  // CHECK: call addrspace(0) void asm sideeffect "add r5, $0", "x"(i16 %0)
  asm("add r5, %0" :: "x"(data));
}

void y() {
  // CHECK: call addrspace(0) void asm sideeffect "add r5, $0", "y"(i16 %0)
  asm("add r5, %0" :: "y"(data));
}

void z() {
  // CHECK: call addrspace(0) void asm sideeffect "add r5, $0", "z"(i16 %0)
  asm("add r5, %0" :: "z"(data));
}

void I() {
  // CHECK: call addrspace(0) void asm sideeffect "subi r30, $0", "I"(i16 50)
  asm("subi r30, %0" :: "I"(50));
  // CHECK: call addrspace(0) void asm sideeffect "subi r30, $0", "I"(i16 64)
  asm("subi r30, %0" :: "I"(64));
}

void J() {
  // CHECK: call addrspace(0) void asm sideeffect "subi r30, $0", "J"(i16 -50)
  asm("subi r30, %0" :: "J"(-50));
}

void K() {
  // CHECK: call addrspace(0) void asm sideeffect "subi r30, $0", "K"(i16 2)
  asm("subi r30, %0" :: "K"(2));
}

void L() {
  // CHECK: call addrspace(0) void asm sideeffect "subi r30, $0", "L"(i16 0)
  asm("subi r30, %0" :: "L"(0));
}

void M() {
  // CHECK: call addrspace(0) void asm sideeffect "subi r30, $0", "M"(i16 255)
  asm("subi r30, %0" :: "M"(255));
}

void O() {
  // CHECK: call addrspace(0) void asm sideeffect "subi r30, $0", "O"(i16 16)
  asm("subi r30, %0" :: "O"(16));
}

void P() {
  // CHECK: call addrspace(0) void asm sideeffect "subi r30, $0", "P"(i16 1)
  asm("subi r30, %0" :: "P"(1));
}

void R() {
  // CHECK: call addrspace(0) void asm sideeffect "subi r30, $0", "R"(i16 -3)
  asm("subi r30, %0" :: "R"(-3));
}

void G() {
  // CHECK: call addrspace(0) void asm sideeffect "subi r30, $0", "G"(i16 0)
  asm("subi r30, %0" :: "G"(0));
}

void Q() {
  // CHECK: call addrspace(0) void asm sideeffect "subi r30, $0", "Q"(i16 50)
  asm("subi r30, %0" :: "Q"(50));
}

void ra() {
  // CHECK: call addrspace(0) void asm sideeffect "subi r30, $0", "ra"(i16 50)
  asm("subi r30, %0" :: "ra"(50));
}

void ora() {
  // CHECK: call addrspace(0) i16 asm "subi r30, $0", "=ra"()
  asm("subi r30, %0" : "=ra"(data));
}

void escapeChar(void) {
  asm("_foo:");
  // AVR25: call addrspace(0) void asm sideeffect "rcall _foo"
  // AVR51: call addrspace(0) void asm sideeffect "call _foo"
  // AVR6:  call addrspace(0) void asm sideeffect "call _foo"
  asm("%~call _foo" ::);
  // AVR25: call addrspace(0) void asm sideeffect "rjmp _foo"
  // AVR51: call addrspace(0) void asm sideeffect "jmp _foo"
  // AVR6:  call addrspace(0) void asm sideeffect "jmp _foo"
  asm("%~jmp _foo" ::);
  // AVR25: call addrspace(0) void asm sideeffect "icall"
  // AVR51: call addrspace(0) void asm sideeffect "icall"
  // AVR6:  call addrspace(0) void asm sideeffect "eicall"
  asm("%!icall" ::);
  // AVR25: call addrspace(0) void asm sideeffect "ijmp"
  // AVR51: call addrspace(0) void asm sideeffect "ijmp"
  // AVR6:  call addrspace(0) void asm sideeffect "eijmp"
  asm("%!ijmp" ::);
}
