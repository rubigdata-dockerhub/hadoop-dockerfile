name            := "RUBigDataApp"
organization    := "org.rubigdata"
version         := "1.0"
scalaVersion    := "2.12.10"

val sparkV      = "3.5.5"
val hadoopV     = "3.4.1"

// Notice: mainClass name is inferred from organization and name, may need adaptation!
Compile / packageBin / mainClass := Some(organization.value + "." + name.value)
assembly / mainClass             := Some(organization.value + "." + name.value)

resolvers += "jitpack" at "https://jitpack.io"

libraryDependencies ++= Seq(
  "org.apache.spark" %% "spark-core" % sparkV % "provided",
  "org.apache.spark" %% "spark-sql"  % sparkV % "provided",
  "org.apache.hadoop" %  "hadoop-client" % hadoopV % "provided",
  "org.jsoup"         % "jsoup"          % "1.11.3",
  "org.netpreserve"   % "jwarc"          % "0.30.0"
)
