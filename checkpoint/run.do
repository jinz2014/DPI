onerror {quit -f}
onbreak {resume}

transcript on

run 100
checkpoint checkpt100.dat

# warm restore run
restore checkpt100.dat
echo $now
quit -sim

# cold restore run
vsim -restore checkpt100.dat
quit -sim

quit -f
