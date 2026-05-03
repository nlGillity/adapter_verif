#include "Vadapter_tb.h"
#include "verilated.h"
#include "verilated_vcd_c.h"


int main(int argc, char** argv) {
  VerilatedContext* contextp = new VerilatedContext;
  contextp->commandArgs(argc, argv);
  Vadapter_tb* top = new Vadapter_tb{contextp};
    

  Verilated::traceEverOn(true);
  VerilatedVcdC *tfp = new VerilatedVcdC;
  top->trace(tfp, 99);
  tfp->open("sim.vcd");

  while (!contextp->gotFinish()) 
  {
    top->eval();
    tfp->dump(contextp->time());

    if (!top->eventsPending()) break;
    contextp->time(top->nextTimeSlot());
  }

#if VM_TRACE
    tfp->close();
#endif


  delete top;
  delete contextp;
  return 0;
}