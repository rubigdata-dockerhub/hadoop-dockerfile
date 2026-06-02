name            := "RUBigDataApp"
organization    := "org.rubigdata"
version         := "1.0"
scalaVersion    := "2.12.10"

val sparkV      = "3.5.5"
val hadoopV     = "3.4.1"

// Notice: mainClass name is inferred from organization and name, may need adaptation!
Compile / packageBin / mainClass := Some(organization.value + "." + name.value)
assembly / mainClass             := Some(organization.value + "." + name.value)

// Catch-all for Coursier version conflicts (sbt 1.5+ made these errors)
ThisBuild / evictionErrorLevel           := Level.Warn
ThisBuild / libraryDependencySchemes     += "*" % "*" % VersionScheme.Always

resolvers += "jitpack" at "https://jitpack.io"

libraryDependencies ++= Seq(
  "org.apache.spark" %% "spark-core" % sparkV % "provided",
  "org.apache.spark" %% "spark-sql"  % sparkV % "provided",
  "org.apache.hadoop" %  "hadoop-client" % hadoopV % "provided",
  "com.github.rubigdata" %  "warc-for-spark"   % "0.3.0"
      exclude("io.netty", "*")
      exclude("org.apache.hadoop", "*"),
  "org.jsoup"         % "jsoup"          % "1.11.3",
  "org.netpreserve"   % "jwarc"          % "0.30.0"
)

assembly / assemblyMergeStrategy := {
  case PathList("META-INF", "versions", "9", "module-info.class") => MergeStrategy.discard
  case PathList("META-INF", "org", "apache", "logging", "log4j", _*) => MergeStrategy.first
  case PathList("google", "protobuf", _*)                            => MergeStrategy.first
  case "module-info.class"                                           => MergeStrategy.discard
  case "arrow-git.properties"                                        => MergeStrategy.first
  case x =>
    val oldStrategy = (assembly / assemblyMergeStrategy).value
    oldStrategy(x)
}

