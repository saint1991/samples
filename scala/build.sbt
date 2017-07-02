
scalaVersion in ThisBuild := "2.12.1"


lazy val csvBench = (project in file("serialization/csv-bench"))
  .settings(
    name := "csv-bench",
    mainClass := Some("com.github.saint1991.samples.CsvBench")
  )

lazy val jsonBench = (project in file("serialization/json-bench"))
  .settings(
    name := "json-bench",
    mainClass := Some("com.github.saint1991.samples.JsonBench"),
    libraryDependencies ++= Seq(
      "io.circe" %% "circe-core" % "0.8.0",
      "io.circe" %% "circe-generic" % "0.8.0",
      "io.circe" %% "circe-parser" % "0.8.0"
    )
  )

lazy val protobufBench = (project in file("serialization/protobuf-bench"))
  .settings(
    name := "protobuf-bench",
    mainClass := Some("com.github.saint1991.samples.ProtoBufBench"),
    libraryDependencies ++= Seq(
      "com.trueaccord.scalapb" %% "scalapb-runtime" % com.trueaccord.scalapb.compiler.Version.scalapbVersion % "protobuf"
    )
  )
  .settings( // for ScalaPB
    PB.targets in Compile := Seq(scalapb.gen() -> (sourceManaged in Compile).value),
    PB.protoSources in Compile := Seq(file("../serialization/protocol-buffers"))
  )

lazy val thriftBench = (project in file("serialization/thrift-bench"))
  .settings(
    name := "thrift-bench",
    mainClass := Some("com.github.saint1991.samples.ThriftBench")
  )

lazy val avroBench = (project in file("serialization/avro-bench"))
  .settings(specificAvroSettings)
  .settings(
    sourceDirectory in avroConfig := file("../serialization/avro"),
    scalaSource in avroConfig := (sourceManaged in Compile).value
  )
  .settings(
    name := "avro-bench",
    mainClass := Some("com.github.saint1991.samples.AvroBench"),
    libraryDependencies ++= Seq(
      "org.apache.avro" % "avro" % "1.8.2"
    )
  )
