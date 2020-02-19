#include<string>
#include "options.h"

namespace po = boost::program_options;

void options::show_help(po::options_description& desc) {
  std::cout << "\n\tVajra - Verifying Array Manipulating Programs by Full-program Induction";
  std::cout << "\n\tSupratik Chakraborty, Ashutosh Gupta, Divyesh Unadkat";
  std::cout << "\n\tIndian Institute of Technology, Computer Science Department";
  std::cout << "\n\t{supratik,akg,divyesh}@cse.iitb.ac.in\n\n";
  std::cout << "Usage:\t\t\t\t    Purpose:\n\n";
  std::cout << "vajra [-h] [--help]\t\t    Show help \n";
  std::cout << "vajra [Options] file.c ...\n";
  std::cout << desc << "\n";
}

void options::get_description_cmd(po::options_description& config,
                                  po::options_description& cmdline,
                                  po::options_description& hlp,
                                  po::positional_options_description& pd){

  po::options_description generic("Generic Options");
  po::options_description tiler("Vajra Options");
  po::options_description bmc("BMC Options");
  po::options_description hidden("Hidden Options");
  po::options_description license("LICENSE");

  tiler.add_options()
    ("function,f", po::value(&funcName)->default_value("main"), "Set main function")
    ("output-dir,o", po::value(&outDirPath)->default_value("/tmp/"), "Set output directory")
    //    ("mode,m", po::value<int>(&mode)->default_value(4), "Set mode")
    //    ("loop,l", po::value<int>(&loopNum)->default_value(1), "Set loop")
    //    ("total-loops,t", po::value<int>(&totalLoops)->default_value(1), "Set total number of loops")
    //    ("loop-peeling,a", po::bool_switch(&loop_aggr), "Run verification with loop peeling")
    ("full-program-induction,p", po::bool_switch(&fpi)->default_value(true), "Run full-program induction algorithm")
    ("dump-cfg,d", po::bool_switch(&dump_cfg), "Dump the llvm control flow graph")
    ("config,c", po::value<std::string>(), "Set config file")
    ;
  bmc.add_options()
    ("unwind,u", po::value<int>(&loop_unroll_count)->default_value(1), "Set loop unroll count")
    //    ("bounds-check", po::bool_switch(&includeOutOfBoundSpecs), "Enable array-index-out-of-bounds check")
    //    ("overflow-check", po::bool_switch(&includeOverUnderflowSpecs), "Enable over/underflow check")
    ;
  license.add_options()
    ("vajra-license", "Print Vajra License")
    ("boost-license", "Print Boost License")
    ("z3-license", "Print Z3 License")
    ;
  hidden.add_options()
    ("input,i", po::value(&filePath), "Set source files")
    ;
  generic.add_options()
    ("version", "Print version string")
    ("verbose,v", po::value<int>(&verbosity)->default_value(0), "Set verbosity level")
    ("help,h", "Print help")
    ;
  pd.add("input", -1);

  config.add(tiler).add(bmc).add(hidden).add(license);
  cmdline.add(config).add(generic);
  hlp.add(tiler).add(bmc).add(generic).add(license);
}

void options::interpret_options(po::variables_map& vm) {
  if (vm.count("input")) {
    boost::filesystem::path cf( filePath);
    fileName = cf.filename().string();
  }
  if (vm.count("unwind")) {
    unwind = true;
  }
  if( loop_aggr && mode == 3 ) {
    mode = 5;
  }
  if( fpi ) {
    mode = 4;
  }
  origFuncName = funcName;
}

void options::parse_config(boost::filesystem::path filename) {
  boost::filesystem::ifstream cfg_file(filename);
  po::variables_map vm;
  po::options_description config;
  po::options_description cmdline;
  po::options_description hlp;
  po::positional_options_description pd;

  get_description_cmd(config, cmdline, hlp, pd);
  po::notify(vm);
  try {
    po::store(po::parse_config_file(cfg_file, config, false), vm);
    po::notify(vm);
    interpret_options(vm);
  } catch ( const boost::program_options::error& e ) {
    tiler_error("config options", e.what());
  }
}

bool options::parse_cmdline(int argc, char** argv) {
  po::variables_map vm;
  po::options_description config;
  po::options_description cmdline;
  po::options_description hlp;
  po::positional_options_description pd;

  get_description_cmd(config, cmdline, hlp, pd);
  try {
    po::store(po::command_line_parser(argc, argv).options(cmdline).positional(pd).run(), vm);
    po::notify(vm);
    if (vm.count("version")) {
      std::cout << "\nVersion : " << vajra_version << "\n\n";
      return false;
    }
    if (vm.count("help")) {
      show_help(hlp);
      return false;
    }
    if (vm.count("boost-license")) {
      print_boost_license();
      return false;
    }
    if (vm.count("z3-license")) {
      print_z3_license();
      return false;
    }
    if (vm.count("vajra-license")) {
      print_vajra_license();
      return false;
    }
    if (!vm.count("input")) {
      std::cout << "\n\nNo input file specified ! \n";
      exit(1);
    }
    if (vm.count("config")) {
      boost::filesystem::path path(vm["config"].as<std::string>());
      parse_config(path);
    }
    interpret_options(vm);

  } catch ( const boost::program_options::error& e ) {
    tiler_error("command-line options", e.what());
    return false;
  }
  return true;
}

void options::print_z3_license() {
  std::cout << "Z3\n";
  std::cout << "Copyright (c) Microsoft Corporation\n";
  std::cout << "All rights reserved.\n";
  std::cout << "MIT License\n\n";
  std::cout << "Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\n\n";
  std::cout << "The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\n\n";
  std::cout << "THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.\n";
}

void options::print_boost_license() {
  std::cout << "Boost Software License - Version 1.0 - August 17th, 2003\n\n";
  std::cout << "Permission is hereby granted, free of charge, to any person or organization obtaining a copy of the software and accompanying documentation covered by this license (the \"Software\") to use, reproduce, display, distribute, execute, and transmit the Software, and to prepare derivative works of the Software, and to permit third-parties to whom the Software is furnished to do so, all subject to the following:\n\n";
  std::cout << "The copyright notices in the Software and this entire statement, including the above license grant, this restriction and the following disclaimer, must be included in all copies of the Software, in whole or in part, and all derivative works of the Software, unless such copies or derivative works are solely in the form of machine-executable object code generated by a source language processor.\n\n";
  std::cout << "THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.\n";
}

void options::print_vajra_license() {
  std::cout <<" (C) 2019-2020, Supratik Chakraborty, Ashutosh Gupta, Divyesh Unadkat, Computer Science Department, Indian Institute of Technology Bombay, Mumbai, India\n\nAll rights reserved.\n\n";
  std::cout <<" Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:\n\n";
  std::cout <<"   1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.\n\n";
  std::cout <<"   2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.\n\n";
  std::cout <<"   3. All advertising materials mentioning features or use of this software must display the following acknowledgement:\n\n";
  std::cout <<"   This product includes software developed by \n   Supratik Chakraborty, Ashutosh Gupta, Divyesh Unadkat \n   Computer Science Department, Indian Institute of Technology Bombay, \n   Mumbai, India\n\n";
  std::cout <<"   4. Neither the name of the Institute nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.\n\n";
  std::cout << " THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS \"AS IS\" \n AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE \n IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE \n ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE \n LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR \n CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF \n SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS \n INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN \n CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) \n ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE \n POSSIBILITY OF SUCH DAMAGE.\n";
}
