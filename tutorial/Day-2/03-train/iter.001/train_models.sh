for i in ?
do
  cd $i
  python -m deepmd train &
  cd ..
done

wait
