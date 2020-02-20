Vajra is the implementation that accompanies our paper:
"Verifying Array Manipulating Programs with Full-program Induction". Supratik Chakraborty, Ashutosh Gupta, Divyesh Unadkat. In TACAS 2020. 

Vajra accepts a c program annotated with an assertion as input and checks if the assertion holds or not using the full-program induction technique.

Vajra is built on Ubuntu 18.04 LTS. It requires LLVM version 6.0.0, BOOST version 1.68 and Z3 version 4.8 to be install on the system. If these are already installed on the system and boost and z3 libraries are present in LD_LIBRARY_PATH, vajra can be directly executed.

Z3 version 4.8.7 can be found at https://github.com/Z3Prover/z3/releases/tag/z3-4.8.7

Boost version 1.68 can be found at https://www.boost.org/users/history/version_1_68_0.html

Please see the LICENSE file for Vajra, Boost and Z3 license.


Libraries required
------------------

From BOOST version 1.68
-----------------------
libboost_filesystem.so.1.68.0
libboost_program_options.so.1.68.0
libboost_system.so.1.68.0

From Z3 version 4.8
---------------------
libz3.so.4.8.7.0



INSTALLATION
------------

Run the following commands from the "VAJRA/binary" directory

cd VAJRA/binary

ln -s libz3.so.4.8.7.0 libz3.so.4.8

export LD_LIBRARY_PATH=.:$LD_LIBRARY_PATH

export PATH=.:$PATH



EXECUTE Vajra
-------------

vajra <path_to_benchmark_file>

Example:
vajra ../tacas2020-benchmarks/brs1.c



OUTPUT
-------

Outputs VAJRA_VERIFICATION_SUCCESSFUL for safe programs

Outputs VAJRA_VERIFICATION_FAILED for unsafe programs

Outputs VAJRA_UNKNOWN when result cannot be determined

