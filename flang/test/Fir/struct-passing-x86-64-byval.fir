// Test X86-64 ABI rewrite of struct passed by value (BIND(C), VALUE derived types).
// This test test cases where the struct must be passed on the stack according
// to the System V ABI.
// RUN: tco --target=x86_64-unknown-linux-gnu %s | FileCheck %s

module attributes {fir.defaultkind = "a1c4d8i4l4r4", fir.kindmap = "", llvm.data_layout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu"} {

func.func @takes_toobig(%arg0: !fir.type<toobig{i:!fir.array<5xi32>}>) {
  return
}
func.func @takes_toobig_align16(%arg0: !fir.type<toobig_align16{i:i128,j:i8}>) {
  return
}
func.func @not_enough_int_reg_1(%arg0: i32, %arg1: i32, %arg2: i32, %arg3: i32, %arg4: i32, %arg5: i32, %arg6: !fir.type<fits_in_1_int_reg{i:i32,j:i32}>) {
  return
}
func.func @not_enough_int_reg_1b(%arg0: !fir.ref<i32>, %arg1: !fir.ref<i32>, %arg2: !fir.ref<i32>, %arg3: !fir.ref<i32>, %arg4: !fir.ref<i32>, %arg5: !fir.ref<i32>, %arg6: !fir.type<fits_in_1_int_reg{i:i32,j:i32}>) {
  return
}
func.func @not_enough_int_reg_2(%arg0: i32, %arg1: i32, %arg2: i32, %arg3: i32, %arg4: i32, %arg5: !fir.type<fits_in_2_int_reg{i:i64,j:i64}>) {
  return
}
func.func @ftakes_toobig(%arg0: !fir.type<ftoobig{i:!fir.array<5xf32>}>) {
  return
}
func.func @ftakes_toobig_align16(%arg0: !fir.type<ftoobig_align16{i:f128,j:f32}>) {
  return
}
func.func @not_enough_sse_reg_1(%arg0: f32, %arg1: f32, %arg2: f32, %arg3: f32, %arg4: f32, %arg5: f32, %arg6: f32, %arg7: f32, %arg8: !fir.type<fits_in_1_sse_reg{i:f32,j:f32}>) {
  return
}
func.func @not_enough_sse_reg_1b(%arg0: complex<f32>, %arg1: complex<f32>, %arg2: complex<f32>, %arg3: complex<f32>, %arg4: complex<f32>, %arg5: complex<f32>, %arg6: complex<f32>, %arg7: complex<f32>, %arg8: !fir.type<fits_in_1_sse_reg{i:f32,j:f32}>) {
  return
}
func.func @not_enough_sse_reg_1c(%arg0: complex<f64>, %arg1: complex<f64>, %arg2: complex<f64>, %arg3: complex<f64>, %arg4: !fir.type<fits_in_1_sse_reg{i:f32,j:f32}>) {
  return
}
func.func @not_enough_sse_reg_2(%arg0: f32, %arg1: f32, %arg2: f32, %arg3: f32, %arg4: f32, %arg5: f32, %arg6: f32, %arg7: !fir.type<fits_in_2_sse_reg{i:f64,j:f64}>) {
  return
}
func.func @test_contains_x87(%arg0: !fir.type<contains_x87{i:f80}>) {
  return
}
func.func @test_contains_complex_x87(%arg0: !fir.type<contains_complex_x87{i:complex<f80>}>) {
  return
}
func.func @test_nested_toobig(%arg0: !fir.type<nested_toobig{x:!fir.array<3x!fir.type<fits_in_1_int_reg{i:i32,j:i32}>>}>) {
  return
}
func.func @test_badly_aligned(%arg0: !fir.type<badly_aligned{x:f32,y:f64,z:f32}>) {
  return
}
func.func @test_logical_toobig(%arg0: !fir.type<logical_too_big{l:!fir.array<17x!fir.logical<1>>}>) {
  return
}
func.func @l_not_enough_int_reg(%arg0: i32, %arg1: i32, %arg2: i32, %arg3: i32, %arg4: i32, %arg5: !fir.type<l_fits_in_2_int_reg{l:!fir.array<4x!fir.logical<4>>}>) {
  return
}
func.func @test_complex_toobig(%arg0: !fir.type<complex_too_big{c:!fir.array<2xcomplex<f64>>}>) {
  return
}
func.func @cplx_not_enough_sse_reg_1(%arg0: f32, %arg1: f32, %arg2: f32, %arg3: f32, %arg4: f32, %arg5: f32, %arg6: f32, %arg7: f32, %arg8: !fir.type<cplx_fits_in_1_sse_reg{c:complex<f32>}>) {
  return
}
func.func @test_char_to_big(%arg0: !fir.type<char_too_big{c:!fir.array<17x!fir.char<1>>}>) {
  return
}
func.func @char_not_enough_int_reg_1(%arg0: i32, %arg1: i32, %arg2: i32, %arg3: i32, %arg4: i32, %arg5: i32, %arg6: !fir.type<char_fits_in_1_int_reg{c:!fir.array<8x!fir.char<1>>}>) {
  return
}
func.func @mix_not_enough_int_reg_1(%arg0: i32, %arg1: i32, %arg2: i32, %arg3: i32, %arg4: i32, %arg5: i32, %arg6: !fir.type<mix_in_1_int_reg{x:f32,i:i32}>) {
  return
}
func.func @mix_not_enough_sse_reg_2(%arg0: f32, %arg1: f32, %arg2: f32, %arg3: f32, %arg4: f32, %arg5: f32, %arg6: f32, %arg7: f32, %arg8: !fir.type<mix_in_1_int_reg_1_sse_reg{i:!fir.array<2xi32>,x:!fir.array<2xf32>}>) {
  return
}
func.func @not_enough_int_reg_3(%arg0: i32, %arg1: i32, %arg2: i32, %arg3: i32, %arg4: i32, %arg6: !fir.type<fits_in_1_int_reg{i:i32,j:i32}>) -> complex<f128> {
  %0 = fir.zero_bits complex<f128> 
  return %0 : complex<f128>
}
}

