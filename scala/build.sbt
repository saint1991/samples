
lazy val circe = (project in file("circe")).settings(
  name := "circe-sample",
  libraryDependencies ++= Seq(
    "io.circe" %% "circe-core" % "0.9.3",
    "io.circe" %% "circe-parser" % "0.9.3",
    "org.typelevel" %% "cats-core" % "1.1.0"
  ),
  scalacOptions ++= Seq(
    "-encoding", "UTF-8",
    "-deprecation",
    "-feature",
    "-language:higherKinds",
    "-Xlint",
    "-Ypartial-unification"
  ),
  addCompilerPlugin("org.spire-math" %% "kind-projector" % "0.9.3")
)