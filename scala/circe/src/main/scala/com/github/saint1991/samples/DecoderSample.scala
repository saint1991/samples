package com.github.saint1991.samples

import cats.syntax.apply._

import io.circe._
import io.circe.parser._

case class Foo(name: String, age: Int)

object FooDecoder {

  implicit val decoder: Decoder[Foo] = Decoder.instance {
    cursor => for {
      name <- cursor.get[String]("name")
      age <- cursor.get[Int]("age")
    } yield Foo(name, age)
  }

  implicit val accDecoder: Decoder[Foo] = (
    Decoder.instance(_.get[String]("name")),
    Decoder.instance(_.get[Int]("age"))
  ).mapN(Foo.apply)

}

object Main extends App {
  println(decodeAccumulating("{}")(FooDecoder.decoder))
  println(decodeAccumulating("{}")(FooDecoder.accDecoder))
}
