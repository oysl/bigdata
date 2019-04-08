package com.hadoop.mapreduce;

import java.io.IOException;

import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;


public class TestReducer extends Reducer<LongWritable, Text, LongWritable, Text>{
	@Override
	protected void reduce(LongWritable arg0, Iterable<Text> arg1,Context arg2) throws IOException, InterruptedException {

		String a="";
		for (Text longWritable : arg1) {
			System.out.println("reduce的val:"+longWritable);
			a+=longWritable.toString();
		}
		arg2.write(arg0, new Text(a));
	}

}
