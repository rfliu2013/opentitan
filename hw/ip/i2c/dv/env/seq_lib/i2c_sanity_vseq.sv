// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// basic sanity test vseq
class i2c_sanity_vseq extends i2c_rx_tx_vseq;
  `uvm_object_utils(i2c_sanity_vseq)
  `uvm_object_new

  constraint clear_intr_dly_c  { clear_intr_dly inside {[0 : 10]}; }
  constraint num_wr_bytes_c    { num_wr_bytes   inside {[1 : 5]}; }
  constraint num_rd_bytes_c    { num_rd_bytes   inside {[1 : 5]}; }
  constraint num_trans_c       { num_trans      inside {[50 : 100]}; }

  task body();
    device_init();
    host_init();

    `DV_CHECK_MEMBER_RANDOMIZE_FATAL(num_trans)
    fork
      begin
        while (do_interrupt) process_interrupts();
      end
      begin
        host_send_trans(num_trans);
        do_interrupt = 1'b0; // gracefully stop process_interrupts
      end
    join
  endtask : body

endclass : i2c_sanity_vseq
