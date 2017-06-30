
scalaVersion in ThisBuild := "2.12.1"

lazy val protobufBench = (project in file("protobuf-bench"))
  .settings(
    name := "protobuf-bench",
    mainClass := Some("com.github.saint1991.samples.ProtoBufBench"),
    libraryDependencies ++= Seq(
      "com.trueaccord.scalapb" %% "scalapb-runtime" % com.trueaccord.scalapb.compiler.Version.scalapbVersion % "protobuf"
    )
  )
  .settings( // for ScalaPB
    PB.targets in Compile := Seq(scalapb.gen() -> (sourceManaged in Compile).value),
    PB.protoSources in Compile := Seq(file("../protocol-buffers"))
  )