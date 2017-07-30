
import scala.io.StdIn

object Main {

  def main(args: Array[String]): Unit = {
    val deg, dist = (StdIn.readInt(), StdIn.readInt()) match {
      case (degree, distance) if distance == 0 => (Degree.C, 0)
      case (degree, distance) => (Degree.deg(degree), Distance.dist(distance))
    }

    println(s"$deg $dist")
  }
}

object Degree extends Enumeration {
  final val N = Value("N")
  final val NNE = Value("NNE")
  final val NE = Value("NE")
  final val ENE = Value("ENE")
  final val E = Value("E")
  final val ESE = Value("ESE")
  final val SE = Value("SE")
  final val SSE = Value("SSE")
  final val S = Value("S")
  final val SSW = Value("SSW")
  final val SW = Value("SW")
  final val WSW = Value("WSW")
  final val W = Value("W")
  final val WNW = Value("WNW")
  final val NW = Value("NW")
  final val NNW = Value("NNW")
  final val C = Value("C")

  def deg(deg: Int): Value = deg / 10.0 match {
    case x if 11.25 <= x && x < 33.75 => NNE
    case x if 33.75 <= x && x < 56.25 => NE
    case x if 56.25 <= x && x < 78.75 => ENE
    case x if 78.75 <= x && x < 101.25 => E
    case x if 101.25 <= x && x < 123.75 => ESE
    case x if 123.75 <= x && x < 146.25 => SE
    case x if 146.25 <= x && x < 168.75 => SSE
    case x if 168.75 <= x && x < 191.25 => S
    case x if 191.25 <= x && x < 213.75 => SSW
    case x if 213.75 <= x && x < 236.25 => SW
    case x if 236.25 <= x && x < 258.75 => WSW
    case x if 258.75 <= x && x < 281.25 => W
    case x if 281.25 <= x && x < 303.75 => WNW
    case x if 303.75 <= x && x < 326.25 => NW
    case x if 326.25 <= x && x < 348.75 => NNW
    case _ => N
  }
}

object Distance extends Enumeration {
  def dist(dist: Int): Int = (BigDecimal(dist) / BigDecimal(60.0)).setScale(1, BigDecimal.RoundingMode.HALF_UP) match {
    case x if 0.0 <= x && x <= 0.2 => 0
    case x if 0.3 <= x && x <= 1.5 => 1
    case x if 1.6 <= x && x <= 3.3 => 2
    case x if 3.4 <= x && x <= 5.4 => 3
    case x if 5.5 <= x && x <= 7.9 => 4
    case x if 8.0 <= x && x <= 10.7 => 5
    case x if 10.8 <= x && x <= 13.8 => 6
    case x if 13.9 <= x && x <= 17.1 => 7
    case x if 17.2 <= x && x <= 20.7 => 8
    case x if 20.8 <= x && x <= 24.4 => 9
    case x if 24.5 <= x && x <= 28.4 => 10
    case x if 28.5 <= x && x <= 32.6 => 11
    case x if 32.7 <= x => 12
    case _ => -1
  }
}


