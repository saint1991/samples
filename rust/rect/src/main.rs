fn main() {
    let r1 = Rect {
        width: 30,
        height: 40,
    };
    let r2 = Rect { width: 50, ..r1 };
    println!("size of rect {:#?} is {}", r1, r1.area());
    println!("size of rect {:#?} is {}", r2, r2.area());

    println!("r1 can hold r2? - {}", r1.can_hold(&r2));

    let r3 = Rect::square(2);
    println!("r3 is {:#?}", r3);
}

#[derive(Debug)]
struct Rect {
    width: u32,
    height: u32,
}

impl Rect {
    fn area(&self) -> u32 {
        self.width * self.height
    }

    fn can_hold(&self, another: &Rect) -> bool {
        self.width > another.width && self.height > another.height
    }

    // associated function
    fn square(side: u32) -> Rect {
        Rect {
            width: side,
            height: side,
        }
    }
}

struct PointTuple2d(i32, i32);
