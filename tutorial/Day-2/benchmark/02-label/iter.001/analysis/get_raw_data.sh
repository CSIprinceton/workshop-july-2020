natoms=8
pconv="1"
econv="13.6056980659"
fconv="25.71095"
cell=" 10.0    0.00000    0.00000    0.00000    10.00    0.00000    0.00000    0.00000    10.000"
sconv="1000"

rm *.raw 2> /dev/null

function volume () {

  grep 'unit-cell volume' $1 | awk '{print $4}'

}

function print_virial () {

    v=`volume $1`
    v=`echo "$v*$econv" | bc -l`
    grep -A 3 'total   stress' $1 | tail -n 3 | awk -v"a=$v" '{printf "%15.8f %15.8f %15.8f ", $1*a, $2*a, $3*a}'

}

write_raw () {

  if grep -q 'Forces acting' $1 && grep -q 'JOB DONE' $1
  then
    tail -n $natoms $2 | awk -v"a=$pconv" '{printf "%12.8f %12.8f %12.8f ", $2*a, $3*a, $4*a }' >> coord.raw
    grep -A $((natoms+1)) 'Forces acting' $1 | tail -n $natoms | awk -v"a=$fconv" '/atom/ && /force =/ {printf "%12.8f %12.8f %12.8f ", $7*a, $8*a, $9*a }' >> force.raw
    grep ! $1 | awk -v"a=$econv" 'END{printf "%15.8f\n", $5*a}' >> energy.raw
    echo $cell >> box.raw

    echo "" >> coord.raw
    echo "" >> force.raw
    echo "" >> virial.raw
  fi

}

for i in `seq -f "%05g" 436`
do
  if [ -e ../$i/01.out ]  
  then
    write_raw ../$i/01.out ../$i/01.in
  fi
done

