package com.spark.test

import org.apache.spark.SparkConf
import org.apache.spark.SparkContext
object CountTest {
  def main(args: Array[String]) {
    var logfile = "d://Test.java"
    var conf = new SparkConf().setAppName("test")
    conf.setMaster("local[4]");
    conf.setAppName("spark test");
    var sc = new SparkContext(conf);
    var logData = sc.textFile(logfile, 2).cache();
    var numAs = logData.filter(line => line.contains("a")).count();
    
    println("end")
  }
}
/*
 * 这个地方,需配置好本地的hadoop的环境变量,并且下载 https://github.com/amihalik/hadoop-common-2.6.0-bin  把这个解压,放到hadoop的bin目录下面
 * 再运行,即可!
 */
