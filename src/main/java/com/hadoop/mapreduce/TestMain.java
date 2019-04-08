package com.hadoop.mapreduce;


import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;



/**
 * 
 * hadoop 这里测试的时候用的是 docker安装的
 * 
 * docker pull sequenceiq/hadoop-docker<br>
 * docker run -it --name hadoop -p 50070:50070 sequenceiq/hadoop-docker /etc/bootstrap.sh -bash<br>
 * docker run -it --name myhadoop -p 50070:50070 myhadoop /etc/bootstrap.sh -bash (自己的镜像)<br>
 * 
 * docker run -it --name myhbase -p 50072:50070 hbase /etc/bootstrap.sh -bash(hbase的镜像)

 * cd $HADOOP_PREFIX<br>
 * 	测试<br><br>
 * bin/hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-2.7.0.jar grep input output 'dfs[a-z.]+'<br>
 * bin/hdfs dfs -cat output/*<br>
 * 
 * 须打成jar 然后 到有hadoop的环境中去执行<br>
 * 
 * 执行下面这个命令 去执行代码<br> 
 * export HADOOP_CLASSPATH=1.jar (把1.jar替换成你打的jar的名字)<br> 
 * 再执行 下面的这个命令<br> 
 * 
 * 第一个参数是 读取的文件地址 (1.txt 随便填点东西,后续可以按规则来.) <br> 
 * 第二个是执行后输出的文件地址<br> 
 * ./bin/hadoop com.hadoop.mapreduce.TestMain file:////usr/local/hadoop/1.txt file:///out -E<br> 
 * 
 * 
 * 执行成功后再 out目录下面会生成4个文件,其中:<br> 
 *  _SUCCESS   表示成功<br> 
 *  part-r-00000 计算后的具体结果<br> 
 *  
 *  
 *  <p>
 *  http://192.168.10.241:50070 是hadoop的一个图形界面管理工具.可以看datanode等.
 * @author 
 *
 */
public class TestMain {
	public static void main(String[] args) throws Exception {
		Job job=Job.getInstance();
		job.setJarByClass(TestMain.class);
		
		//设置作业名称
		job.setJobName("test_one");
		
		// 添加输入路劲(可以多个,如果目录,可以直接写目录名称, 也可以D:\\*.csv
		FileInputFormat.addInputPath(job, new Path(args[0]));
		
		//添加输出路劲
		FileOutputFormat.setOutputPath(job, new Path(args[1]));
		
		//设置mapper
		job.setMapperClass(TestMapper.class);
		// 设置reducer
		job.setReducerClass(TestReducer.class);
		//设置输出key类型
		job.setOutputKeyClass(LongWritable.class);
		// 设置输出val类型
		job.setOutputValueClass(Text.class);
		//
		job.waitForCompletion(true);
	}
}
