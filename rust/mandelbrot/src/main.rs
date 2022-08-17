extern crate num;
use num::Complex;

#[allow(dead_code)]
fn complex_square_add_loop(c: f64) {
    let mut z = Complex { re: 0.0, im: 0.0 };
    let mut x = 0;
    loop {
        x = x * x + c;
    }
}

fn main() {

}