package com.spark.test

import org.apache.spark.SparkConf
import org.apache.spark.SparkContext
object CountTest {
  def main(args: Array[String]) {
    var logfile = "d://Test.java"
    var conf = new SparkConf().setAppName("test")
    var sc = new SparkContext("spark://192.168.10.241:7077", "test", conf);
    var logData = sc.textFile(logfile, 2).cache();
    var numAs = logData.filter(line => line.contains("a")).count();
    println(numAs)
  }
}