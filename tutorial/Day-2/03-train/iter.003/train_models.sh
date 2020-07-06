for i in ?
do
  cd $i
  python -m deepmd train input.json &> log.train &
  cd ..
done

wait
