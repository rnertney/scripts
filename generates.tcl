#############################
# This script will fix  
# GENERATE statements.
#
# Author: Rob Nertney
# Date:   6 Apr 2015
#############################
#Instructions:
#  
#  GENERATE_NAME needs to be what you define in your HDL
#  as the GENERATE_NAME[n].instance.
set GENERATE_NAME SLICE
#
#  This is the parent location of where the generate
#  statements will begin. Example:
#  parent_level/GENERATE_NAME[0].inst/...
# 
set ALL_GEN [get_cells parent_level/*]
##################################################


# loop through all instances of "generate"-d cores
foreach gen_inst $ALL_GEN {

  # match the generated name with [] in the name
  if {[regexp "$GENERATE_NAME" $gen_inst] && [regexp {\[*\]*} $gen_inst] } {
    
    # this will fail on some other instances that I can't account for
    # due to the synthesis rebuilding. I therefore make sure the 
    # found generates are hierarchical, and not lone registers/cells.
    if {[get_property PRIMITIVE_COUNT $gen_inst] > 1 } {
     
      # substitute the [ ] with _ _
      set nobracket_inst [regsub -all {\[|\]} $gen_inst "_"]
      # I also found that dots "." break SDK. Remove that
      set nodot_inst [regsub -all {\.} $nobracket_inst ""]

      #puts $gen_inst
      #puts $nobracket_inst
      #puts $nodot_inst

      #set the actual name in the netlist to the sanitized name
      rename_cell -to $nodot_inst $gen_inst

      unset gen_inst
      unset nobracket_inst
      unset nodot_inst
    }

  }
}

