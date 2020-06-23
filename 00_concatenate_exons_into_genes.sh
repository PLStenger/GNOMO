awk '{
  count[$1]++
  min[$1]=(!($1 in min) || $2<min[$1]) ? $2 : min[$1]
  max[$1]=(!($1 in max) || $3>max[$1]) ? $3 : max[$1]
}
END {
  for(i in count) print i,count[i],min[i],max[i]
}' input_file > output_file | column -t
