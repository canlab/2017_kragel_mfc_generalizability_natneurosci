#!/bin/bash

for j in {1..50}
do
for i in {1..20}
do
#SBATCH -N 1
#SBATCH --time=00:20:00
#SBATCH --qos=blanca-ics 
#SBATCH -J 
JOB=`sbatch <<EOF
#!/bin/bash
#SBATCH -N 1
#SBATCH -c 2
#SBATCH --time=1:30:00
#SBATCH --qos=blanca-ics
#SBATCH -J searchlight_rsa
#SBATCH --output=searchlight_rsa_%j.out

module load matlab/matlab-2014a
cd /home/phkr0046/ 
matlab << M_PROG
run(searchlight_map_cluster);
exit
M_PROG
EOF
`
echo "JobID = ${JOB} for iteration ${i} submitted"
done
sleep 1.5h
done
exit