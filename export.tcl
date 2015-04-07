#check for an opened design

if {[current_design] == ""} {
  puts "******ERROR: Open an Implemented Design******"
} else {

  unset block_diagram bd_list HW_DEF_FILE SW_DEF_FILE BITFILE_EXPORT

  foreach block_diagram [get_files *.bd] {
    #get all bds into a list
    lappend bd_list $block_diagram

    #disable them after adding them
    set_property used_in_synthesis false $block_diagram
    set_property used_in_implementation false $block_diagram
    set_property used_in_simulation false $block_diagram
    set_property is_enabled false $block_diagram
  }

  #grab from the list, not the Vivado
  foreach block_diagram $bd_list {
#   puts  $block_diagram

   set_property used_in_synthesis true $block_diagram
   set_property used_in_implementation true $block_diagram
   set_property used_in_simulation true $block_diagram
   set_property is_enabled true $block_diagram

   #grab only the "filename" of the block diagram
   set bd_name [file tail $block_diagram]
#   puts $bd_name
   #Force Vivado Up to Date
   set_property needs_refresh false [get_runs synth_1]
   set_property needs_refresh false [get_runs impl_1]

   #set path variables
   set HW_DEF_FILE [get_property DIRECTORY [get_projects]]
#   puts $HW_DEF_FILE

   set SW_DEF_FILE [get_property DIRECTORY [get_projects]]
#   puts $SW_DEF_FILE

   #grab the bitsream, same for both exports
   set BITFILE_EXPORT [get_property DIRECTORY [get_projects]] 
#   puts $BITFILE_EXPORT

   #grab the current implemented design's bitfile and append to path
   append BITFILE_EXPORT "/" [get_projects] ".runs/" [current_run] "/" [get_property TOP [current_fileset]] ".bit" 
#   puts $BITFILE_EXPORT

   #append BITFILE_EXPORT "/" [get_projects] ".runs/" [current_run] "/" "Clock_MDM_wrapper.bit" 
   #create the ARM export files paths
  
   

   file mkdir [append HW_DEF_FILE "/" [get_projects] ".sdk/"]


   append HW_DEF_FILE [get_projects] "_" $bd_name ".hdf"
#   puts $HW_DEF_FILE

   append SW_DEF_FILE "/" [get_projects] ".sdk/" [get_projects] "_" $bd_name ".sysdef"
#   puts $SW_DEF_FILE
   #execute the export to SDK file
   write_hwdef -file $HW_DEF_FILE
   write_sysdef -hwdef $HW_DEF_FILE -bitfile $BITFILE_EXPORT -file $SW_DEF_FILE
   file rename -force $SW_DEF_FILE $HW_DEF_FILE


   #disable it again (for next one)
   set_property used_in_synthesis false $block_diagram
   set_property used_in_implementation false $block_diagram
   set_property used_in_simulation false $block_diagram
   set_property is_enabled false $block_diagram

   }

   #re-enable and force up-to-date all bds
   foreach block_diagram $bd_list {

   set_property used_in_synthesis true $block_diagram
   set_property used_in_implementation true $block_diagram
   set_property used_in_simulation true $block_diagram
   set_property is_enabled true $block_diagram


   set_property needs_refresh false [get_runs synth_1]
   set_property needs_refresh false [get_runs impl_1]

  }
}
