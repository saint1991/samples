package com.github.saint1991.samples

import java.io.{File, FileOutputStream, OutputStream}
import java.util.UUID
import java.util.concurrent.ThreadLocalRandom

import com.github.saint1991.samples.nobid.Nobid
import com.github.saint1991.samples.spot.{Spot, SpotType}


object ProtoBufBench extends App {

  final val N = 1000000
  final val outFile = new File("nobids.protobuf")

  val dataset = BenchmarkUtil.createDataset(N)

  // encoding
  val beforeEncode = System.currentTimeMillis()
  val encodedDatasets = encode(dataset)
  val afterEncode = System.currentTimeMillis()
  println(s"encoding time: ${afterEncode - beforeEncode} msec")


  // write to file
  val out = new FileOutputStream(outFile)
  writeToFile(dataset, out)


  // decoding
  val beforeDecode = System.currentTimeMillis()
  decode(encodedDatasets)
  val afterDecode = System.currentTimeMillis()
  println(s"decoding time: ${afterDecode - beforeDecode} msec")



  private def encode(dataset: Seq[Nobid]): Seq[Array[Byte]] = {
    dataset.map(_.toByteArray)
  }

  private def writeToFile(dataset: Seq[Nobid], file: OutputStream) = {
    dataset.foreach(r => r.writeTo(file))
  }

  private def decode(encodedDataset: Seq[Array[Byte]]): Seq[Nobid] = {
    encodedDataset.map(Nobid.parseFrom)
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
      spot = Some(Spot(
        id = 2406,
        `type` = SpotType.S
      )),
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
