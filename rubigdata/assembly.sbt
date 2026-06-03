assembly / mainClass := Some(organization.value + "." + name.value)

ThisBuild / evictionErrorLevel       := Level.Warn
ThisBuild / libraryDependencySchemes += "*" % "*" % VersionScheme.Always

assembly / assemblyMergeStrategy := {
  case PathList("META-INF", "versions", "9", "module-info.class") => MergeStrategy.discard
  case PathList("META-INF", "org", "apache", "logging", "log4j", _*) => MergeStrategy.first
  case PathList("google", "protobuf", _*)  => MergeStrategy.first
  case "module-info.class"                 => MergeStrategy.discard
  case "arrow-git.properties"              => MergeStrategy.first
  case x =>
    val oldStrategy = (assembly / assemblyMergeStrategy).value
    oldStrategy(x)
}
