#[derive(Debug)]
enum IpAddress {
    V4(u8, u8, u8, u8),
    V6(String),
}

#[derive(Debug)]
enum ObjectUrl {
    S3 {
        url: String,
        access_key_id: String,
        secret_access_key: String,
    },
    Gcs {
        url: String,
        service_account_key: String,
    },
    Http(String),
    Unknown,
}

impl ObjectUrl {
    fn from(url: String) -> ObjectUrl {
        return if url.starts_with("s3://") {
            ObjectUrl::S3 {
                url,
                access_key_id: String::from(""),
                secret_access_key: String::from(""),
            }
        } else if url.starts_with("gs://") {
            ObjectUrl::Gcs {
                url,
                service_account_key: String::from(""),
            }
        } else if url.starts_with("http") {
            ObjectUrl::Http(url)
        } else {
            ObjectUrl::Unknown
        }
    }
}

fn main() {
    let v4 = IpAddress::V4(127, 0, 0, 1);
    let v6 = IpAddress::V6(String::from("::1"));

    println!("{:?}", v4);
    println!("{:?}", v6);

    println!(
        "{:?}",
        ObjectUrl::Http(String::from("http://localhost:8080/add"))
    );
}
