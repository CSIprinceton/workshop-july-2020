cat << EOF > large_std.py
import numpy as np

f=np.genfromtxt('model_devi.out').transpose()

#f[4] is the max deviation in forces
filter=np.logical_and(f[4]>0.08,f[4]<1.0)
stepnumber=f[0][filter]

#Selecting a maximum of 150 snapshots
sep=int(stepnumber.shape[0]/150.)+1
stepnumber=stepnumber[::sep]

for i in stepnumber:
  print(int(i))
EOF

python large_std.py > std_ind

[ -e coord.raw ] && rm coord.raw

for index in `cat std_ind`
do
  grep -x $index -B 1 -A 15 pos.lammpstrj > tmp
  tail -n 8 tmp | sort -gk 1 | awk '{printf "%12.8f %12.8f %12.8f", $3*40,$4*40,$5*40}' >> coord.raw  
  echo "" >> coord.raw
done

rm std_ind large_std.py tmp
