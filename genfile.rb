#!/usr/bin/ruby

require 'date'
data = []
metric_list = []
file_list = [
  "raw-data/DGS3MO.csv",
  "raw-data/DGS6MO.csv",
  "raw-data/DGS1.csv",
  "raw-data/DGS2.csv",
  "raw-data/DGS3.csv",
  "raw-data/DGS5.csv",
  "raw-data/DGS10.csv"]
file_list.each do |file|
  puts file
  metric= /(DGS.*)\.csv/.match(file)[1]
  metric_list << metric
  File.new(file,"r").each_line do |line|
    next if line =~ /DATE/
    date,rate = line.split(',')
    days = Date.parse(date) - Date.parse("1982-01-04")
    next if days < 0
    rate_i = (rate.to_f * 100).to_i
    if (data[days].nil?)
      data[days]={metric => rate_i}
    else
      data[days][metric] = rate_i
    end
  end
end
puts "STARTING"
data.each_index do |idx|
  str_list = []
  str_list <<  "#{idx}"
  next if data[idx].nil?
  metric_list.each do |metric|
    str_list << data[idx][metric].to_s
  end
  next if (str_list[2].to_i == 0) && (str_list[3].to_i == 0)
  puts str_list.join(',')
end
