package com.github.saint1991.samples

import java.io.{ByteArrayInputStream, ByteArrayOutputStream, File}
import java.util.UUID
import java.util.concurrent.ThreadLocalRandom

import org.apache.avro.Schema
import org.apache.avro.file.DataFileWriter
import org.apache.avro.io.{DecoderFactory, EncoderFactory}
import org.apache.avro.specific.{SpecificDatumReader, SpecificDatumWriter}

import scala.util.control.Exception._

object AvroBench extends App {

  final val Schema = Nobid.SCHEMA$
  val writer = new SpecificDatumWriter[Nobid](Schema)
  val reader = new SpecificDatumReader[Nobid](Schema)

  final val N = 100000
  final val outFile = new File("serialization/out/nobids.avro")
  final val outFileWriter = new DataFileWriter[Nobid](writer)

  val dataset = BenchmarkUtil.createDataset(N)

  // encoding
  val beforeEncode = System.currentTimeMillis()
  val encodedDatasets = encode(dataset, writer)
  val afterEncode = System.currentTimeMillis()
  println(s"encoding time: ${afterEncode - beforeEncode} msec")

  // write to file
  writeToFile(dataset, Schema, outFile, outFileWriter)

  // decoding
  val beforeDecode = System.currentTimeMillis()
  decode(encodedDatasets)
  val afterDecode = System.currentTimeMillis()
  println(s"decoding time: ${afterDecode - beforeDecode} msec")

  private def encode(dataset: Seq[Nobid], writer: SpecificDatumWriter[Nobid]): Seq[Array[Byte]] = {
    dataset.map { nobid =>
      val ostream = new ByteArrayOutputStream()
      val encoder = EncoderFactory.get().binaryEncoder(ostream, null)
      writer.write(nobid, encoder)
      encoder.flush()
      ostream.toByteArray
    }
  }

  private def writeToFile(dataset: Seq[Nobid], writerSchema: Schema, file: File, writer: DataFileWriter[Nobid]) = allCatch andFinally {
    writer.flush()
    writer.close()
  } apply {
    writer.create(writerSchema, file)
    dataset.foreach { nobid =>
      writer.append(nobid)
    }
  }

  private def decode(encoded: Seq[Array[Byte]]): Seq[Nobid] = {
    encoded.map { record =>
      val istream = new ByteArrayInputStream(record)
      val decoder = DecoderFactory.get.binaryDecoder(istream, null)
      reader.read(null, decoder)
    }
  }
}


object BenchmarkUtil {

  def createDataset(n: Int): Seq[Nobid] = for {
    i <- 1 to n
    data = Nobid(
      adnwId = ThreadLocalRandom.current().nextInt(0, 8),
      auctionId = UUID.randomUUID().toString,
      host = "lodeo-prd-dsp03",
      loggedAt = "2017-06-30 09:07:37.677",
      mId = 234,
      nbr = 6260,
      page = Some("http://diamond.jp/articles/a/15434"),
      resTime = 4,
      spot = spotRecord(
        id = 2406,
        `type` = spotType.A
      ),
      history = List(
        "a",
        "b",
        "c"
      ),
      tags = Map(
        "media" -> "facebook",
        "ssp" -> "profitx"
      )
    )
  } yield data
}