// CHECK: define void @takes_toobig(ptr noalias byval(%toobig) align 8 captures(none) %{{.*}}) {
// CHECK: define void @takes_toobig_align16(ptr noalias byval(%toobig_align16) align 16 captures(none) %{{.*}}) {
// CHECK: define void @not_enough_int_reg_1(i32 %{{.*}}, i32 %{{.*}}, i32 %{{.*}}, i32 %{{.*}}, i32 %{{.*}}, i32 %{{.*}}, ptr noalias byval(%fits_in_1_int_reg) align 8 captures(none) %{{.*}}) {
// CHECK: define void @not_enough_int_reg_1b(ptr noalias captures(none) %{{.*}}, ptr noalias captures(none) %{{.*}}, ptr noalias captures(none) %{{.*}}, ptr noalias captures(none) %{{.*}}, ptr noalias captures(none) %{{.*}}, ptr noalias captures(none) %{{.*}}, ptr noalias byval(%fits_in_1_int_reg) align 8 captures(none) %{{.*}}) {
// CHECK: define void @not_enough_int_reg_2(i32 %{{.*}}, i32 %{{.*}}, i32 %{{.*}}, i32 %{{.*}}, i32 %{{.*}}, ptr noalias byval(%fits_in_2_int_reg) align 8 captures(none) %{{.*}}) {
// CHECK: define void @ftakes_toobig(ptr noalias byval(%ftoobig) align 8 captures(none) %{{.*}}) {
// CHECK: define void @ftakes_toobig_align16(ptr noalias byval(%ftoobig_align16) align 16 captures(none) %{{.*}}) {
// CHECK: define void @not_enough_sse_reg_1(float %{{.*}}, float %{{.*}}, float %{{.*}}, float %{{.*}}, float %{{.*}}, float %{{.*}}, float %{{.*}}, float %{{.*}}, ptr noalias byval(%fits_in_1_sse_reg) align 8 captures(none) %{{.*}}) {
// CHECK: define void @not_enough_sse_reg_1b(<2 x float> %{{.*}}, <2 x float> %{{.*}}, <2 x float> %{{.*}}, <2 x float> %{{.*}}, <2 x float> %{{.*}}, <2 x float> %{{.*}}, <2 x float> %{{.*}}, <2 x float> %{{.*}}, ptr noalias byval(%fits_in_1_sse_reg) align 8 captures(none) %{{.*}}) {
// CHECK: define void @not_enough_sse_reg_1c(double %{{.*}}, double %{{.*}}, double %{{.*}}, double %{{.*}}, double %{{.*}}, double %{{.*}}, double %{{.*}}, double %{{.*}}, ptr noalias byval(%fits_in_1_sse_reg) align 8 captures(none) %{{.*}}) {
// CHECK: define void @not_enough_sse_reg_2(float %{{.*}}, float %{{.*}}, float %{{.*}}, float %{{.*}}, float %{{.*}}, float %{{.*}}, float %{{.*}}, ptr noalias byval(%fits_in_2_sse_reg) align 8 captures(none) %{{.*}}) {
// CHECK: define void @test_contains_x87(ptr noalias byval(%contains_x87) align 16 captures(none) %{{.*}}) {
// CHECK: define void @test_contains_complex_x87(ptr noalias byval(%contains_complex_x87) align 16 captures(none) %{{.*}}) {
// CHECK: define void @test_nested_toobig(ptr noalias byval(%nested_toobig) align 8 captures(none) %{{.*}}) {
// CHECK: define void @test_badly_aligned(ptr noalias byval(%badly_aligned) align 8 captures(none) %{{.*}}) {
// CHECK: define void @test_logical_toobig(ptr noalias byval(%logical_too_big) align 8 captures(none) %{{.*}}) {
// CHECK: define void @l_not_enough_int_reg(i32 %{{.*}}, i32 %{{.*}}, i32 %{{.*}}, i32 %{{.*}}, i32 %{{.*}}, ptr noalias byval(%l_fits_in_2_int_reg) align 8 captures(none) %{{.*}}) {
// CHECK: define void @test_complex_toobig(ptr noalias byval(%complex_too_big) align 8 captures(none) %{{.*}}) {
// CHECK: define void @cplx_not_enough_sse_reg_1(float %{{.*}}, float %{{.*}}, float %{{.*}}, float %{{.*}}, float %{{.*}}, float %{{.*}}, float %{{.*}}, float %{{.*}}, ptr noalias byval(%cplx_fits_in_1_sse_reg) align 8 captures(none) %{{.*}}) {
// CHECK: define void @test_char_to_big(ptr noalias byval(%char_too_big) align 8 captures(none) %{{.*}}) {
// CHECK: define void @char_not_enough_int_reg_1(i32 %{{.*}}, i32 %{{.*}}, i32 %{{.*}}, i32 %{{.*}}, i32 %{{.*}}, i32 %{{.*}}, ptr noalias byval(%char_fits_in_1_int_reg) align 8 captures(none) %{{.*}}) {
// CHECK: define void @mix_not_enough_int_reg_1(i32 %{{.*}}, i32 %{{.*}}, i32 %{{.*}}, i32 %{{.*}}, i32 %{{.*}}, i32 %{{.*}}, ptr noalias byval(%mix_in_1_int_reg) align 8 captures(none) %{{.*}}) {
// CHECK: define void @mix_not_enough_sse_reg_2(float %{{.*}}, float %{{.*}}, float %{{.*}}, float %{{.*}}, float %{{.*}}, float %{{.*}}, float %{{.*}}, float %{{.*}}, ptr noalias byval(%mix_in_1_int_reg_1_sse_reg) align 8 captures(none) %{{.*}}) {
// CHECK: define void @not_enough_int_reg_3(ptr noalias sret({ fp128, fp128 }) align 16 captures(none) %{{.*}}, i32 %{{.*}}, i32 %{{.*}}, i32 %{{.*}}, i32 %{{.*}}, i32 %{{.*}}, ptr noalias byval(%fits_in_1_int_reg) align 8 captures(none) %{{.*}})
