top - VHDL program that implement a controller-based system that operates on number sequences.

aux_package - Package that helps using top as a component in other programs (such as test benches).

Control - Moore's machine used as a controller for Datapath

Datapath - This module is responsible for processing the input sequence and operate accordingly.

FA - Implementation of a Full Adder.

AdderSub - This module Adder or Subtractor according to a control line.

Logical - This module preforms an n-bit Or, And or Xor according to a control vector.

ALU - This module outputs the result of AdderSub or Logical according to the ops from the input.

