Add to `hadoop-env.sh`, or add to the config files a different setting:

    export HDFS_NAMENODE_USER=root
    export HDFS_DATANODE_USER=root
    export HDFS_SECONDARYNAMENODE_USER=root
    export YARN_RESOURCEMANAGER_USER=root
    export YARN_NODEMANAGER_USER=root

Add the new HadoopConcatGz classes and dependencies.


Add rubigdata.tgz to project docker;
and, add to SBT build file to avoid multiple main class errors (but test this):
mainClass in (Compile, packageBin) := Some("org.rubigdata.RUBigDataApp")

_More from 2020?_



build.sbt:

name            := "RUBigDataTest"
organization    := "org.rubigdata"
version         := "1.0"
scalaVersion    := "2.12.10"

val sparkV      = "2.4.4"
val hadoopV     = "3.2.1"

// Notice: mainClass name is inferred from organization and name, may need adaptation!
mainClass in (Compile, packageBin) := Some(organization.value + "." + name.value)
mainClass in assembly              := Some(organization.value + "." + name.value)

libraryDependencies ++= Seq(
  "org.apache.spark" %% "spark-core" % sparkV % "provided",
  "org.apache.spark" %% "spark-sql"  % sparkV % "provided",
  "org.apache.hadoop" %  "hadoop-client" % hadoopV % "provided",
  "org.jsoup"         % "jsoup"          % "1.11.3",
  "com.github.helgeho" % "hadoop-concat-gz" % "1.2.3-preview" from "file:///rubigdata/lib/hadoop-concat-gz-1.2.3-preview.jar"
)
