package org.rubigdata

import org.apache.spark.sql.SparkSession

object RUBigDataApp {
  def main(args: Array[String]) {
    val fnm = s"/opt/hadoop/rubigdata/rubigdata-test.txt"
    val spark = SparkSession.builder.appName("RUBigDataApp").getOrCreate()
    spark.sparkContext.setLogLevel("WARN")
    val data = spark.read.textFile(fnm).cache()
    val numAs = data.filter(line => line.contains("a")).count()
    val numEs = data.filter(line => line.contains("e")).count()
    println("\n########## OUTPUT ##########")
    println("Lines with a: %s, Lines with e: %s".format(numAs, numEs))
    println("########### END ############\n")
    spark.stop()
  }
}
