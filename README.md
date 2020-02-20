# VAJRA

VAJRA is the implementation that accompanies our paper:
"Verifying Array Manipulating Programs with Full-program Induction". Supratik Chakraborty, Ashutosh Gupta, Divyesh Unadkat. In TACAS 2020. 

Vajra accepts a c program annotated with an assertion as input and
checks if the assertion holds or not using the full-program induction
technique.

Pre-compiled `vajra` binary
===========================

VAJRA/bin folder contains the vajra binary compiled on Ubuntu 18.04 LTS as well as
the libraries that it depends on. Following the instructions in VAJRA/bin/Readme.txt
for installing and using the pre-compiled binary.

Building on Ubuntu 18.04 LTS
============================

Install the following dependencies:

	sudo apt-get -y install git g++ cmake libboost-regex-dev libboost-program-options-dev libboost-filesystem-dev libboost-system-dev flex bison

	sudo apt-get install clang-6.0 clang-6.0-doc clang-6.0-examples clang-format-6.0 clang-tidy-6.0 clang-tools-6.0 cups-browsed libclang-6.0-dev libclang-common-6.0-dev libclang1-6.0 libllvm6.0 llvm-6.0 llvm-6.0-dev llvm-6.0-runtime python-clang-6.0 clang++-6.0

Some package names may not be exact.

Compilation requires an active internet connection as it fetches the latest Z3 sources.

Compiling
---------

To compile, navigate to the VAJRA folder and run

	make

which will result in the file `vajra` in the VAJRA folder.

Executing Vajra
===============

A C program file annotated with an assertion is to be given as input.

	./vajra [file]

Example:

	./vajra ../tacas2020-benchmarks/brs1.c

Vajra help:

	./vajra --help

OUTPUT
-------

Outputs VAJRA_VERIFICATION_SUCCESSFUL for safe programs

Outputs VAJRA_VERIFICATION_FAILED for unsafe programs

Outputs VAJRA_UNKNOWN when the result cannot be determined

Contact
=======

Kindly write to divyesh@cse.iitb.ac.in for any feedback, suggestions, queries and issues.

