package com.github.saint1991.samples

import java.io.File

import org.apache.avro.Schema
import org.apache.avro.file.DataFileWriter
import org.apache.avro.specific.{SpecificDatumReader, SpecificDatumWriter}

import scala.util.control.Exception.allCatch

object NobidGen extends App {

  final val Schema = Nobid.SCHEMA$
  val writer = new SpecificDatumWriter[Nobid](Schema)
  val reader = new SpecificDatumReader[Nobid](Schema)

  final val N = 100000
  final val outFile = new File("serialization/out/nobids.avro")
  final val outFileWriter = new DataFileWriter[Nobid](writer)

  val dataset = BenchmarkUtil.createDataset(N)

  // write to file
  writeToFile(dataset, Schema, outFile, outFileWriter)

  private def writeToFile(dataset: Seq[Nobid], writerSchema: Schema, file: File, writer: DataFileWriter[Nobid]) = allCatch andFinally {
    writer.flush()
    writer.close()
  } apply {
    writer.create(writerSchema, file)
    dataset.foreach { nobid =>
      writer.append(nobid)
    }
  }
}
