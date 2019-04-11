package com.hbase.test;

import java.io.IOException;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.hbase.HBaseConfiguration;
import org.apache.hadoop.hbase.HColumnDescriptor;
import org.apache.hadoop.hbase.HTableDescriptor;
import org.apache.hadoop.hbase.MasterNotRunningException;
import org.apache.hadoop.hbase.TableName;
import org.apache.hadoop.hbase.ZooKeeperConnectionException;
import org.apache.hadoop.hbase.client.Get;
import org.apache.hadoop.hbase.client.HBaseAdmin;
import org.apache.hadoop.hbase.client.HTable;
import org.apache.hadoop.hbase.client.Put;
import org.apache.hadoop.hbase.client.Result;
import org.apache.hadoop.hbase.client.ResultScanner;
import org.apache.hadoop.hbase.client.Scan;
import org.apache.hadoop.hbase.util.Bytes;

/**
 * 
 * hbase的创建表格 <br>
 * 需打成jar,然后在装有hbase的机器上运行<br>
 * 1.export HBASE_CLASSPATH=XXX.jar 2.hbase classname(如 hbase com.hbase.test.HbaseApp)<br>
 * 
 * 
 * @author
 * 
 *
 */
public class HbaseApp {
	public static void main(String[] args) throws Exception {
		put();
		get();
		scan();
	}

	public static void createTable() throws Exception {
		// 创建hbase的配置
		Configuration configuration = HBaseConfiguration.create();
		// 创建hbase 管理员
		HBaseAdmin admin = new HBaseAdmin(configuration);

		// 表名
		TableName tableName = TableName.valueOf("test");
		// 表的描述符
		HTableDescriptor tdesc = new HTableDescriptor(tableName);
		// 添加列族
		HColumnDescriptor family = new HColumnDescriptor("data");
		tdesc.addFamily(family);

		// 创建表
		admin.createTable(tdesc);
		System.out.println("create table over!!!");
	}

	public static void put() throws Exception {
		// 创建hbase的配置
		Configuration configuration = HBaseConfiguration.create();

		HTable table = new HTable(configuration, "test");
		Put put = new Put(Bytes.toBytes("row1")); // 指定rowkey
		// 列族,第几列,值
		put.addColumn(Bytes.toBytes("data"), Bytes.toBytes("1"), Bytes.toBytes("测试值1"));
		put.addColumn(Bytes.toBytes("data"), Bytes.toBytes("3"), Bytes.toBytes("测试值2"));
		put.addColumn(Bytes.toBytes("data"), Bytes.toBytes("2"), Bytes.toBytes("测试值3"));

		table.put(put);
		
		table.close();
	}

	public static void get() throws Exception {
		System.out.println("--------------get---------------");
		// 创建hbase的配置
		Configuration configuration = HBaseConfiguration.create();

		HTable table = new HTable(configuration, "test");

		Get get = new Get(Bytes.toBytes("row1"));
		Result result = table.get(get);
		byte[] value = result.value();
		String string = Bytes.toString(value);
		System.out.println(string);
		table.close();
	}

	public static void scan() throws IOException {
		System.out.println("--------------scan---------------");
		Configuration configuration = HBaseConfiguration.create();
		HTable table = new HTable(configuration, "test");

		Scan scan=new Scan();
		
		ResultScanner scanner = table.getScanner(scan);
		for (Result result : scanner) {
			System.out.println(result.value());
		}
		table.close();
		
	}

}
