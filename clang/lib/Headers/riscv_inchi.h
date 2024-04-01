/*===---- riscv_crypto.h - RISC-V Zk* intrinsics ---------------------------===
 *
 * Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
 * See https://llvm.org/LICENSE.txt for license information.
 * SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
 *
 *===-----------------------------------------------------------------------===
 */

#ifndef __RISCV_INCHI_H
#define __RISCV_INCHI_H

#include <stdint.h>

#if defined(__cplusplus)
extern "C" {
#endif

#if __riscv_xlen == 64
static __inline__ uint64_t* __attribute__((__always_inline__, __nodebug__))
__riscv_inchi_cp32(uint64_t* __x, uint64_t* __y) {
  return __builtin_riscv_inchi_cp32(__x, __y);
}

static __inline__ uint64_t __attribute__((__always_inline__, __nodebug__))
__riscv_inchi_madd32(uint64_t __x, uint64_t __y, uint64_t __z) {
  return __builtin_riscv_inchi_madd32(__x, __y, __z);
}
#endif

#if defined(__cplusplus)
}
#endif
#endif