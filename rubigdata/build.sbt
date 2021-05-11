name            := "RUBigDataApp"
version         := "1.0"
scalaVersion    := "2.12.10"

val sparkV      = "3.1.1"
val hadoopV     = "3.2.2"
val jwatV       = "1.0.0"

resolvers += "jitpack" at "https://jitpack.io"

libraryDependencies ++= Seq(
  "org.apache.spark" %% "spark-core" % sparkV % "provided",
  "org.apache.spark" %% "spark-sql"  % sparkV % "provided",
  "org.apache.hadoop" %  "hadoop-client" % hadoopV % "provided"
)
