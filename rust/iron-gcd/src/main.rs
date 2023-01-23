extern crate iron;
#[macro_use]
extern crate mime;
extern crate router;

use std::str::FromStr;

use iron::prelude::*;
use iron::status;
use router::Router;
use std::num::ParseIntError;
use urlencoded::UrlEncodedBody;

fn main() {
    println!("serving on http://localhost:3000");
    Iron::new(router()).http("localhost:3000").unwrap();
}

fn router() -> Router {
    let mut r = Router::new();
    r.get("/", get_form, "root");
    r.post("/gcd", post_gcd, "gcd");
    r
}

fn get_form(_request: &mut Request) -> IronResult<Response> {
    Ok(Response::new()
        .set(status::Ok)
        .set(mime!(Text/Html; Charset=Utf8))
        .set(
            r#"
            <title>GCD Calculator</title>
            <form action="/gcd" method="post">
                <input type="text" name="n"/>
                <input type="text" name="n"/>
                <button type="submit">Compute</button>
             </form>
        "#,
        ))
}

fn bad_request(message: &str) -> Response {
    Response::new().set(status::BadRequest).set(message)
}

fn post_gcd(request: &mut Request) -> IronResult<Response> {
    Ok(
        match request
            .get_ref::<UrlEncodedBody>()
            .map(|f| match f.get("n") {
                None => Err(bad_request("form data has no n parameter¥n")),
                Some(ss) => ss
                    .iter()
                    .map(|s| u64::from_str(&s))
                    .collect::<Result<Vec<u64>, ParseIntError>>()
                    .map_err(|e| {
                        bad_request(&format!("Error parsing from data {:?}¥n", e).to_string())
                    }),
            })
            .map_err(|e| bad_request(&format!("Error parsing from data: {:?}¥n", e)))
        {
            Err(resp) => resp,
            Ok(Err(resp)) => resp,
            Ok(Ok(nums)) => {
                let mut d = nums[0];
                for m in &nums[1..] {
                    d = gcd(d, *m);
                }
                Response::new()
                    .set(status::Ok)
                    .set(mime!(Text/Html; Charset=Utf8))
                    .set(format!(
                        "The greatest common divisor of the numbers {:?} is <b>{}</b>",
                        nums, d
                    ))
            }
        },
    )
}

fn gcd(mut n: u64, mut m: u64) -> u64 {
    assert!(n != 0 && m != 0);
    while m != 0 {
        if m < n {
            let temp = m;
            m = n;
            n = temp;
        }
        m = m % n;
    }
    n
}
