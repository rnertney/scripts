#SET YOUR FILE PATHS HERE
#
set input   "input"
set output  "output"

set in_fp [open $input r]
set out_fp [open $output w]
set file_data [read $in_fp]

set nert_fp [open "nertney" w]

set data [split $file_data "\n"]
foreach line $data {
  regsub -all {\mGTPE2_CHANNEL_X0Y3\M} $line GTPE2_CHANNEL_X0Y0NERTNEY line
  regsub -all {\mGTPE2_CHANNEL_X0Y2\M} $line GTPE2_CHANNEL_X0Y1NERTNEY line
  regsub -all {\mGTPE2_CHANNEL_X0Y1\M} $line GTPE2_CHANNEL_X0Y2NERTNEY line
  regsub -all {\mGTPE2_CHANNEL_X0Y0\M} $line GTPE2_CHANNEL_X0Y3NERTNEY line

  regsub -all {\mRAMB36_X2Y5\M} $line RAMB36_X2Y1NERTNEY line
  regsub -all {\mRAMB36_X2Y4\M} $line RAMB36_X2Y2NERTNEY line
  regsub -all {\mRAMB36_X2Y2\M} $line RAMB36_X2Y4NERTNEY line
  regsub -all {\mRAMB36_X2Y1\M} $line RAMB36_X2Y5NERTNEY line 

  puts $nert_fp $line
}
close $nert_fp

set nert_fp [open "nertney" r]

set nert_data [read $nert_fp]

set data2  [split $nert_data "\n"]
foreach line2 $data2 {
  puts $line2
  regsub -all NERTNEY $line2 " " line2
  puts $out_fp $line2
}

close $in_fp
close $out_fp
close $nert_fp

file rename -force $output $input
file delete "nertney"
