# VAJRA

VAJRA is the implementation that accompanies our paper:
"Verifying Array Manipulating Programs with Full-program Induction". Supratik Chakraborty, Ashutosh Gupta, Divyesh Unadkat. In TACAS 2020. 

Vajra accepts a c program annotated with an assertion as input and
checks if the assertion holds or not using the full-program induction
technique.

Building on Ubuntu 18.04 LTS
============================

Install the following dependencies:

	sudo apt-get -y install git g++ cmake libboost-regex-dev libboost-program-options-dev libboost-filesystem-dev libboost-system-dev flex bison

	sudo apt-get install clang-6.0 clang-6.0-doc clang-6.0-examples clang-format-6.0 clang-tidy-6.0 clang-tools-6.0 cups-browsed libclang-6.0-dev libclang-common-6.0-dev libclang1-6.0 libllvm6.0 llvm-6.0 llvm-6.0-dev llvm-6.0-runtime python-clang-6.0 clang++-6.0

Building requires an active internet connection as it pulls Z3 sources and compiles them.

Compiling
---------

To compile, navigate to the VAJRA folder and run

	cd VAJRA
	make

which will result in the file `vajra` in the VAJRA folder.

Executing Vajra
===============

A C program file annotated with an assertion is to be given as input.

	./vajra [file]

Vajra help:

	./vajra --help

