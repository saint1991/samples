package com.github.saint1991.samples

import io.circe._
import io.circe.parser._
import io.circe.syntax._
import io.circe.generic.auto._
import java.io.{File, FileOutputStream}
import java.util.UUID
import java.util.concurrent.ThreadLocalRandom


object JsonBench extends App {
  final val N = 100000
  final val outFile = new File("serialization/out/nobids.json")

  implicit val encoder = Encoder.enumEncoder(SpotType)
  implicit val decoder = Decoder.enumDecoder(SpotType)

  val dataset = BenchmarkUtil.createDataset(N)

  // encoding
  val beforeEncode = System.currentTimeMillis()
  val encodedDatasets = encode(dataset)
  val afterEncode = System.currentTimeMillis()
  println(s"encoding time: ${afterEncode - beforeEncode} msec")

  val out = new FileOutputStream(outFile)
  writeToFile(encodedDatasets, out)

  val beforeDecode = System.currentTimeMillis()
  val decodedDatasets = decode(encodedDatasets)
  val afterDecode = System.currentTimeMillis()
  println(s"decoding time: ${afterDecode - beforeDecode} msec")

  private def encode(nobids: Seq[Nobid]): Seq[String] = {
    nobids.map(_.asJson.noSpaces)
  }

  private def writeToFile(encoded: Seq[String], out: FileOutputStream) = {
    encoded.map(_.getBytes("UTF-8")).foreach(out.write)
  }

  private def decode(encoded: Seq[String]): Seq[Nobid] = {
    encoded.map(str => parse(str).right.get.as[Nobid].right.get)
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
      page = "http://diamond.jp/articles/-/15434",
      resTime = 4,
      spot = Spot(
        id = 2406,
        `type` = SpotType.S
      ),
      history = Seq(
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




object SpotType extends Enumeration {
  final val A = Value(1)
  final val S = Value(2)
}

case class Spot(
  id: Int,
  `type`: SpotType.Value
)

case class Nobid(
  adnwId: Int,
  auctionId: String,
  host: String,
  loggedAt: String,
  mId: Int,
  nbr: Int,
  page: String,
  resTime: Int,
  spot: Spot,
  history: Seq[String],
  tags: Map[String, String]
)

