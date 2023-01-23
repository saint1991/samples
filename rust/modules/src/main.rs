mod front_of_house;

use front_of_house::serving;

mod restaurant {
    const NAME: &str = "Sawayaka";

    pub mod hosting {

        pub fn add_to_wait_list(order: String, list: &mut Vec<String>) {
            println!("Add {} to wait list", order);
            list.push(order);
        }

        pub fn seat_at_table(table: String) {
            println!("Seat at table {} at restaurant {}", table, super::NAME);
        }
    }
}

fn main() {
    let mut wait_list = Vec::new();

    serving::take_order(String::from("Apple pie"));

    // relative
    restaurant::hosting::seat_at_table(String::from("North Table"));

    // absolute
    crate::restaurant::hosting::add_to_wait_list(String::from("Grape"), &mut wait_list);
    println!("{:?}", wait_list);

    self::restaurant::hosting::add_to_wait_list(String::from("Apple"), &mut wait_list);
    println!("{:?}", wait_list);
}
