package com.github.saint1991.samples

import java.io.{File, FileOutputStream}
import java.util.UUID
import java.util.concurrent.ThreadLocalRandom

import scala.util.control.Exception._

object CsvBench extends App {
  import Nobid._

  final val N = 100000
  final val outFile = new File("serialization/out/nobids.csv")

  val dataset = BenchmarkUtil.createDataset(N)

  // encoding
  val beforeEncode = System.currentTimeMillis()
  val encodedDatasets = encode(dataset)
  val afterEncode = System.currentTimeMillis()
  println(s"encoding time: ${afterEncode - beforeEncode} msec")


  // write to file
  val out = new FileOutputStream(outFile)
  allCatch andFinally out.close() apply writeToFile(encodedDatasets, out)


  // decoding
  val beforeDecode = System.currentTimeMillis()
  decode(encodedDatasets)
  val afterDecode = System.currentTimeMillis()
  println(s"decoding time: ${afterDecode - beforeDecode} msec")


  private def encode(dataset: Seq[Nobid]): Seq[String] = {
    dataset.map(toCsv)
  }

  private def writeToFile(dataset: Seq[String], file: FileOutputStream) = {
    dataset.foreach(r => file.write(r.getBytes("UTF-8")))
  }

  private def decode(encodedDataset: Seq[String]): Seq[Nobid] = {
    encodedDataset.map(fromCsv)
  }

}

case class Nobid(
  adnwId: Int,
  auctionId: String,
  host: String,
  loggedAt: String,
  mId: Int,
  nbr: Int,
  page: String,
  resTime: Int,
  spotId: Int,
  spotType: String,
  history: Seq[String],
  tags: Map[String, String]
)

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
      spotId = 2406,
      spotType = "A",
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

object Nobid {

  def toCsv(nobid: Nobid) ={
    val tags = nobid.tags.map(entry => s"${entry._1}#${entry._2}")
    s"${nobid.adnwId},${nobid.auctionId},${nobid.host},${nobid.loggedAt},${nobid.mId},${nobid.nbr},${nobid.page},${nobid.resTime},${nobid.spotId}_${nobid.spotType},${nobid.history.mkString("_")},${tags.mkString("_")}"
  }

  def fromCsv(csv: String) = {

    val line = csv.split(",")
    val spot = line(8).split("_")
    val tags = line(10).split("_").map { i =>
      val entry = i.split("#")
      entry(0) -> entry(1)
    }.toMap

    Nobid(
      adnwId = line(0).toInt,
      auctionId = line(1),
      host = line(2),
      loggedAt = line(3),
      mId = line(4).toInt,
      nbr = line(5).toInt,
      page = line(6),
      resTime = line(7).toInt,
      spotId = spot(0).toInt,
      spotType = spot(1),
      history = line(9).split("_"),
      tags = tags
    )
  }

}
