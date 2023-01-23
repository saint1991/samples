#[derive(Debug)]
enum Coin {
    Penny,
    Nickel,
    Dime,
    Quarter(UsState),
}

#[derive(Debug)]
enum UsState {
    Alabama,
    Alaska,
    NewYork,
    SanFrancisco,
}

impl Coin {
    fn in_cent(&self) -> u32 {
        match self {
            Coin::Penny => 1,
            Coin::Nickel => 5,
            Coin::Dime => 10,
            Coin::Quarter(_) => 25,
        }
    }
}

fn print_coin(coin: &Coin) -> () {
    match coin {
        Coin::Quarter(state) => {
            println!("{:?} is {} cent made in {:?}", coin, coin.in_cent(), state)
        }
        _ => println!("{:?} is {} cent.", coin, coin.in_cent()),
    }
}

fn print_coin_if_let(coin: &Coin) -> () {
    if let Coin::Quarter(state) = coin {
        println!("{:?}", state)
    }
}

fn plus_one(x: Option<i32>) -> Option<i32> {
    match x {
        None => None,
        Some(v) => Some(v + 1),
    }
}

fn main() {
    print_coin(&Coin::Nickel);
    print_coin(&Coin::Penny);
    print_coin(&Coin::Dime);
    print_coin(&Coin::Quarter(UsState::NewYork));
}
