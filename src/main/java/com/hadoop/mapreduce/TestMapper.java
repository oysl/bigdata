package com.hadoop.mapreduce;

import java.io.IOException;

import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;


public class TestMapper extends Mapper<LongWritable, Text, LongWritable, Text>{

	@Override
	protected void map(LongWritable key, Text value, Context context)
			throws IOException, InterruptedException {
		System.out.println("key:"+key);
		System.out.println("value:"+value);
		context.write(key, value);
	}

}
