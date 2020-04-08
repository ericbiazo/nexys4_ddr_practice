# 
# Report generation script generated by Vivado
# 

proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}

set_msg_config  -id {Constraints 18-5210}  -string {{WARNING: [Constraints 18-5210] No constraints selected for write.
Resolution: This message can indicate that there are no constraints for the design, or it can indicate that the used_in flags are set such that the constraints are ignored. This later case is used when running synth_design to not write synthesis constraints to the resulting checkpoint. Instead, project constraints are read when the synthesized design is opened.}}  -suppress 

start_step init_design
set ACTIVE_STEP init_design
set rc [catch {
  create_msg_db init_design.pb
  set_param chipscope.maxJobs 3
  set_param xicom.use_bs_reader 1
  create_project -in_memory -part xc7a100tcsg324-1
  set_property board_part_repo_paths {C:/Users/Eric/AppData/Roaming/Xilinx/Vivado/2019.2/xhub/board_store} [current_project]
  set_property board_part digilentinc.com:nexys4_ddr:part0:1.1 [current_project]
  set_property design_mode GateLvl [current_fileset]
  set_param project.singleFileAddWarning.threshold 0
  set_property webtalk.parent_dir E:/vivado_workspace/nexys4_ddr_pulse_gen/nexys4_ddr_pulse_gen.cache/wt [current_project]
  set_property parent.project_path E:/vivado_workspace/nexys4_ddr_pulse_gen/nexys4_ddr_pulse_gen.xpr [current_project]
  set_property ip_output_repo E:/vivado_workspace/nexys4_ddr_pulse_gen/nexys4_ddr_pulse_gen.cache/ip [current_project]
  set_property ip_cache_permissions {read write} [current_project]
  add_files -quiet E:/vivado_workspace/nexys4_ddr_pulse_gen/nexys4_ddr_pulse_gen.runs/synth_1/lab3_top.dcp
  read_xdc E:/vivado_workspace/nexys4_ddr_pulse_gen/nexys4_ddr_pulse_gen.srcs/constrs_1/new/nexys4_constraints.xdc
  link_design -top lab3_top -part xc7a100tcsg324-1
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
  unset ACTIVE_STEP 
}

start_step opt_design
set ACTIVE_STEP opt_design
set rc [catch {
  create_msg_db opt_design.pb
  opt_design 
  write_checkpoint -force lab3_top_opt.dcp
  create_report "impl_1_opt_report_drc_0" "report_drc -file lab3_top_drc_opted.rpt -pb lab3_top_drc_opted.pb -rpx lab3_top_drc_opted.rpx"
  close_msg_db -file opt_design.pb
} RESULT]
if {$rc} {
  step_failed opt_design
  return -code error $RESULT
} else {
  end_step opt_design
  unset ACTIVE_STEP 
}

start_step place_design
set ACTIVE_STEP place_design
set rc [catch {
  create_msg_db place_design.pb
  if { [llength [get_debug_cores -quiet] ] > 0 }  { 
    implement_debug_core 
  } 
  place_design 
  write_checkpoint -force lab3_top_placed.dcp
  create_report "impl_1_place_report_io_0" "report_io -file lab3_top_io_placed.rpt"
  create_report "impl_1_place_report_utilization_0" "report_utilization -file lab3_top_utilization_placed.rpt -pb lab3_top_utilization_placed.pb"
  create_report "impl_1_place_report_control_sets_0" "report_control_sets -verbose -file lab3_top_control_sets_placed.rpt"
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
  unset ACTIVE_STEP 
}

start_step phys_opt_design
set ACTIVE_STEP phys_opt_design
set rc [catch {
  create_msg_db phys_opt_design.pb
  phys_opt_design 
  write_checkpoint -force lab3_top_physopt.dcp
  close_msg_db -file phys_opt_design.pb
} RESULT]
if {$rc} {
  step_failed phys_opt_design
  return -code error $RESULT
} else {
  end_step phys_opt_design
  unset ACTIVE_STEP 
}

start_step route_design
set ACTIVE_STEP route_design
set rc [catch {
  create_msg_db route_design.pb
  route_design 
  write_checkpoint -force lab3_top_routed.dcp
  create_report "impl_1_route_report_drc_0" "report_drc -file lab3_top_drc_routed.rpt -pb lab3_top_drc_routed.pb -rpx lab3_top_drc_routed.rpx"
  create_report "impl_1_route_report_methodology_0" "report_methodology -file lab3_top_methodology_drc_routed.rpt -pb lab3_top_methodology_drc_routed.pb -rpx lab3_top_methodology_drc_routed.rpx"
  create_report "impl_1_route_report_power_0" "report_power -file lab3_top_power_routed.rpt -pb lab3_top_power_summary_routed.pb -rpx lab3_top_power_routed.rpx"
  create_report "impl_1_route_report_route_status_0" "report_route_status -file lab3_top_route_status.rpt -pb lab3_top_route_status.pb"
  create_report "impl_1_route_report_timing_summary_0" "report_timing_summary -max_paths 10 -file lab3_top_timing_summary_routed.rpt -pb lab3_top_timing_summary_routed.pb -rpx lab3_top_timing_summary_routed.rpx -warn_on_violation "
  create_report "impl_1_route_report_incremental_reuse_0" "report_incremental_reuse -file lab3_top_incremental_reuse_routed.rpt"
  create_report "impl_1_route_report_clock_utilization_0" "report_clock_utilization -file lab3_top_clock_utilization_routed.rpt"
  create_report "impl_1_route_report_bus_skew_0" "report_bus_skew -warn_on_violation -file lab3_top_bus_skew_routed.rpt -pb lab3_top_bus_skew_routed.pb -rpx lab3_top_bus_skew_routed.rpx"
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  write_checkpoint -force lab3_top_routed_error.dcp
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
  unset ACTIVE_STEP 
}

start_step write_bitstream
set ACTIVE_STEP write_bitstream
set rc [catch {
  create_msg_db write_bitstream.pb
  catch { write_mem_info -force lab3_top.mmi }
  write_bitstream -force lab3_top.bit 
  catch {write_debug_probes -quiet -force lab3_top}
  catch {file copy -force lab3_top.ltx debug_nets.ltx}
  close_msg_db -file write_bitstream.pb
} RESULT]
if {$rc} {
  step_failed write_bitstream
  return -code error $RESULT
} else {
  end_step write_bitstream
  unset ACTIVE_STEP 
}

