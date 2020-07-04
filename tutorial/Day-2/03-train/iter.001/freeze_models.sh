for i in ?
do
  cd $i
  python -m deepmd freeze 2> /dev/null
  mv frozen_model.pb graph${i}.pb 
  cd ..
done
