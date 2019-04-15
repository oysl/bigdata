package com.spark.test;

import org.apache.spark.SparkConf;
import org.apache.spark.api.java.JavaSparkContext;

public class SparkContextTest {
	public static void main(String[] args) {
		SparkConf conf=new SparkConf();
		
		JavaSparkContext sc=new JavaSparkContext(conf);
		
	}
}
