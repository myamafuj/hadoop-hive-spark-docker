-- 元号の部分を変数にしています。
Insert overwrite table jinko_avg PARTITION(kenmei)
select avg(jinko_male) as male_avg,avg(jinko_female),kenmei as female_avg
 from jinko
  where gengo='{GENGO}' and kenmei != '人口集中地区以外の地区'
 group by kenmei
 order by male_avg